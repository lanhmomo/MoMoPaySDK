//
//  MomoTransferAppSingleton.m
//  MomoTransfer
//
//  Created by HoangVo on 4/1/14.
//  Copyright (c) 2014 M_Service. All rights reserved.
//

#import "MomoTransferAppSingleton.h"
#import "AppDelegate.h"
#import "MoMoPrefix.pch"
#import "UserRequest.h"
static MomoTransferAppSingleton *__shareInstance;
static NSString* _sectionKey;
NSString* _studentCode;
NSString *_latestPhoneNumber;
NSString *_latestVersion;
int       _time_lock_until;
BOOL _isForceRequestOTP;
int       _currentTranType;
BOOL       _isNeedShowBanknetList;
BOOL       _isNeedShowVisaMasterBankOnly;
BOOL       _isNeedShowBankNetOnly;
long long tranIdVisaMasterCashinRoot;
NSString* _phonePIN;
@implementation MomoTransferAppSingleton

+(MomoTransferAppSingleton *)shareInstance{
    if (__shareInstance == nil) {
        __shareInstance = [[MomoTransferAppSingleton alloc] init];
    }
    return __shareInstance;
}

#pragma mark - Int value

+(BOOL)isDebug{
    return [[[NSBundle mainBundle].infoDictionary objectForKey:@"AppDebugEnvironment"] boolValue]; //return NO when release app
}

+ (int) intForKey:(NSString*) key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey: key];
    if(value){
        return [value intValue];
    }
    return 0;
}

+ (long long) longlongForKey:(NSString*) key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(value){
        return [value longLongValue];
    }
    return 0;
}

#pragma mark - Setter

+ (void) setPhoneNumber:(NSString*) phoneNumber{
    [[NSUserDefaults standardUserDefaults] setValue:phoneNumber forKey:PhoneNumber];
}

+ (void) setOldPhoneNumber:(NSString*) phoneNumber{
    [[NSUserDefaults standardUserDefaults] setValue:phoneNumber forKey:OldPhoneNumber];
}

+ (void) setAgentFullName:(NSString*) agentFullName{
    [[NSUserDefaults standardUserDefaults] setValue:agentFullName forKey: AgentFullName];
}

+ (void) setBirthDay:(NSString*) birthDay{
    [[NSUserDefaults standardUserDefaults] setValue:birthDay forKey: AgentDOB];
}

+ (void) setAgentCardID:(NSString*) agentCardID{
    [[NSUserDefaults standardUserDefaults] setValue:agentCardID forKey: AgentCardID];
}

+ (void) setEmail:(NSString*) email{
    [[NSUserDefaults standardUserDefaults] setValue:email forKey: AgentEmail];
}

+ (void) setAddress:(NSString*) address{
    [[NSUserDefaults standardUserDefaults] setValue:address forKey: AgentAddress];
}

+ (void) setBankCode:(NSString*) bankCode{
    [[NSUserDefaults standardUserDefaults] setValue:bankCode forKey: AgentBankCode];
}

+ (void) setBankName:(NSString*) bankName{
    [[NSUserDefaults standardUserDefaults] setValue:bankName forKey: AgentBankName];
}

+ (void) setBankAccount:(NSString*) bankAccount{
    [[NSUserDefaults standardUserDefaults] setValue:bankAccount forKey: AgentBankAccount];
}

+ (void) setImei:(NSString*) Imei{
    [[NSUserDefaults standardUserDefaults] setValue: Imei forKey: IMEI_STR];
}

+ (void) setImeiKey:(NSString*) ImeiKey{
    [[NSUserDefaults standardUserDefaults] setValue: ImeiKey forKey: IMEIKey_STR];
}

+ (void) setStatusAgentUpdated:(BOOL)statusAgent{
    [[NSUserDefaults standardUserDefaults] setBool: statusAgent forKey: AgentUpdated];
}


+ (void) setSectionKey:(NSString*) sectionKey{
//    [[NSUserDefaults standardUserDefaults] setValue: sectionKey forKey: SectionKey_STR];
    _sectionKey = sectionKey;
}

+ (void) setSessionLogin:(NSString*) sessionKey{
    //[[NSUserDefaults standardUserDefaults] setValue: sessionKey forKey: SessionKeyLogin];
}

