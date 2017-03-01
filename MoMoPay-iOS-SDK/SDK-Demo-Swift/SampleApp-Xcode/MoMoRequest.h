//
//  BaseRequest.h
//  MomoTransfer
//
//  Created by nvthinh on 5/19/14.
//  Copyright (c) 2014 M_Service. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MomoTransferAppSingleton.h"
#import "NetworkCenter.h"

#import "AFNetworking.h"
//#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#define ReceivedUpdateAgentInfoEvent    @"ReceivedUpdateAgentInfoEvent"
#define ReceivedTransactionHistoryEvent @"ReceivedTransactionHistoryEvent"
#define ReceivedNewNotificationEvent    @"ReceivedNewNotificationEvent"

#define ReceivedCardListEvent           @"ReceivedCardListEvent"
#define ReceivedAddCardEvent            @"ReceivedAddCardEvent"

#define TRANSFER_REQUEST_COMMAND_INDEX_LATEST  @"TRANSFER_REQUEST_COMMAND_INDEX_LATEST"

enum MsgCmdType {
    ACK         	=	1,
    ERROR       	=	2,
    SEND_SMS    	=	3,
    
    HELLO       	=	1001,
    HELLO_REPLY 	=	1002,
    
    GET_OTP         	=	1003,
    GET_OTP_REPLY   	=	1004,
    
    VERIFY_OTP          	=	1005,
    VERIFY_OTP_REPLY    	=	1006,
    
    LOGIN       	=	1007,
    LOGIN_REPLY 	=	1008,
    
    REGISTER          	=	1009,
    REGISTER_REPLY    	=	1010,
    
    USER_INFO_RECOVERY_PIN        	=	1011,
    USER_INFO_RECOVERY_PIN_REPLY  	=	1012,
    
    GET_BILL_INFO          	=	1013,
    GET_BILL_INFO_REPLY    	=	1014,
    
    DEVICE_INFO         	=	1015,
    DEVICE_INFO_REPLY   	=	1016,
    
    CHANGE_PIN         	=	1017,
    CHANGE_PIN_REPLY   	=	1018,
    
    BILLPAY_GET_ALL         	=	1019,
    BILLPAY_GET_ALL_REPLY   	=	1020,
    
    PHONE_EXIST         	=	1021,
    PHONE_EXIST_REPLY   	=	1022,
    
    LOG_OUT         	=	1023,
    LOG_OUT_REPLY   	=	1024,
    
    CHECK_MOMO_AGENT 	=	1025,
    CHECK_MOMO_AGENT_REPLY	=	1026,
    
    RECOVERY_NEW_PIN 	=	1027,
    RECOVERY_NEW_PIN_REPLY 	=	1028,
    
    WHO_IS_MOMOER 	=	1029,
    WHO_IS_MOMOER_REPLY 	=	1030,
    
    VIEW_PAYMENT_HISTORY_BY_BILL_ID         	=	1031,
    VIEW_PAYMENT_HISTORY_BY_BILL_ID_REPLY   	=	1032,
    
    BILL_SYNC_REPLY 	=	1033,
    
    GET_ACCESS_HISTORY 	=	1034,
    GET_ACCESS_HISTORY_REPLY 	=	1035,
    
    SESSION_EXPIRED_REPLY    	=	1036,
    
    UPDATE_AGENT_INFO 	=	1037,
    BILL_SYNC 	=	1038,
    
    TRANS_REPLY = 1059,
    
    GET_STORES_AROUND = 1060,
    
    GET_STORES_AROUND_REPLY = 1061,
    
    BANK_NET_TO_MOMO_REPLY = 1063,
    
    MONEY_REQUEST = 1066,
    
    MONEY_REQUEST_REPLY = 1067,
    
    BROADCAST     = 1068,
    
    TRAN_ACK = 1069,
    
    TRANS_REQUEST = 1070,
    
    TRAN_SYNC = 1071,
    
    TRAN_SYNC_REPLY = 1072,
    
    TRAN_RECEIVER = 1073,
    
    STORE_LOCATION_SYNC = 1074,
    STORE_LOCATION_SYNC_REPLY = 1075,
    
    //core used this one to send changed location info to server
    //server send this one to client when client connect to server
    STORE_LOCATION = 1076,
    
    //for transfer app
    TRANSFER_REQUEST = 1077,
    BANK_NET_TO_MOMO_REQUEST = 1078,
    
