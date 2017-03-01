//
//  ViewController.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 11/11/15.
//  Copyright © 2015 LuuLanh. All rights reserved.
//

#import "ViewController.h"
#import "MoMoPaySDK.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "RSA.h"



@interface ViewController ()
{
    UILabel *lblMessage;
    UILocalNotification *noti;
    UITextField *txtAmount;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenReceived:) name:@"NoficationCenterTokenReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterCreateOrderReceived:) name:@"NoficationCenterCreateOrderReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterStartRequestToken:) name:@"NoficationCenterStartRequestToken" object:nil];
    ///
    [self continueToPaymentOrder];
}

-(void)viewWillAppear:(BOOL)animated
{
    lblMessage.text = @"{MoMo Response}";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*) stringForCStr:(const char *) cstr{
    if(cstr){
        return [NSString stringWithCString: cstr encoding: NSUTF8StringEncoding];
    }
    return @"";
}

-(NSMutableDictionary*) getDictionaryFromComponents:(NSArray *)components{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    // parse parameters to dictionary
    for (NSString *param in components) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        // get key, value
        NSString* key   = [elts objectAtIndex:0];
        key = [key stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSString* value = [elts objectAtIndex:1];
        
        ///Start Fix HTML Property issue
        if ([elts count]>2) {
            @try {
                value = [param substringFromIndex:([param rangeOfString:@"="].location+1)];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        ///End HTML Property issue
        if(value){
            value = [self stringForCStr:[value UTF8String]];
        }
        
        //
        if(key.length && value.length){
            [params setObject:value forKey:key];
        }
    }
    return params;
}

-(void)NoficationCenterTokenReceived:(NSNotification*)notif
{
    //Token Replied
    NSLog(@"::MoMoPay Log::Received Token Replied::%@",notif.object);
    lblMessage.text = [NSString stringWithFormat:@"%@",notif.object];
    
    NSString *sourceText = [notif.object stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"com.n.fashionpp://?"] withString:@""];
    sourceText = [sourceText stringByReplacingOccurrencesOfString:@"com.n.fashionpp" withString:@""];
    sourceText = [sourceText stringByReplacingOccurrencesOfString:@"://://" withString:@"://"];
    
    ///fix UT8 String
    //sourceText = [sourceText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ////end fix UTF8 string
    
    //NSLog(@">>Parram %@",sourceText);
    
    NSArray *components = [sourceText componentsSeparatedByString:@"&"];
    
    NSDictionary *response = [self getDictionaryFromComponents:components];//(NSDictionary*)notif.object;
    NSString *status = [NSString stringWithFormat:@"%@",[response objectForKey:@"status"]];
    NSString *message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
    if ([status isEqualToString:@"0"]) {
        
        NSLog(@"::MoMoPay Log: SUCESS TOKEN.");
        NSLog(@">>response::%@",notif.object);
        lblMessage.text = @"Your Order proccessing...";
        NSString *data = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
        NSString *phoneNumber =  [NSString stringWithFormat:@"%@",[response objectForKey:@"phonenumber"]];
        
        long long _amountPay = [txtAmount.text longLongValue];
        
        // Demo: encrypt with public key
        NSMutableString *mutableString = nil;
        if (mutableString == nil)
        {
            mutableString = [[NSMutableString alloc] init];
        }
        
        [mutableString appendFormat:@"{"];
        [mutableString appendFormat:@"\"amount\":%lld,",_amountPay];
           [mutableString appendFormat:@"\"fee\":0,"];
           [mutableString appendFormat:@"\"merchantcode\":\"%@\""",",[MoMoConfig getMerchantcode]];// init only one from AppDelegate.h
           [mutableString appendFormat:@"\"transid\":\"%@\""",",@"41129898989"]; //Require: Your server transaction ID
           [mutableString appendFormat:@"\"username\":\"your_username_accountId\","]; //option: your server username_accountId
           [mutableString appendFormat:@"\"billid\":\"%@\""",",@"bill2015002102"];    //option: your billid
           [mutableString appendFormat:@"\"phonenumber\":\"%@\"""",phoneNumber];      //Require: PhoneNumber from MoMo App callback - DO NOT MANUAL EDIT THIS VALUE
        [mutableString appendFormat:@"}"];
        
        //WARNING: DO NOT EDIT THE phonenumber VALUE
        
        NSLog(@">>json: %@",mutableString);
        
        NSString *encWithPubKey = [RSA encryptString:mutableString publicKey:[MoMoConfig getPublickey]];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[MoMoConfig getMerchantcode] forKey:@"merchantcode"];
        [dic setValue:phoneNumber forKey:@"phonenumber"];
        [dic setValue:data forKey:@"data"];
        [dic setValue:encWithPubKey forKey:@"hash"];
        [dic setValue:[MoMoConfig getIPAddress] forKey:@"ipaddress"];
        
        //Demo call API payment from Partner server
        [[MoMoPayment shareInstant] requestPayment:dic];
        
        /*
         
         NSURL *url = [NSURL URLWithString:@"172.16.43.22:8082/paygamebill"]; //@"http://apptest2.momo.vn:8091/paygamebill"
         ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
         [request setRequestMethod:@"POST"];
         [request addRequestHeader:@"Accept" value:@"application/json"];
         [request addRequestHeader:@"content-type" value:@"application/json"];
         request.delegate = self;
         
         NSMutableString *bodyJson = nil;
         if (bodyJson == nil)
         {
         bodyJson = [[NSMutableString alloc] init];
         }
         
         [bodyJson appendFormat:@"{"];
         
         [bodyJson appendFormat:@"\"hash\":\"%@\""",",encWithPubKey];
         [bodyJson appendFormat:@"\"phonenumber\":\"%@\""",",phoneNumber];
         [bodyJson appendFormat:@"\"data\":\"%@\""",",data];
         [bodyJson appendFormat:@"\"ipaddress\":\"%@\""",",@"206.188.192.175"];
         [bodyJson appendFormat:@"\"merchantcode\":\"%@\"""",@"GOTIT20160427"];
         [bodyJson appendFormat:@"}"];
         
         [request setPostBody:[NSMutableData dataWithData:[bodyJson  dataUsingEncoding:NSUTF8StringEncoding]]];
         
         [request startSynchronous];
         NSError *error = [request error];
         if (!error) {
         NSString *response = [request responseString];
         lblMessage.text = [NSString stringWithFormat:@"%@",response];
         }
         else{
         lblMessage.text = [NSString stringWithFormat:@"%@",error.description];
         }
         */
        
         
        
    }else
    {
        if ([status isEqualToString:@"1"]) {
            NSLog(@"::MoMoPay Log: REGISTER_PHONE_NUMBER_REQUIRE.");
        }
        else if ([status isEqualToString:@"2"]) {
            NSLog(@"::MoMoPay Log: LOGIN_REQUIRE.");
        }
        else if ([status isEqualToString:@"3"]) {
            NSLog(@"::MoMoPay Log: NO_WALLET. You need to cashin to MoMo Wallet ");
        }
        else
        {
            NSLog(@"::MoMoPay Log: %@",message);
        }
    }
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"request finished");
     NSString *responseString = [request responseString];
    NSLog(responseString);
}