+ (void) setDeviceToken:(NSString*) token{
    [[NSUserDefaults standardUserDefaults] setValue: token forKey: Device_Token];
}

+ (void) setRegistered:(BOOL) isRegistered{
    [[NSUserDefaults standardUserDefaults] setBool: isRegistered forKey: Is_Register];
}

+ (void) setPhoneActived:(BOOL) isPhoneActived{
    [[NSUserDefaults standardUserDefaults] setBool: isPhoneActived forKey: Is_PhoneActived];
}

+ (void) setNamed:(BOOL)    isNamed{
    [[NSUserDefaults standardUserDefaults] setBool: isNamed forKey: Is_Named];
}

+ (void) setBonus:(int) bonus{
    [[NSUserDefaults standardUserDefaults] setInteger: bonus forKey: BONUS_POINT];
}

+ (void) setNonameCount: (int)       nonameCount{
    [[NSUserDefaults standardUserDefaults] setInteger: nonameCount forKey: Remain_Count];
}

+ (void) setTotalCountToday: (int)       totalCountToday{
    [[NSUserDefaults standardUserDefaults] setInteger: totalCountToday forKey: Total_Count_Today];
}

+ (void) setTotalAmountToDay: (long long)       totalAmountToDay{
    [[NSUserDefaults standardUserDefaults] setDouble: totalAmountToDay forKey: Total_Amount_Today];
}

+ (void) setMaxLimitAmount:(long long) maxLimitAmount{
    [[NSUserDefaults standardUserDefaults] setDouble: maxLimitAmount forKey: Max_Limit_Amount];
}

#pragma mark - Set Fee

+ (void) setBankNetDynamicFee:(double) bankNetDynamicFee{
    [[NSUserDefaults standardUserDefaults] setDouble: bankNetDynamicFee forKey: BANK_NET_DYNAMIC_FEE];
}

+ (void) setBankNetStaticFee:(double) bankNetStaticFee{
    [[NSUserDefaults standardUserDefaults] setDouble: bankNetStaticFee forKey: BANK_NET_STATIC_FEE];
}

+ (void) setVisaMasterDynamicFee:(double) dynamicFee{
    [[NSUserDefaults standardUserDefaults] setDouble: dynamicFee
                                              forKey: VISA_MASTER_DYNAMIC_FEE];
}

+ (void) setVisaMasterStaticFee:(double) staticFee{
    [[NSUserDefaults standardUserDefaults] setDouble: staticFee
                                              forKey: VISA_MASTER_STATIC_FEE];
}

+ (void) setCashinVisaMasterDynamicFee:(double) dynamicFee{
    [[NSUserDefaults standardUserDefaults] setDouble: dynamicFee
                                              forKey: CASHIN_VISA_MASTER_DYNAMIC_FEE];
}

+ (void) setCashinVisaMasterStaticFee:(double) staticFee{
    [[NSUserDefaults standardUserDefaults] setDouble: staticFee
                                              forKey: CASHIN_VISA_MASTER_STATIC_FEE];
}
//
//+ (void) setServer:(NSString *)currentIp{
//    [[NSUserDefaults standardUserDefaults] setObject:currentIp forKey:MOMO_IP_SERVER];
//}

+ (void) setEnableMPoint:(BOOL) enableMPoint{
    [[NSUserDefaults standardUserDefaults] setBool:enableMPoint forKey: Enable_MPoint];
}

+ (void) setServerEnableMPoint:(BOOL) enableMPoint{
    [self setEnableMPoint: enableMPoint];
    [[UserRequest reqWithDelegate:nil] requestSetUserSetting];
}

#pragma mark
//+ (NSString*) getServer{
//    return [[NSUserDefaults standardUserDefaults] objectForKey: MOMO_IP_SERVER];
//}

+(BOOL)getStatusAgentUpdated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:AgentUpdated];
}


+ (NSString*) phoneNumber{
    return [[NSUserDefaults standardUserDefaults] objectForKey: PhoneNumber];
}

+ (NSString*) phonePIN{
    return _phonePIN;
}

+ (void) setPhonePIN:(NSString*)pin{
    _phonePIN = pin;
}

