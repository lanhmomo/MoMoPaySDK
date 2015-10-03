//
//  MoMoPaySDK.h
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoMoConfig.h"
#import "MoMoPayment.h"
@interface MoMoPaySDK : NSObject
+(void)initializingAppBundleId:(NSString*)bundleid merchantCode:(NSString*)merchantcode merchantName:(NSString*)merchantname merchantNameLabel:(NSString*)merchantnamelabel merchantPublicKey:(NSString*)publickey;
@end