- (void)requestStarted:(ASIHTTPRequest *)request{
    
    NSLog(@"request started");
    
}
-(void)NoficationCenterStartRequestToken:(NSNotification*)notif
{
    NSLog(@"update amount");
    long long _amountPay = [txtAmount.text longLongValue];
    [[MoMoPayment shareInstant] updateAmount:_amountPay];
}
-(void)NoficationCenterCreateOrderReceived:(NSNotification*)notif
{
    //Payment Order Replied
//    NSString *responseString = [[NSString alloc] initWithData:[notif.object dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
//    
    NSLog(@"::MoMoPay Log::Request Payment Replied::%@",notif.object);
    lblMessage.text = [NSString stringWithFormat:@"Result: %@",notif.object];
    if ([notif.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *response = [[NSDictionary alloc] initWithDictionary:notif.object];
        
        int status = -1;
        @try {
            
        }
        @catch (NSException *exception) {
            status= [[response objectForKey:@"status"] intValue];
        }
        @finally {
            
        }
        
        if (status==0) {
            NSLog(@"::MoMoPay Log::Payment Success");
        }
        else
        {
            NSLog(@"::MoMoPay Log::Payment Error::%@",[response objectForKey:@"message"]);
        }
        lblMessage.text = [NSString stringWithFormat:@"%@:%@",[response objectForKey:@"status"],[response objectForKey:@"message"]];
        //continue your checkout order here
    }
}

-(void)continueToPaymentOrder{
    //Code của bạn
    UIView *paymentArea = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 300, 300)];
    [paymentArea setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgMoMo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [imgMoMo setImage:[UIImage imageNamed:@"momo.png"]];
    [paymentArea addSubview:imgMoMo];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 30)];
    lbl.text = @"SAMPLE APP MOMO SDK 2.0";
    lbl.font = [UIFont systemFontOfSize:13];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [paymentArea addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 30)];
    lbl.text = @"Pay by MoMo Wallet";
    lbl.font = [UIFont systemFontOfSize:13];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [paymentArea addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 30)];
    lbl.text = @"Amount";
    lbl.font = [UIFont systemFontOfSize:13];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [paymentArea addSubview:lbl];
    
    UIButton *btnPay = [[UIButton alloc] initWithFrame:CGRectMake(200, 60, 100, 30)];
