//
//  AgentInfo.h
//  MomoTransfer
//
//  Created by nvthinh on 11/3/16.
//  Copyright (c) 2014 M_Service. All rights reserved.
//

#import <Foundation/Foundation.h>

enum AgentRegStatus{
    AgentStatus_is_setup      = 1,      //dang set up
    AgentStatus_is_reged      = 2,      //dang ky
    AgentStatus_is_active     = 3,      //kich hoat
    AgentStatus_is_named      = 4,      //dinh danh
    AgentStatus_is_frozen     = 5,
    AgentStatus_is_suppend    = 6,
    AgentStatus_is_stopped    = 7
};


@interface AgentInfo : NSObject
@property (nonatomic) BOOL result;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* cardId;
@property (nonatomic) NSString* address;
@property (nonatomic) NSString* dateOfBirth;
@property (nonatomic) long long point;
@property (nonatomic) long long momo;
@property (nonatomic) long long mload;

@property (nonatomic) NSString* cityId;
@property (nonatomic) NSString* cityName;
@property (nonatomic) NSString* districtId;
@property (nonatomic) NSString* districtName;
@property (nonatomic) NSString* phoneNumber;
@property (nonatomic) NSString* imagesPartner;

//@property (nonatomic) RegStatus regStatus;
@property (nonatomic) BOOL is_setup;      //dang set up
@property (nonatomic) BOOL is_reged;      //dang ky
@property (nonatomic) BOOL is_active;      //kich hoat
@property (nonatomic) BOOL is_named;      //dinh danh
@property (nonatomic) BOOL is_frozen;
@property (nonatomic) BOOL is_suppend;
@property (nonatomic) BOOL is_stopped;

@property (nonatomic) NSString* bank_name;
@property (nonatomic) NSString* bank_account;
@property (nonatomic) NSString* bank_code;

@property (nonatomic) NSString* email;
@property (nonatomic) int       noname_count;
@property (nonatomic) BOOL      in_promotion;
@property (nonatomic) BOOL      exist; //DGD dinh danh vi cho khach hang
@property (nonatomic) NSDictionary* list_key_value;
    //key   value
    //dgd   "1": "0" khong phai DGD
    //referal : STD nguoi GT


//@property(nonatomic) NSString *phone;// = 2;
@property(nonatomic) int regStatus;//=9;
@property (nonatomic) NSString* otp;
@property(nonatomic) NSString *photos;
@property (nonatomic) NSString* staffId;
@property (nonatomic) BOOL      isRegMomoshopPoint;
@end
