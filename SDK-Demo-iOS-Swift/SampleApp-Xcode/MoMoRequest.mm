//
//  BaseRequest.m
//  MomoTransfer
//
//  Created by nvthinh on 5/19/14.
//  Copyright (c) 2014 M_Service. All rights reserved.
//

#import "MoMoRequest.h"
#import "MoMoViewController.h"
#import "AppDelegate.h"
#import "ClassGift.h"
#import "MomoProto.pb.h"

#define DEFAULT_TIME_OUT_INTERVAL   45000  // 45 s
#define DEFAULT_DELETE_INTERVAL     150000  // 150 s

static NSMutableDictionary* _requestDict;       // contains request for cmdindex key

static NSTimer*             _timeoutTimer;

static long long            _lastCmdIndex;
static dispatch_queue_t     _sendRequestQueue;

@implementation MoMoRequest

#pragma mark - Init

- (id) initWithDelegate:(id<ResponseCenterDelegate>) delegate{
    if(self = [super init]){
        _delegate                   = delegate;
        _timeout                    = DEFAULT_TIME_OUT_INTERVAL;
        _needShowTimeoutAlert       = NO;
        _needRemoveWhenReceiveReply = YES;
    }
    return self;
}

#pragma mark - Send request

- (void) sendRequestWithMsgData:(NSData*) data cmdType:(int) cmdType{
    // serial queue
    if(!_sendRequestQueue){
        _sendRequestQueue = dispatch_queue_create("momoSendRequestQueue", NULL);
    }
    
    dispatch_sync(_sendRequestQueue, ^{
        
    // if not hello yet -> try to open socket connection
    if(![MomoTransferAppSingleton shareInstance].isHello && cmdType != HELLO){
        NSLog(@">| %d", cmdType);
        [[AppDelegate topMoMoVC] hideProcess];
        [[NetworkCenter shareInstance] openSocketConnection];
        [[AppDelegate topMoMoVC] callNetworkAlertBox];
        return;
    }
    
    // alloc dicts if needed
    if(!_requestDict){
        _requestDict = [[NSMutableDictionary alloc] init];
    }
    
    if(!_timeoutTimer){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [MoMoRequest startCheckTimeOut];
        });
    }
    
    // send request in back ground thread
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        // cmd index
        _cmdIndex = [CommonUlti getCurrentMSTimeInterval];
        
        // prevent outputstream from writing concurrently
        if(ABS(_lastCmdIndex - _cmdIndex) < 99){
            [NSThread sleepForTimeInterval:0.15];
            
            // get new time interval
            _cmdIndex = [CommonUlti getCurrentMSTimeInterval];
        }
        
        if(_cmdIndex <= _lastCmdIndex){
            _cmdIndex = _lastCmdIndex + 1;
        }
        
        _lastCmdIndex = _cmdIndex;
        
        // cmd type
        _cmdType = cmdType;
        
        NSLog(@":> %d, %lld", cmdType, _cmdIndex);
        
        // save req
        [_requestDict setObject: self forKey: [MoMoRequest keyForCmdIndex: _cmdIndex]];
        
        if (_cmdType == TRANSFER_REQUEST) {
            NSString *commandIndex = [NSString stringWithFormat:@"%lld",_cmdIndex];
            NSLog(@"<<cmd index: %@",commandIndex);
            [[NSUserDefaults standardUserDefaults] setObject:commandIndex forKey:TRANSFER_REQUEST_COMMAND_INDEX_LATEST];
        }
        
        // create send data
        NSData *sendData = [PakageClass createPakageFromData: data withCmdType:cmdType cmdIndex: _cmdIndex];
        
        // send request
        [[NetworkCenter shareInstance] sendRequest:sendData];
//    });
    });
}

#pragma mark - Check timeout

+ (void) stopAllRequests{
    [_requestDict removeAllObjects];
    _requestDict = nil;
    
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    
    _sendRequestQueue = nil;
}

+ (void) startCheckTimeOut{
    NSLog(@"Start check timeout timer");
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(checkTimeOut)
                                                   userInfo:nil
                                                    repeats:YES];
}