    //add card
    CARD_ADD_OR_UPDATE         = 1079,
    CARD_ADD_OR_UPDATE_REPLY   = 1080,
    
    CARD_SYNC        = 1081,
    CARD_SYNC_REPLY  = 1082,
    
    TICKET_INFO_REPLY=1083,
    
    AGENT_MODIFY = 1084,
    AGENT_MODIFY_REPLY = 1085,
    
    AVATAR_UPLOAD = 1086,
    AVATAR_UPLOAD_REPLY = 1087,
    
    /* AVATAR_DOWNLOAD = 1088,
     AVATAR_DOWNLOAD_REPLY=1089,*/
    
    //LoanCountLimit
    ECHO = 1090,
    ECHO_REPLY = 1091,
    NEW_USER=1092,
    
    TRAN_STATISTIC_PER_DAY =1093,
    TRAN_STATISTIC_PER_DAY_REPLY= 1094,
    
    GET_FEE = 1095,
    GET_FEE_REPLY=1096,
    
    NO_MORE_BILLS = 1099, // reply this message to client when syns bill competed.
    
    REMOVE_SAVED_BILL = 1100,
    REMOVE_SAVED_BILL_REPLY = 1101,
    
    TRAN_DELETE = 1102,
    TRAN_DELETE_REPLY = 1103,
    
    // notification
    NOTIFICATION_SYNC = 1104,
    NOTIFICATION_SYNC_REPLY = 1105,
    NOTIFICATION_SYNC_FINISH = 1106,
    
    
    NOTIFICATION_NEW = 1107,
    NOTIFICATION_RECEIVED = 1108,
    
    TRAN_SYNC_FINISH = 1109,
    
    UPDATE_NOTIFICATIONS_STATUS = 1110,
    UPDATE_NOTIFICATIONS_STATUS_REPLY = 1111,
    
    GET_BANK_OF_BANKNET= 1112,
    GET_BANK_OF_BANKNET_REPLY= 1113,
    
    //su dung de thanh toan nhieu bill khi cho nguon la banknet
    BANKNET_VERIFY_OTP =1114,
    BANKNET_VERIFY_OTP_REPLY =1115,
    
    GET_DYNAMIC_CONFIG = 1118,
    GET_DYNAMIC_CONFIG_REPLY = 1119,
    
    CREATE_ORDER_123PHIM =1120,
    CREATE_ORDER_123PHIM_REPLY =1121,
    
    GET_MIN_MAX_TRAN =1122,
    GET_MIN_MAX_TRAN_REPLY =1123,
    
    GET_PROMOTION = 1124,
    GET_PROMOTION_REPLY=1125,

    GET_PROMOTION_DETAIL= 1126,
    GET_PROMOTION_DETAIL_REPLY= 1127,
    
    INVITE_STATISTIC = 1130,
    INVITE_STATISTIC_REPLY =1131,
    
    GET_SERVICE = 1132,
    GET_SERVICE_REPLY = 1133,
    
    GET_SERVICE_LAYOUT = 1134,
    GET_SERVICE_LAYOUT_REPLY = 1135,
    
    WHOLE_SYSTEM_PAUSED = 1136,
    
    GET_NOTIFICAITON = 1137,
    GET_NOTIFICATION_REPLY = 1138,
    GET_SERVICE_BY_LAST_TIME = 1139,
    GET_SERVICE_BY_SERVICE_ID = 1140,
    GET_SERVICE_BY_SERVICE_ID_REPLY =1141,
    GET_PROMO_STUDENT = 1142,
    GET_PROMO_STUDENT_REPLY =1143,
    
    GET_STORE_RATE = 1144,
    GET_STORE_RATE_REPLY = 1145,
    GET_STORE_COMMENT_PAGE = 1146,
    GET_STORE_COMMENT_PAGE_REPLY = 1147,
    RATE_STORE = 1148,
    RATE_STORE_REPLY = 1149,
    STORE_COMMENT_CRUD = 1150,
    STORE_COMMENT_CRUD_REPLY = 1151,
    GET_STORE_WARNING_TYPE = 1152,
    GET_STORE_WARNING_TYPE_REPLY = 1153,
    WARN_STORE = 1154,
    WARN_STORE_REPLY = 1155,
    
    NOTIFICATION_RECEIVED_REPLY = 1156,
    
