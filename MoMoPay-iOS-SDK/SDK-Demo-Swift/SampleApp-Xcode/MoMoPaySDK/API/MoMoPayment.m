//
//  MoMoPayment.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//

#import "MoMoPayment.h"
#import "MoMoConfig.h"
#import <UIKit/UIKit.h>

#define stringIndexOf(fulltext, textcompare) ([fulltext rangeOfString: textcompare ].location != NSNotFound)

static MoMoPayment *shareInstant = nil;
static NSMutableDictionary *paymentInfo = nil;
@implementation MoMoPayment

+(MoMoPayment*)shareInstant{
    if (!shareInstant) {
        shareInstant = [[super allocWithZone:NULL] init];
    }
    return shareInstant;
}

-(void)requestToken{
    if ([paymentInfo isKindOfClass:[NSNull class]]) {
        NSLog(@"<MoMoPay> Payment information should not be null.");
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterStartRequestToken" object:nil];
    
    //Open MoMo App to get token
    if ([paymentInfo isKindOfClass:[NSMutableDictionary class]]) {
        NSString *inputParams = [NSString stringWithFormat:@"action=%@&partner=merchant",[MoMoConfig getAction]];
        [paymentInfo setValue:[MoMoConfig getMerchantcode]       forKey:MOMO_PAY_CLIENT_MERCHANT_CODE_KEY];
        [paymentInfo setValue:[MoMoConfig getMerchantname]       forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY];
        [paymentInfo setValue:[MoMoConfig getMerchantnameLabel]  forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY];
        [paymentInfo setValue:[MoMoConfig getPublickey]          forKey:MOMO_PAY_CLIENT_PUBLIC_KEY_KEY];
        [paymentInfo setValue:[MoMoConfig getIPAddress]          forKey:MOMO_PAY_CLIENT_IP_ADDRESS_KEY];
        [paymentInfo setValue:[MoMoConfig getDeviceInfoString]   forKey:MOMO_PAY_CLIENT_OS_KEY];
        [paymentInfo setValue:[MoMoConfig getAppBundleId]        forKey:MOMO_PAY_CLIENT_APP_SOURCE_KEY];
        [paymentInfo setValue:MOMO_PAY_SDK_VERSION               forKey:MOMO_PAY_SDK_VERSION_KEY];
        
        for (NSString *key in [paymentInfo allKeys]) {
            if ([paymentInfo objectForKey:key] != nil) {
                inputParams = [inputParams stringByAppendingFormat:@"&%@=%@",key,[paymentInfo objectForKey:key]];
            }
        }
        
        NSString *appSource = [NSString stringWithFormat:@"%@://?%@",[MOMO_APP_BUNDLE_ID lowercaseString],inputParams];
        appSource = [appSource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *ourURL = [NSURL URLWithString:appSource];
        if ([[UIApplication sharedApplication] canOpenURL:ourURL]) {
            [[UIApplication sharedApplication] openURL:ourURL];
        }
        else{
            NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:MOMO_APP_ITUNES_DOWNLOAD_PATH]];
            if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                [[UIApplication sharedApplication] openURL:appStoreURL];
            }
        }
    }
    
    
}

-(void)requestPayment:(NSMutableDictionary*)parram{

    NSString *requestBody = [NSString stringWithFormat:@"{\"data\":\"%@\",\"hash\":\"%@\",\"ipaddress\":\"%@\",\"merchantcode\":\"%@\",\"phonenumber\":\"%@\"}",[parram objectForKey:@"data"],[parram objectForKey:@"hash"],[parram objectForKey:@"ipaddress"],[MoMoConfig getMerchantcode],[parram objectForKey:@"phonenumber"]];
    
    NSLog(@">>Body payment: %@",requestBody);
    
    NSData *postData = [requestBody dataUsingEncoding:NSUTF8StringEncoding];;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:MOMO_PAYMENT_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSURLResponse *response;
        NSError *err;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (!err) {
                NSError *errJson;
                id responseObject = [NSJSONSerialization JSONObjectWithData:GETReply options:0 error:&errJson];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterCreateOrderReceived" object:responseObject];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterCreateOrderReceived" object:err.description];
            }
        });
    });
}