//    btnPay.titleLabel.text = @"Submit";
    [btnPay setTitle:@"Submit" forState:UIControlStateNormal];
    [btnPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnPay addTarget:self action:@"" forControlEvents:UIControlEventTouchUpInside];
    btnPay.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnPay setBackgroundColor:[UIColor lightGrayColor]];
//    [paymentArea addSubview:btnPay];
    
    txtAmount = [[UITextField alloc] initWithFrame:CGRectMake(60, 60, 200, 30)];
    txtAmount.text = @"10000";
    txtAmount.delegate = self;
    txtAmount.placeholder = @"Enter amount...";
    txtAmount.font = [UIFont systemFontOfSize:14];
    [txtAmount setBackgroundColor:[UIColor clearColor]];
    [paymentArea addSubview:txtAmount];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60, 85, 100, 1)];
    [line setBackgroundColor:[UIColor grayColor]];
    [paymentArea addSubview:line];
    
    lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(60, 90, 300, 200)];
    lblMessage.text = @"{MoMo Response}";
    lblMessage.font = [UIFont systemFontOfSize:15];
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    lblMessage.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    lblMessage.numberOfLines = 0;
    [paymentArea addSubview:lblMessage];
    
    //Tạo button Thanh toán bằng Ví MoMo
    NSString *amount = [NSString stringWithFormat:@"10000"];//Số tiền thanh toán ở đây
    NSString *fee = [NSString stringWithFormat:@"0"]; //Phí của bạn đặt ở đây (phí của Merchant)
    
    NSString *username = [NSString stringWithFormat:@"your_username_accountId"];//Tai khoan dang login de thuc hien giao dich nay (khong bat buoc)
    
    //Buoc 1: Khoi tao Payment info, add button MoMoPay
    NSMutableDictionary *paymentinfo = [[NSMutableDictionary alloc] init];
    [paymentinfo setValue:@"41129898989" forKey:MOMO_PAY_CLIENT_MERCHANT_TRANS_ID];
    [paymentinfo setValue:amount forKey:MOMO_PAY_CLIENT_AMOUNT_TRANSFER];
    [paymentinfo setValue:fee forKey:MOMO_PAY_CLIENT_FEE_TRANSFER];//khong bat buoc
    [paymentinfo setValue:username forKey:MOMO_PAY_CLIENT_USERNAME];
    //add more key here
    //    [paymentinfo setValue:yourvalue1 forKey:yourkey1];
    //    [paymentinfo setValue:yourvalue2 forKey:yourkey2];
    
    [[MoMoPayment shareInstant] createPaymentInformation:paymentinfo];
    [[MoMoPayment shareInstant] setAction:MOMO_PAY_SDK_ACTION_GETTOKEN]; // default is MOMO_PAY_SDK_ACTION_GETTOKEN
    
    //Buoc 2: add button Thanh toan bang Vi MoMo vao khu vuc ban can hien thi (Vi du o day la vung paymentArea)
    ///Default MoMo Button [[MoMoPayment shareInstant] addMoMoPayDefaultButtonToView:paymentArea];
    
    ///Custom button
    [[MoMoPayment shareInstant] addMoMoPayCustomButton:btnPay forControlEvents:UIControlEventTouchUpInside toView:paymentArea];
    
    //Code của bạn
    [self.view addSubview:paymentArea];
    
}

@end