+ (void) checkTimeOut{
    @synchronized(_requestDict){
    long long currentTime = [CommonUlti getCurrentMSTimeInterval];
    
    NSMutableArray* needRemoveKeys = [[NSMutableArray alloc] init];
    
    for(NSString* key in _requestDict.keyEnumerator){
        // cmd index
        long long cmdIndex = [key longLongValue];
        
        // request
        MoMoRequest* req = [MoMoRequest reqForCmdIndex: cmdIndex];
        
        // time out
        if(req.timeout > 0 && currentTime > cmdIndex + req.timeout){
            
            id<ResponseCenterDelegate> delegate = req.delegate;

            if(delegate){
                    // time out
                    
                if([delegate respondsToSelector: @selector(requestTimeout:errorString:)]){
                    NSLog(@"<<time out: %lld, Cmdype %i >>", cmdIndex, req.receiveCmdType);
                    [delegate requestTimeout: req errorString:STR_CAN_NOT_CONNECT];
                }
            }
            
            // add to remove after
            [needRemoveKeys addObject:key];
        }
    }
    
    // remove
    for(NSString* key in needRemoveKeys){
        [_requestDict removeObjectForKey: key];
    }
    }
}

+ (void) removeRequestWithCmdIndex:(long long) cmdIndex{
    NSString* key = [MoMoRequest keyForCmdIndex: cmdIndex];
    [MoMoRequest removeRequestWithKey: key];
}

+ (void) removeRequestWithKey:(NSString*) key{
    @synchronized(_requestDict){
    MoMoRequest* req = [self reqForCmdIndex: [key longLongValue]];
    
    // some request need to received n- response without time out -> don't remove it
    if(req && req.needRemoveWhenReceiveReply){
//        NSLog(@"add rm list: %@", key);
        [_requestDict removeObjectForKey: key];
    }
    }
}

#pragma mark - Set timeout

- (void) setTimeout:(int)timeout{
    _timeout = timeout;
    
    if(_timeout == 0){
        _needRemoveWhenReceiveReply = NO;
    }
}

#pragma mark - Delegate call back

- (void) sendDelegateResponseResult:(BOOL)      result{
    if([_delegate respondsToSelector: @selector(request:receivedResponseResult:)]){
        [_delegate request: self receivedResponseResult: result];
    }
}

- (void) sendDelegateResponseResult:(BOOL)      result
                          errorCode:(int)       errorCode
                        errorString:(NSString*) errorString{
    if([_delegate respondsToSelector: @selector(request:receivedResponseResult:errorCode:errorString:)]){
        [_delegate request: self
    receivedResponseResult: result
                 errorCode: errorCode
               errorString:errorString];
    }
}

- (void) sendDelegateResponseResultGift:(ClassGift*) gift
                              errorCode:(long)       errorCode
                                  point:(long)   point {
    if ([_delegate respondsToSelector:@selector(request:receivedResponseResultGift:errorCode:point:)]) {
        [_delegate request:self receivedResponseResultGift:gift errorCode:errorCode point:point];
    }
}

#pragma mark - Indexing

+ (NSString*) keyForCmdIndex:(long long) cmdIndex{
    return [NSString stringWithFormat:@"%lld", cmdIndex];
}

+ (MoMoRequest*) reqForCmdIndex:(long long) cmdIndex {
    id delegate = [_requestDict objectForKey: [MoMoRequest keyForCmdIndex: cmdIndex]];
    return delegate;
}

#pragma mark - Received standard reply

-(void)receivedStandardReply:(NSData *)bodyData{
    com::mservice::momo::msg::StandardReply *replyBody = new com::mservice::momo::msg::StandardReply();
    replyBody->ParseFromArray([bodyData bytes], [bodyData length]);
    
    NSLog(@"srep: %d, %d, %@", replyBody->result(), replyBody->rcode(), [CommonUlti stringForCStr:replyBody->desc().c_str()]);
    
    [self sendDelegateResponseResult:replyBody->result()
                           errorCode:replyBody->rcode()
                         errorString:[CommonUlti stringForCStr:replyBody->desc().c_str()]];
}

//- (void) dealloc{
//    NSLog(@"deall: %lld", self.cmdIndex);
//}
@end