+ (NSString*) phoneNumberLatest{
    return [[NSUserDefaults standardUserDefaults] objectForKey: OldPhoneNumber];
}

+ (NSString*) agentFullName{
    if ([[NSUserDefaults standardUserDefaults] objectForKey: AgentFullName]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey: AgentFullName];
    }
    return @"";
}

+ (NSString*) birthDay{
    return [[NSUserDefaults standardUserDefaults] objectForKey: AgentDOB];
}

+ (NSString*) agentCardID{
    return [[NSUserDefaults standardUserDefaults] objectForKey: AgentCardID];
}

+ (NSString*) email{
    if ([[NSUserDefaults standardUserDefaults] objectForKey: AgentEmail]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey: AgentEmail];
    }
    return @"";
}

+ (NSString*) address{
    return [[NSUserDefaults standardUserDefaults] objectForKey: AgentAddress];
}

+ (NSString*) accountType{
#ifdef MOMO_AGENCY_APP
//    if ([[NSUserDefaults standardUserDefaults] objectForKey: AgentType]) {
//        return [[NSUserDefaults standardUserDefaults] objectForKey: AgentType];
//    }
    return @"Điểm giao dịch";
#else

    if([self isNamed]){
        return @"Đã định danh";
    }
    else{
        return @"Chưa định danh";
    }
#endif
}

+ (void) setAgentType:(NSString*)agenttype{
    [[NSUserDefaults standardUserDefaults] setValue: agenttype forKey: AgentType];
}

+ (BOOL) isNamed{
#ifdef MOMO_AGENCY_APP
    return YES;
#else
    return [[NSUserDefaults standardUserDefaults] boolForKey: Is_Named];
#endif
}

+ (BOOL) isRegister{
    return [[NSUserDefaults standardUserDefaults] boolForKey: Is_Register];
}

+ (BOOL) isPhoneActive{
    return [[NSUserDefaults standardUserDefaults] boolForKey: Is_PhoneActived];
}

+ (int) bonus{
    return [self intForKey:BONUS_POINT];
}

+ (BOOL) enableMPoint{
    return [[NSUserDefaults standardUserDefaults] boolForKey: Enable_MPoint];
}

static NSNumberFormatter *numberFormatter;

+ (NSString*) bankCode{
    NSString *bcode = [[NSUserDefaults standardUserDefaults] objectForKey: AgentBankCode];
    if (bcode.length && [bcode isEqualToString:@"0"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey: AgentBankCode];
}

+ (NSString*) bankName{
    NSString *bcode = [[NSUserDefaults standardUserDefaults] objectForKey: AgentBankCode];
    if (bcode.length && [bcode isEqualToString:@"0"]) {
        return @"";
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: AgentBankName];
}

+ (NSString*) bankAccount{
    return [[NSUserDefaults standardUserDefaults] objectForKey: AgentBankAccount];
}

+ (NSString*) imei{
    return [[NSUserDefaults standardUserDefaults] objectForKey: IMEI_STR];
}

+ (NSString*) imeiKey{
    return [[NSUserDefaults standardUserDefaults] objectForKey: IMEIKey_STR];
}

+ (NSString*) sectionKey{
    return _sectionKey;
}

+ (NSString*) balanceStr{
    return [[[NSUserDefaults standardUserDefaults] objectForKey: BALANCE_KEY] stringValue];
}

+ (NSString*) deviceToken{
    NSString* token = [[NSUserDefaults standardUserDefaults] valueForKey: Device_Token];
    return token.length?token:@"";
}

#pragma mark - Fee

+ (double) bankNetDynamicFee{
    id cash = [[NSUserDefaults standardUserDefaults] objectForKey: BANK_NET_DYNAMIC_FEE];
    if(cash && cash>0){
        return [cash doubleValue];
    }
    return 1.1;
}

+ (double) bankNetStaticFee{
    id cash = [[NSUserDefaults standardUserDefaults] objectForKey: BANK_NET_STATIC_FEE];
    if(cash && cash>0){
        return [cash doubleValue];
    }
    return 1100;
}

+ (double) visaMasterDynamicFee{
    id cash = [[NSUserDefaults standardUserDefaults] objectForKey: VISA_MASTER_DYNAMIC_FEE];
    if(cash && cash>0){
        return [cash doubleValue];
    }
    return 2;
}

+ (double) visaMasterStaticFee{
    id cash = [[NSUserDefaults standardUserDefaults] objectForKey: VISA_MASTER_STATIC_FEE];
    if(cash && cash>0){
        return [cash doubleValue];
    }
    return 3200;
}

+ (double) cashinVisaMasterDynamicFee{
    id cash = [[NSUserDefaults standardUserDefaults] objectForKey: CASHIN_VISA_MASTER_DYNAMIC_FEE];
    if(cash && cash>0){
        return [cash doubleValue];
    }
    return 2.4;
}

+ (double) cashinVisaMasterStaticFee{
    id cash = [[NSUserDefaults standardUserDefaults] objectForKey: CASHIN_VISA_MASTER_STATIC_FEE];
    if(cash && cash>0){
        return [cash doubleValue];
    }
    return 3200;
}

#pragma mark - Balance

+ (long long) balanceInt{
    return [self longlongForKey:BALANCE_KEY];
}

+ (long long) totalBalanceInt{
    return [self balanceInt] + [self bonus];
}

+ (void) setBalance:(long long) balance{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong: balance]
                                                                 forKey:BALANCE_KEY];
}

