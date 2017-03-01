//
//  MomoTransferAppSingleton.h
//  MomoTransfer
//
//  Created by HoangVo on 4/1/14.
//  Copyright (c) 2014 M_Service. All rights reserved.
//
#import <Foundation/Foundation.h>

#define PromotionID           @"PromotionID"
#define PromotionName         @"PromotionName"
#define PromotionSMSContent   @"PromotionSMSContent"
#define PromotionBodyContent  @"PromotionBodyContent"
#define PromotionPopupContent @"PromotionPopupContent"
extern NSString* _studentCode;
extern NSString* _phonePIN;
extern NSString *_latestPhoneNumber;
extern NSString *_latestVersion;
extern int       _time_lock_until;
extern BOOL _isForceRequestOTP;
extern int       _currentTranType;
extern BOOL       _isNeedShowBanknetList;
extern long long tranIdVisaMasterCashinRoot;
@interface MomoTransferAppSingleton : NSObject

+(MomoTransferAppSingleton *)shareInstance;

@property (nonatomic) BOOL isAgentUpdate;
@property (nonatomic) BOOL isSkipGotoDetail;

@property (nonatomic) BOOL isCheckContact;

@property (nonatomic) BOOL isAppLogin;

@property (nonatomic) BOOL isForgotPIN;

@property (nonatomic) BOOL isHello;

@property (nonatomic) BOOL isBeginRunApp;

+ (NSString*) phoneNumber;
+ (NSString*) phoneNumberLatest;
+ (NSString*) agentFullName;

+ (NSString*) birthDay;
+ (NSString*) agentCardID;
+ (NSString*) email;

+ (NSString*) address;
+ (NSString*) accountType;

+ (NSString*) balanceStr;
+ (long long) balanceInt;
+ (long long) totalBalanceInt; // all

+ (NSString*) bankCode;
+ (NSString*) bankName;
+ (NSString*) bankAccount;

+ (NSString*) imei;
+ (NSString*) imeiKey;
+ (NSString*) sectionKey;

// fee
+ (double) bankNetDynamicFee;
+ (double) bankNetStaticFee;

//
+ (double) visaMasterDynamicFee;
+ (double) visaMasterStaticFee;
+(long long) visaMasterCashinTranIdRoot;
+(void) setVisaMasterCashinTranIdRoot:(long long)rootTranId;
//
+ (double) cashinVisaMasterDynamicFee;
+ (double) cashinVisaMasterStaticFee;

+ (NSString*) deviceToken;

+ (BOOL) isCashByFriendLoan;
+ (void) setCashTypeByFriendLoan:(BOOL)isCashByFriend;

+ (void) setPhoneNumber:(NSString*) phoneNumber;
+ (void) setOldPhoneNumber:(NSString*) phoneNumber;
+ (void) setAgentFullName:(NSString*) agentFullName;
+ (void) setBirthDay:(NSString*) birthDay;
+ (void) setAgentCardID:(NSString*) agentCardID;
+ (void) setEmail:(NSString*) email;
+ (void) setAddress:(NSString*) address;

+ (void) setBalance:(long long) balance;

+ (void) setBankCode:(NSString*) bankCode;
+ (void) setBankName:(NSString*) bankName;
+ (void) setBankAccount:(NSString*) bankAccount;

+ (void) setImei:(NSString*) Imei;
+ (void) setImeiKey:(NSString*) ImeiKey;
+ (void) setSectionKey:(NSString*) SectionKey;
+ (void) setDeviceToken:(NSString*) token;

+ (void) setRegistered:(BOOL) isRegistered;
+ (void) setPhoneActived:(BOOL) isPhoneActived;
+ (void) setNamed:(BOOL)    isNamed;


+ (void) setBonus:(int) bonus;

+ (void) setNonameCount: (int)            nonameCount;
+ (void) setTotalCountToday: (int)        totalCountToday;
+ (void) setTotalAmountToDay: (long long) totalAmountToDay;
+ (void) setMaxLimitAmount: (long long)   maxLimitAmount;

// ATM fee
+ (void) setBankNetDynamicFee:(double) bankNetDynamicFee;
+ (void) setBankNetStaticFee:(double)  bankNetStaticFee;

// Visa master fee
+ (void) setVisaMasterDynamicFee:(double) dynamicFee;
+ (void) setVisaMasterStaticFee:(double) staticFee;

// cashin
+ (void) setCashinVisaMasterDynamicFee:(double) dynamicFee;
+ (void) setCashinVisaMasterStaticFee:(double) staticFee;