-(void)handleOpenUrl:(NSURL*)url
{
    NSString *sourceURI = [url absoluteString];
    NSDictionary *response = [self dictionaryFromUrlParram:sourceURI];
    NSString *partner = [NSString stringWithFormat:@"%@",[response objectForKey:@"fromapp"]];
    if (![partner isKindOfClass:[NSNull class]] && [[partner lowercaseString] isEqualToString:@"momotransfer"]) {
        if ([response count]) {
            
            NSString *status = [NSString stringWithFormat:@"%@",[response objectForKey:@"status"]];
            NSString *message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
            
            if ([status isEqualToString:MOMO_TOKEN_RESPONSE_SUCCESS]) {
                NSLog(@"<MoMoPay> SUCESS TOKEN.");
            }
            else if ([status isEqualToString:MOMO_TOKEN_RESPONSE_REGISTER_PHONE_NUMBER_REQUIRE]) {
                NSLog(@"<MoMoPay> REGISTER_PHONE_NUMBER_REQUIRE.");
            }
            else if ([status isEqualToString:MOMO_TOKEN_RESPONSE_LOGIN_REQUIRE]) {
                NSLog(@"<MoMoPay> LOGIN_REQUIRE.");
            }
            else if ([status isEqualToString:MOMO_TOKEN_RESPONSE_NO_WALLET]) {
                NSLog(@"<MoMoPay> NO_WALLET. You need to cashin to MoMo Wallet ");
            }
            NSLog(@"<MoMoPay> %@",message);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterTokenReceived" object:sourceURI];
        }
    }
    else
    {
        NSLog(@"<MoMoPay> Do nothing");
    }
}

-(void)createPaymentInformation:(NSMutableDictionary*)info
{
    paymentInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
}

-(void)updateAmount:(long long)amt
{
    [paymentInfo setValue:[NSNumber numberWithLongLong:amt] forKey:MOMO_PAY_CLIENT_AMOUNT_TRANSFER];
}

-(NSDictionary*)dictionaryFromUrlParram:(NSString*)urlPararm
{
    
    NSString *appBundleId = [MOMO_APP_BUNDLE_ID lowercaseString];
    NSString *sourceText = [urlPararm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://?",appBundleId] withString:@""];
    sourceText = [sourceText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",appBundleId] withString:@""];
    sourceText = [sourceText stringByReplacingOccurrencesOfString:MOMO_APP_BUNDLE_ID withString:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *components = [sourceText componentsSeparatedByString:@"&"];
    
    for (NSString *param in components) {
        NSArray *component = [param componentsSeparatedByString:@"="];
        if([component count] < 2) continue;
        
        // get key, value
        NSString* key   = [component objectAtIndex:0];
        key = [key stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSString* value = [component objectAtIndex:1];
        
        if(value){
            value = [value stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        }
        
        //
        if(key.length && value.length){
            [params setObject:value forKey:key];
        }
    }
    return params;
}

-(UIButton*)addMoMoPayCustomButton:(UIButton*)button forControlEvents:(UIControlEvents)controlEvents toView:(UIView*)parrentView
{
    if (controlEvents) {
        [button addTarget:self action:@selector(requestToken) forControlEvents:controlEvents];
    }
    else
    {
        [button addTarget:self action:@selector(requestToken) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [parrentView addSubview:button];
    
    return button;
}

-(void)addMoMoPayDefaultButtonToView:(UIView*)parrentView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];// [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setImage:[UIImage imageNamed:@"momo.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"momo_highlights.png"] forState:UIControlStateHighlighted];
    button.layer.borderColor   = [UIColor colorWithWhite:192/255.0 alpha:1].CGColor;
    button.layer.borderWidth   = 0;
    button.layer.cornerRadius  = 5;
    button.layer.masksToBounds = YES;
    
    [button addTarget:self action:@selector(requestToken) forControlEvents:UIControlEventTouchUpInside];
    [parrentView addSubview:button];
}

-(NSString*)getAction{
    return [MoMoConfig getAction];
}

-(void)setAction:(NSString*)action{
    [MoMoConfig setAction:action];
}

@end