+ (int) nonameCount{
    return [self intForKey:Remain_Count];
}

+ (int) totalCountToday{
    return [self intForKey:Total_Count_Today];
}

+ (int) totalAmountToDay{
    return [self intForKey:Total_Amount_Today];
}

+ (int) maxLimitAmount{
    return [self intForKey:Max_Limit_Amount];
}

+(long long) visaMasterCashinTranIdRoot{
    return tranIdVisaMasterCashinRoot;
}

+(void) setVisaMasterCashinTranIdRoot:(long long)rootTranId{
    tranIdVisaMasterCashinRoot = rootTranId;
}

#pragma mark

+ (NSString *)validatePhoneNumber:(NSString *)phoneStr{
    if(phoneStr.length){
        
        phoneStr = [phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        BOOL isNumeric = YES;//[CommonUlti isNumeric: phoneStr];
        
        // Batanlp - edit
        NSString *validPhoneNumStr = [phoneStr stringByReplacingOccurrencesOfString:@"+84" withString:@"0"];
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@"(+84)" withString:@"0"];
        
        //////////fix prefix +84
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@"." withString:@""];
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@"(084)" withString:@"0"];
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@"(0)" withString:@""];
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
        validPhoneNumStr = [validPhoneNumStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        if ([validPhoneNumStr hasPrefix:@"00"]) {
            validPhoneNumStr = [validPhoneNumStr substringFromIndex:1];
        }
        
        if ([validPhoneNumStr hasPrefix:@"84"]) {
            if (validPhoneNumStr.length>=3) {
                validPhoneNumStr = [validPhoneNumStr substringFromIndex:2];
            }
        }
        
        //isNumeric = [CommonUlti isNumeric: validPhoneNumStr];
        ///////////////
        if(![validPhoneNumStr hasPrefix:@"0"] && isNumeric){
            validPhoneNumStr = [@"0" stringByAppendingString: validPhoneNumStr];
        }
        NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return [[validPhoneNumStr componentsSeparatedByCharactersInSet: set] componentsJoinedByString: @""];
    }
    return @"";
}

+ (void) synchronize{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#define CREDIT_CARD_KEY @"CREDIT_CARD_KEY"

#define CYBER_SOURCE_CARD_LIST @"CYBER_SOURCE_CARD_LIST"

+ (NSArray*) creditCardList{
//    CreditCardInfo* card = [[CreditCardInfo alloc] init];
//    card.cardId          = @"4271007831065000001516";
//    card.cardType        = @"001";
//    card.bankName        = @"Visa";
//    card.resourceType    = RES_VISA_MASTER;
//    return @[card];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey: CREDIT_CARD_KEY]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey: CREDIT_CARD_KEY]];
    }
    return nil;
}

+ (void) saveCreditCardList:(NSArray*) list{    
    if (list) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: list]
                                                  forKey:CREDIT_CARD_KEY];
    }
}

