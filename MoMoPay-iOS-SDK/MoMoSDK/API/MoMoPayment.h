//
//  MoMoPayment.h
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MoMoPayment : NSObject
+(MoMoPayment*)shareInstant;
-(void)requestPayment:(NSMutableDictionary*)parram;
-(void)requestToken;
-(void)handleOpenUrl:(NSURL*)url;
-(void)createPaymentInformation:(NSMutableDictionary*)info;
-(void)addMoMoPayDefaultButtonToView:(UIView*)parrentView;
-(UIButton*)addMoMoPayCustomButton:(UIButton*)button forControlEvents:(UIControlEvents)controlEvents toView:(UIView*)parrentView;
-(NSString*)getAction;
-(void)setAction:(NSString*)action;
-(void)updateAmount:(long long)amt;
-(NSMutableDictionary*) getDictionaryFromUrl:(NSString*)urlString;
@end
