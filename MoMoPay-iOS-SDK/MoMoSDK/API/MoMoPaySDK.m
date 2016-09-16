//
//  MoMoPaySDK.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//

#import "MoMoPaySDK.h"
@implementation MoMoPaySDK
+(void)initializingAppBundleId:(NSString*)bundleid merchantCode:(NSString*)merchantcode merchantName:(NSString*)merchantname merchantNameLabel:(NSString*)merchantnamelabel merchantPublicKey:(NSString*)publickey{
    [MoMoConfig setAppBundleId:bundleid];
    [MoMoConfig setMerchantcode:merchantcode];
    [MoMoConfig setMerchantname:merchantname];
    [MoMoConfig setMerchantnameLabel:merchantnamelabel];
    [MoMoConfig setPublickey:publickey];
    NSLog(@"<MoMoPay> initializing successful");
}
@end