+ (NSArray*) cardTypeList{
    if ([[NSUserDefaults standardUserDefaults] objectForKey: CYBER_SOURCE_CARD_LIST]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey: CYBER_SOURCE_CARD_LIST]];
    }
    return nil;
}

+ (void) saveCardTypeList:(NSArray*) list{
    if (list) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: list]
                                                  forKey:CYBER_SOURCE_CARD_LIST];
    }
}

//+ (void) saveCreditCardListAndSyncWithServer:(NSArray*) list{
//    [MomoTransferAppSingleton saveCreditCardList: list];
//    [[UserRequest reqWithDelegate:nil] requestUpdateCreditCardList: list];
//}


+ (BOOL) isCashByFriendLoan{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"MOMOCashType"]!=nil ? [[NSUserDefaults standardUserDefaults] boolForKey:@"MOMOCashType"]:NO;
}

+ (void) setCashTypeByFriendLoan:(BOOL)isCashByFriend{
    [[NSUserDefaults standardUserDefaults] setBool:isCashByFriend forKey:@"MOMOCashType"];
}

+ (void) setShowHideBankNetList:(BOOL)isShow isOnlyVisaMaster:(BOOL)isVisaMasterOnly  isOnlyBankNet:(BOOL)isOnlyBankNetOnly{
    _isNeedShowBanknetList = isShow;
    _isNeedShowVisaMasterBankOnly = isVisaMasterOnly;
    _isNeedShowBankNetOnly = isOnlyBankNetOnly;
}

+ (BOOL) isShowBanknetList{
    return _isNeedShowBanknetList;
}

+ (BOOL) isShowVisaMasterBankOnly{
    return _isNeedShowVisaMasterBankOnly;
}

+ (BOOL) isShowBankNetOnly{
    return _isNeedShowBankNetOnly;
}

+ (void) setBankNetSelected:(NSString*)bankId{
    [[NSUserDefaults standardUserDefaults] setValue:bankId forKey:@"BankNetSelected"];
}
+ (NSString*) getBankNetSelected{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"BankNetSelected"];
}

+ (id) getBanknetCardSelected{
    if ([[NSUserDefaults standardUserDefaults] objectForKey: BANK_NET_CARD_SELECTED]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey: BANK_NET_CARD_SELECTED]];
    }
    return nil;
}

+ (void) setBanknetCardSelected:(id) classCard{
    if (classCard) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: classCard]
                                                  forKey:BANK_NET_CARD_SELECTED];
    }
}

+ (BOOL) hasValidSession{
    return [MomoTransferAppSingleton sectionKey].length > 1;
}

// open url
static NSDictionary* _urlParams;
static NSDictionary* _qrcodeParams;
static NSDictionary* _urlParamsPayOffline;
+ (NSDictionary*) appOpenUrlParams{
    return _urlParams;
}

+ (void) setAppOpenUrlParams:(NSDictionary*) dict{
    _urlParams = dict;
}

+ (void) setPayOfflineParams:(NSDictionary*) dict{
    _urlParams = dict;
}

+ (NSDictionary*) getPayOfflineParams{
    return _urlParamsPayOffline;
}

+ (NSDictionary*) qrcodeOpenUrlParams{
    return _qrcodeParams;
}

+ (void) setQrcodeOpenUrlParams:(NSDictionary*) dict{
    _qrcodeParams = dict;
}

// push notification launch option
static NSDictionary* _apsLaunchOption;

+ (NSDictionary*) apsLaunchOption{
    return _apsLaunchOption;
}

+ (void) setApsLaunchOption:(NSDictionary*) dict{
    _apsLaunchOption = dict;
}

+(void)setLatestEmailConfirm123Phim:(NSString*)email{
    [[NSUserDefaults standardUserDefaults] setValue:email forKey:LATEST_EMAIL_CONFIRM_123PHIM];
}
+(NSString*)getLatestEmailConfirm123Phim{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LATEST_EMAIL_CONFIRM_123PHIM];
}

+(void)setEmailForKey:(NSString*)keystore andValue:(NSString*)value{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:keystore];
}
+(NSString*)getEmailForKey:(NSString*)keystore{
    return [[NSUserDefaults standardUserDefaults] objectForKey:keystore];
}