    GET_AGENT_INFO = 1157, // body : PhoneExist dgd lay thong tin cua customer truoc khi dinh danh
    GET_AGENT_INFO_RELY = 1158, // body : AgentInfo
    
    
    GIFT_CLAIM       = 1159,
    GIFT_CLAIM_REPLY = 1160,
    
    GET_USER_SETTING        = 1161,
    GET_USER_SETTTING_REPLY = 1162,
    
    SET_USER_SETTING        = 1163,
    SET_USER_SETTING_REPLY  = 1164,
    
    GET_GIFT_TYPE       = 1165,
    GET_GIFT_TYPE_REPLY = 1166,
    
    GET_GIFT        = 1167,
    GET_GIFT_REPLY  = 1168,
    GET_GIFT_FINISH = 1169,
    
    SET_GIFT_STATUS = 1170,
    
    SEND_GIFT_MESSAGE       = 1171,
    SEND_GIFT_MESSAGE_REPLY = 1172,
    
    FTP_INFO             = 1173, // khong co body lay thong tin ftp
    FTP_INFO_REPLY       = 1174, // body FtpReply
    CLEAR_ALL_NOTI       = 1175,
    CLEAR_ALL_NOTI_REPLY = 1176,
    
    USE_GIFT             = 1177,    // GiftRequest
    USE_GIFT_REPLY       = 1178,  // standard body
    
    CAN_USE_GIFT         = 1179,    // GiftRequest
    CAN_USE_GIFT_REPLY   = 1180,  // standard body
    
    CHECK_BILL           = 1181,          //body  CheckBill
    CHECK_BILL_REPLY     = 1182,    // body StandafrdReply
    
    ADD_FIELD   = 1183, // body Fields
    ADD_FIELD_REPLY = 1184, //body StandardReply
    
    GET_TRAN_CONFIRM_INFO = 1185, // tranhisv1
    GET_TRAN_CONFIRM_INFO_REPLY = 1186, //GetTranConfirmReply
    
    GET_FORM_FIELDS = 1187, // client lay danh sach cac fields cua 1 form/ 1 dich vu
    // body la Fields
    
    GET_FORM_FIELDS_REPLY = 1188, // tra ve lient danh sach cac fielditem cua dich vu nay de client ve form
    
    SUBMIT_FORM = 1189, // client gui toan bo thong tin collect tu user len server
    // body Fields
    
    SUBMIT_FORM_REPLY = 1190, // tra ket qua ve client
    //body FromReply
    
    GET_VALUE_FOR_DROPBOX = 1191, // body Fied ( TextValue -->set vao id ; key id)
    GET_VALUE_FOR_DROPBOX_REPLY = 1192, // body ValueForDropBox
    
    GET_CATEGORY = 1193,
    GET_CATEGORY_REPLY=1194,
    
    TRANSLATE_CONFIRM_INFO = 1195,
    TRANSLATE_CONFIRM_INFO_REPLY = 1196,
    
    MUST_UPDATE_INFO = 1197,
    MUST_UPDATE_INFO_REPLY = 1198,
    
    DGD_GET_FEE = 1199,
    DGD_GET_FEE_REPLY= 1200,
    
    GET_BALANCE = 1201, // body GetBalance
    GET_BALANCE_REPLY = 1202, //GetBalance
    
    GET_INFO_ALERT_TYPE = 1203,         // lay loai man hinh
    GET_INFO_ALERT_TYPE_REPLY = 1204,   // tra ket qua theo lasttime : list of InfoAlertType
    
    SUBMIT_INFO_ALERT = 1205,           // client gui InfoAlert den server
    SUBMIT_INFO_ALERT_REPLY = 1206,     // tra ket qua la StandardReply
    
    GET_C2C_INFO = 1207,     // body GetC2cInfo
    GET_C2C_INFO_REPLY=1208, // body GetC2cInfoReply
    
    GET_OTP_FOR_CLIENT = 1209, // body GetOptForClient
    GET_OTP_FOR_CLIENT_REPLY = 1210, // body StandardReply
    
    GET_LIQUIDITY = 1211,
    GET_LIQUIDITY_REPLY = 1212, //body TextValueMsg
    //key       value
    //caption   ""
    //content   ""
    
    GET_CARD_LIST = 1213,
    GET_CARD_LIST_REPLY = 1214,
    