+ (void) setEnableMPoint:(BOOL)        enableMPoint;
+ (void) setServerEnableMPoint:(BOOL) enableMPoint;
+ (void) setAgentType:(NSString*)agenttype;
+ (BOOL)      isNamed;
+ (BOOL)      isPhoneActive;
+ (BOOL)      isRegister;

// noname limit
+ (int)       nonameCount;
+ (int)       totalCountToday;
+ (int)       totalAmountToDay;
+ (int)       maxLimitAmount;

+ (int)       bonus;
+ (BOOL)      enableMPoint;

+(NSString *)validatePhoneNumber:(NSString *)phoneStr;

+ (NSArray*) creditCardList;
+ (void) saveCreditCardList:(NSArray*) list;
//+ (void) saveCreditCardListAndSyncWithServer:(NSArray*) list;

+ (void) synchronize;

+ (void) clearSetupedUserData;

+ (void) setShowHideBankNetList:(BOOL)isShow isOnlyVisaMaster:(BOOL)isVisaMasterOnly  isOnlyBankNet:(BOOL)isOnlyBankNetOnly;
+ (BOOL) isShowBanknetList;
+ (BOOL) isShowVisaMasterBankOnly;
+ (BOOL) isShowBankNetOnly;

+ (void) setBanknetCardSelected:(id) classCard;
+ (id) getBanknetCardSelected;
//
+ (BOOL) hasValidSession;

// open url
+ (NSDictionary*) appOpenUrlParams;
+ (void) setAppOpenUrlParams:(NSDictionary*) dict;

// apsLaunchOption
+ (NSDictionary*) apsLaunchOption;
+ (void) setApsLaunchOption:(NSDictionary*) dict;

//123Phim
+(void)setLatestEmailConfirm123Phim:(NSString*)email;
+(NSString*)getLatestEmailConfirm123Phim;

+ (void) checkToggleUsingMPoint;

+ (void) setTransferDetailObject:(id) transferObject;
+(id)getTransferDetailObject;

+(void)setCurrentTransType:(int)transtype;
+(int)getCurrentTransType;

+ (void) setMinConfig:(id) minmaxObject;
+ (void) setMaxConfig:(id) minmaxObject;
+(id)getMinConfig;
+(id)getMaxConfig;

+ (void)setAgentReferenceNumber:(NSString*) agentFullName;
+ (NSString*)getAgentReferenceNumber;
+(NSString*)getScreenIdByType:(int)type;

+(BOOL)getStatusAgentUpdated;
+ (void) setStatusAgentUpdated:(BOOL)statusAgent;
+(int)isNeedToUpdateAgent;

+ (NSArray*)cardTypeList;
+ (void)saveCardTypeList:(NSArray*) list;
+(BOOL)isExistsCardId:(NSString*)cardid andCardType:(NSString*)cardType;

+ (void) setAgentWaitingRegisMoMoShop:(BOOL)statusAgent;
+ (BOOL) isAgentWaitingRegisMoMoShop;
+ (void) setOrginalScreenSizeWidth:(float)orginalSizeWidth;
+ (void) setOrginalScreenSizeHeight:(float)orginalSizeHeight;
+ (float) getOrginalScreenSizeHeight;
+ (float) getOrginalScreenSizeWidth;
+ (NSDictionary*) qrcodeOpenUrlParams;
+ (void) setQrcodeOpenUrlParams:(NSDictionary*) dict;
+ (BOOL) isBankgateWayEnable;
+ (BOOL) isVisaGroup;
+ (void)setEmailForKey:(NSString*)keystore andValue:(NSString*)value;
+ (NSString*)getEmailForKey:(NSString*)keystore;
+ (NSString*) getSectionLogin;

+ (void) setSessionLogin:(NSString*) sessionKey;
+ (void) setPayOfflineParams:(NSDictionary*) dict;
+ (NSDictionary*) getPayOfflineParams;
+ (NSString*) phonePIN;
+ (void) setPhonePIN:(NSString*)pin;
+ (void) setMobilePrefix:(id)prefixList;
+(id)getMobilePrefix;
+ (void) setTypeRefreshForm:(long) typeRefresh;
+(int) getTypeRefreshForm;
+(void)setHiddenMoMoWallet:(BOOL)isHidden;
+(BOOL)isHiddenMoMoWallet;

+(void)setReferenceValue:(id)referenceObject withKey:(NSString*)keyRef;
+(id)getReferenceValueByKey:(NSString*)keyRef;
+(BOOL)isDebug;
@end