+ (void) checkToggleUsingMPoint{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:Enable_MPoint]){
        [self setServerEnableMPoint: YES];
    }
}

+ (void) setTransferDetailObject:(id) transferObject{
    NSData *customObjectData = [NSKeyedArchiver archivedDataWithRootObject:transferObject];
    [[NSUserDefaults standardUserDefaults] setObject:customObjectData forKey:TRANSFER_OBJECT_KEY];
}

+(id)getTransferDetailObject{
    NSData *customObjectData = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSFER_OBJECT_KEY];
    if (customObjectData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:customObjectData];
    }
    return nil;
}

+(void)setCurrentTransType:(int)transtype{
    [[NSUserDefaults standardUserDefaults] setInteger:transtype forKey:MOMO_TRANSFER_TYPE];
}

+(int)getCurrentTransType{
    int currentType = (unsigned int)[[NSUserDefaults standardUserDefaults] integerForKey:MOMO_TRANSFER_TYPE];
    return currentType;
}

+ (void) setMinConfig:(id) minmaxObject{
    NSData *customObjectData = [NSKeyedArchiver archivedDataWithRootObject:minmaxObject];
    [[NSUserDefaults standardUserDefaults] setObject:customObjectData forKey:MIN_OBJECT_KEY];
}

+ (void) setMaxConfig:(id) minmaxObject{
    NSData *customObjectData = [NSKeyedArchiver archivedDataWithRootObject:minmaxObject];
    [[NSUserDefaults standardUserDefaults] setObject:customObjectData forKey:MAX_OBJECT_KEY];
}

+(id)getMinConfig{
    NSData *customObjectData = [[NSUserDefaults standardUserDefaults] objectForKey:MIN_OBJECT_KEY];
    if (customObjectData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:customObjectData];
    }
    return nil;
}

+(id)getMaxConfig{
    NSData *customObjectData = [[NSUserDefaults standardUserDefaults] objectForKey:MAX_OBJECT_KEY];
    if (customObjectData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:customObjectData];
    }
    return nil;
}

+ (void) setAgentReferenceNumber:(NSString*) agentReferal{
    [[NSUserDefaults standardUserDefaults] setValue:agentReferal forKey: AgentReferal];
}
+ (NSString*) getAgentReferenceNumber{
    return [[NSUserDefaults standardUserDefaults] objectForKey: AgentReferal];
}

+ (NSString*) getSectionLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey: SessionKeyLogin]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey: SessionKeyLogin];
    }
    return @"";
}

/***** Danh sách ID MAPPING Màn hình trên app
 1. Giới thiệu bạn bè (share)
 2. Nạp tiền
 3. Nạp rút tiền
 4. Rút tiền
 5. Nạp điện thoại
 6. Thanh toán hóa đơn
 7. Thanh toán dịch vụ
 8. Thanh toán vé xem phim
 9. Thanh toán QR code
 10. Chuyển tiền
 11. Tìm điểm giao dịch
 12. Cập nhật thông tin cá nhân
 13. Quản lý thẻ
 14. Đổi mật khẩu
 15. Trợ giúp
 16. Tài khoản cá nhân
 17. Tặng quà(Voucher)
 18. Danh sách Quà tặng
 19. Cài đặt
 20. Khuyến Mãi
 */

+(int)isNeedToUpdateAgent{
    BOOL isRequire = NO;
    
    isRequire = ![MomoTransferAppSingleton agentFullName].length && [MomoTransferAppSingleton balanceInt]>0;
    if (isRequire) {
        return 1;
    }
    if (!isRequire)
        isRequire = ![MomoTransferAppSingleton agentFullName].length && [MomoTransferAppSingleton bonus]>0;
    
    if (isRequire) {
        return 2;
    }
    
    if (!isRequire)
        isRequire = [MomoTransferAppSingleton getStatusAgentUpdated];
    
//    if (!isRequire){
//        NSArray *arr = [[DBManager sharedInstance] loadAllVoucherOfUser];
//        isRequire = ![MomoTransferAppSingleton agentFullName].length && [arr count]>0?YES:NO;
//    
//        if (isRequire) {
//            return 3;
//        }
//    }
    
    return 0;
}