    DELETE_TOKEN = 1215,
    DELETE_TOKEN_REPLY = 1216,
    
    CREATE_TOKEN = 1217,
    CREATE_TOKEN_REPLY = 1218,
    
    GET_CARD_TYPE = 1219,
    GET_CARD_TYPE_REPLY = 1220, //body ServiceReply

    GET_FEE_BANK = 1221,
    
    GET_FEE_BANK_REPLY = 1222,
    
    REATE_ORDER_CUNGMUA = 1223,
    CREATE_ORDER_CUNGMUA_REPLY = 1224,
    
    CONFIRM_WALLET_MAPPING = 1225, // Tra loi xem co xac nhan map vi hay khong.
    
    CONFIRM_WALLET_MAPPING_REPLY = 1226, // Tra loi xem co huy thanh cong hay khong.
    
    CHECK_USER_RESET_PASSWORD = 1227, //body: TextValueMsg -> key “os” = “Android”, “app_code” = “140”
    CHECK_USER_RESET_PASSWORD_REPLY = 1228,// TextValueMsg -> key "result" = "true" hoac "false
    RESET_PASSWORD_VALUE = 1229,
    RESET_PASSWORD_REPLY = 1230
};

enum StandardResultCode{
    SRESULT_ALL_OK                 = 0,
    SRESULT_MSG_FORMAT_NOT_CORRECT = 1,
    SRESULT_NOT_HELLO_YET          = 2,
    SRESULT_NUMBER_NOT_VALID       = 3,
    SRESULT_SYSTEM_ERROR           = 4,
    SRESULT_NOT_SET_UP             = 5,
    SRESULT_NUMBER_EXISTED         = 6,
    SRESULT_OLD_PIN_NOT_CORRECT    = 7,
    SRESULT_IS_BLOCKING            = 8
};

enum THANKS_TYPE{
    MONEY_THANKS = 1,
    GIFT_THANKS = 2
};

@class MoMoRequest;
@class TransferRequest;
@class UserRequest;
@class BillRequest;


@protocol ResponseCenterDelegate <NSObject>
@optional

// common
- (void) request:(MoMoRequest*) request receivedResponseResult:(BOOL)      result;
- (void) request:(MoMoRequest*) request
receivedResponseResult:(BOOL)      result
       errorCode:(int)       errorCode
     errorString:(NSString*) errorString;


- (void) requestTimeout:(MoMoRequest*) request errorString:(NSString*) errorString;
- (void) requestCannotSend:(MoMoRequest*) request errorString:(NSString*) errorString;
- (void) requestReceivedResponseACK:(MoMoRequest*) request;

// user request

- (void) userRequest:(UserRequest*) request receivedMoMoerList:(NSArray*) list;
- (void) userRequest:(UserRequest*) request
       receivedPhone:(NSString*)    phone
                name:(NSString*)    name
              cardId:(NSString*)    cardId
               exist:(BOOL)         exist
            isStores:(BOOL)      isStore;

- (void) userRequestReceivedNotificationSyncReply:(UserRequest*) request;
- (void) userRequestReceivedNotificationSyncFinish:(UserRequest*) request;

- (void) userRequest:(UserRequest*) request checkNewVersionAppStore:(NSString*) version;
- (void) userRequest:(UserRequest*) request receivedSavedCardList:(NSArray*) list;

- (void) userRequest:(UserRequest*) request receivedStoreRate:(NSArray*) list;
- (void) userRequest:(UserRequest*) request receivedStoreCommentList:(NSArray*) list;
- (void) userRequest:(UserRequest*) request receivedStoreComment:(id) comment;

- (void) userRequest:(UserRequest *)request receivedCardType:(NSMutableArray*)list;
- (void) userRequest:(UserRequest *)request receivedCreateToken:(NSString*)postUrl param:(NSDictionary*)postData errorDescription:(NSString*)errString errrCode:(NSString*)errCode;
- (void) userRequest:(UserRequest *)request receivedTextValueMsgReply:(NSDictionary *)list;

- (void) userRequest:(UserRequest*) request
receivedStoreCommentCrubReply:(int) errorCode
         description:(NSString*) description
           commentId:(NSString*) commentId;

- (void)  userRequest:(UserRequest *)request receivedWarningStoreTypeList:(NSArray *) warningString warningId:(NSArray*) warningId;

- (void) userRequest:(UserRequest*) request receivedWarningStoreReply:(int) errorCode description:(NSString*) description;


