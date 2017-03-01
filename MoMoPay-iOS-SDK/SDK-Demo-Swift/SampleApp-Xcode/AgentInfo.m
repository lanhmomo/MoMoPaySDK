//
//  AgentInfo.m
//  MomoTransfer
//
//  Created by nvthinh on 11/3/16.
//  Copyright (c) 2014 M_Service. All rights reserved.
//

#import "AgentInfo.h"

@implementation AgentInfo
- (id) init{
    if(self = [super init]){
        _address = @"";
        
        _districtId   = @"";
        _districtName = @"";
        
        _cityId      = @"";
        _cityName    = @"";
        
        _name        = @"";
        _phoneNumber = @"";
        _email       = @"";
        
        _cardId      = @"";
        _dateOfBirth = @"";
        _otp         = @"";
        _staffId     = @"";
    }
    return self;
}
@end