+(BOOL)isExistsCardId:(NSString*)cardid andCardType:(NSString*)cardType{
    
    NSMutableArray *_arrCardsType = [[NSMutableArray alloc] initWithArray: [MomoTransferAppSingleton creditCardList]];
    BOOL hasCard = NO;
//    for (CreditCardInfo *obj in _arrCardsType) {
//        if ([obj.cardType isEqualToString:cardType] && [obj.cardId isEqualToString:cardid]) {
//            hasCard = YES;
//            break;
//        }
//    }
    
    return hasCard;
}
+ (void) setAgentWaitingRegisMoMoShop:(BOOL)statusAgent
{
    [[NSUserDefaults standardUserDefaults] setBool:statusAgent forKey:AGENT_MOMOSHOP_POINT_WAITING_REG];
}
+ (BOOL) isAgentWaitingRegisMoMoShop
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:AGENT_MOMOSHOP_POINT_WAITING_REG]!=nil) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:AGENT_MOMOSHOP_POINT_WAITING_REG];
    }
    return NO;
}
+ (void) setOrginalScreenSizeWidth:(float)orginalSizeWidth{
    [[NSUserDefaults standardUserDefaults] setBool:orginalSizeWidth forKey:@"OrginalScreenSizeWidth"];
}
+ (void) setOrginalScreenSizeHeight:(float)orginalSizeHeight{
    [[NSUserDefaults standardUserDefaults] setBool:orginalSizeHeight forKey:@"OrginalScreenSizeHeight"];
}
+ (float) getOrginalScreenSizeWidth{
    if ([[NSUserDefaults standardUserDefaults]  objectForKey:@"OrginalScreenSizeWidth"]) {
        return [[NSUserDefaults standardUserDefaults]  floatForKey:@"OrginalScreenSizeWidth"];
    }
    return 0.0f;
}
+ (float) getOrginalScreenSizeHeight{
    if ([[NSUserDefaults standardUserDefaults]  objectForKey:@"OrginalScreenSizeHeight"]) {
        return [[NSUserDefaults standardUserDefaults]  floatForKey:@"OrginalScreenSizeHeight"];
    }
    return 0.0f;
}
+ (BOOL) isBankgateWayEnable
{
    return YES;
}
+(BOOL)isVisaGroup
{
    BOOL hasVisaCard = NO;
//    NSMutableArray *cardList = [[NSMutableArray alloc] initWithArray: [self creditCardList]];
//    
//    for (CreditCardInfo *obj in cardList)
//    {
//        if ([obj.bankID isEqualToString:STR_BANK_ID_CYBER_SOURCE]) {
//            hasVisaCard = YES;
//            break;
//        }
//    }
//    
    return hasVisaCard;
}


+ (void) setMobilePrefix:(id)prefixList{
    if (prefixList != nil) {
        [[NSUserDefaults standardUserDefaults] setValue: prefixList forKey: MobilePrefix];
    }
}
+(id)getMobilePrefix{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MobilePrefix]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:MobilePrefix];
    }
    return nil;
}

+ (void) setTypeRefreshForm:(long) typeRefresh{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:typeRefresh]
                                              forKey:@"TypeRefreshFormMS"];
}

+(int) getTypeRefreshForm{
    id intType = [[NSUserDefaults standardUserDefaults] objectForKey:@"TypeRefreshFormMS"];
    return [intType intValue];
}

+(void)setHiddenMoMoWallet:(BOOL)isHidden{
    [[NSUserDefaults standardUserDefaults] setBool:isHidden forKey:@"KEY_HIDDEN_MOMO_WALLET"];
}

+(BOOL)isHiddenMoMoWallet{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_HIDDEN_MOMO_WALLET"]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_HIDDEN_MOMO_WALLET"];
    }
    return NO;
}

+(void)setReferenceValue:(id)referenceObject withKey:(NSString*)keyRef{
    //NSLog(@">referenceObject %@ %@",referenceObject,keyRef);
    if (referenceObject) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",referenceObject] forKey:keyRef];
    }
}
+(id)getReferenceValueByKey:(NSString*)keyRef{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:keyRef]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:keyRef];
    }
    return nil;
}

@end