- (void) userRequest:(UserRequest*)  request
 uploadCustomerPhoto:(NSArray*)      imageList
           userPhone:(NSString*)     phone
            userInfo:(NSDictionary*) userInfo
              result:(BOOL)          result
           errorDesc:(NSString*)     errorDesc;



//- (void) transferRequestReceivedGetOTPReply:(TransferRequest*) request;

- (void) transferRequestGetOTPResultSuccess:(TransferRequest*) request hasOTP:(BOOL)hasOtp errorString:(NSString*)error;
- (void) transferRequest:(TransferRequest*) request
          getOTPFailCode:(int) resultCode
            resultString:(NSString*) resultString;

- (void) transferRequestReceivedMoneyRequestReply:(TransferRequest*) request;

- (void) transferRequestReceivedGetFeeReply:(TransferRequest*) request;

- (void) transferRequestReceivedGetFeeBanknetReply:(TransferRequest*) request textvalueMsg:(NSMutableDictionary*)dicTextValues;

- (void) transferRequestReceivedOrderFilmReply:(TransferRequest*) request
                                    resultCode:(int)        rcode
                                    invoice_no:(NSString*) invoice_no
                                   ticket_code:(NSString*) ticket_code
                                  total_amount:(long long) total_amount;

- (void) transferRequestReceivedGetPromotionDetailReply:(TransferRequest*) request smsContent:(NSString*) sms;
- (void) transferRequestReceivedGetPromotionDetailReply:(TransferRequest*) request introContent:(NSString*)content;

- (void) transferRequest:(TransferRequest*) request
          getInviteSuccessNames:(NSArray*) names
                        phones:(NSArray*) phones;

- (void) transferRequest:(TransferRequest*) request
   receivedTransHisArray:(NSArray*)     array;

- (void) transferRequestReceivedTranSyncFinish:(TransferRequest*) request;

- (void) transferRequest:(TransferRequest*) request
     receivedBalanceMoMo:(long long)        momo
               giftValue:(long long)        giftValue
                  mpoint:(long long)        mpoint;


- (void) transferRequest:(TransferRequest*) request
 receivedTransferC2CInfo:(id)     info;

#pragma mark - Bill Request

- (void) billRequest:(BillRequest*) request
   receivedBillArray:(NSArray*)     array;

-(void) billRequest:(BillRequest *)request SyncBillprocessing:(BOOL)hasBill;

- (void) billRequest:(BillRequest*) request
 receivedServiceList:(NSArray*)     array;

- (void) billRequest:(BillRequest*) request receivedGetServiceInfoNotFound:(NSString*)errorString;

- (void) billRequest:(BillRequest*) request
 receivedVoucherList:(NSArray*)     array;

- (void) billRequest:(BillRequest*) request
  receivedSubmitForm:(NSMutableArray*)arrayTexts arrayValue:(NSMutableArray*)arrayVals isContinue:(int)nextstep titleDialog:(NSString*)titleDialog buttonTitle:(NSString*)buttonTitle;
@end





@interface MoMoRequest: NSObject

@property (nonatomic, weak) id<ResponseCenterDelegate> delegate;
@property (nonatomic) long long cmdIndex;

@property (nonatomic) int       cmdType;          // send type
@property (nonatomic) int       receiveCmdType;   // recv type

@property (nonatomic) BOOL      needShowTimeoutAlert;   //  need to show time out alert
@property (nonatomic) BOOL      needRemoveWhenReceiveReply; // set NO if request can received multi reply msg (sync request...)
@property (nonatomic) int       timeout;   //  in milisecond, set 0: infinite -> needRemoveWhenReceiveReply = NO

- (id) initWithDelegate:(id<ResponseCenterDelegate>) delegate;

- (void) sendRequestWithMsgData:(NSData*) data cmdType:(int) cmdType;

+ (MoMoRequest*)               reqForCmdIndex:(long long) cmdIndex;
+ (void) removeRequestWithCmdIndex:(long long) cmdIndex;
+ (void) stopAllRequests;

// call back
- (void) sendDelegateResponseResult:(BOOL)      result;
- (void) sendDelegateResponseResult:(BOOL)      result
                          errorCode:(int)       errorCode
                        errorString:(NSString*) errorString;

// standard reply
-(void)receivedStandardReply:(NSData *)bodyData;
@end
