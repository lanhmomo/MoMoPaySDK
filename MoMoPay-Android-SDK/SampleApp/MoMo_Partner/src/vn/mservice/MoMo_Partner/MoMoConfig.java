package vn.mservice.MoMo_Partner;

/**
 * Created by duybao on 01/10/2015.
 */
public class MoMoConfig {
    public static final String momoPackageName = "com.mservice.momotransfer";
    public static final String INTENT_FILTER = "com.android.momo.PAYMENT";
    public static final String IS_MOMO_PARTNER = "IS_MOMO_PARTNER";//Key khong duoc thay doi
    public static final String JSON_PARAM = "JSON_PARAM";//Key khong duoc thay doi
    public static final String STATUS = "status";//Key khong duoc thay doi
    public static final String MESSAGE = "message";//Key khong duoc thay doi
    public static final String DIALOG_TITLE = "DIALOG_TITLE";//Key khong duoc thay doi
    public static final String BUTTON_TITLE = "BUTTON_TITLE";//Key khong duoc thay doi
    public static final String MERCHANT_CODE = "merchantcode";//mã bí mật MoMo cung cấp cho Merchant, Key khong duoc thay doi
    public static final String MERCHANT_CODE_VALUE = "bebongbong2";//mã bí mật MoMo cung cấp cho Merchant, vi du M_service
    public static final String MERCHANT_NAME_LABEL = "merchantnamelabel";//Tên định nghĩa cho Merchant Name, nằm ở vị trí bên trái của Tên merchant. Ví dụ: Nhà cung cấp, nhà phát hành, nhà phân phối
    public static final String MERCHANT_NAME = "merchantname";//Tên Merchant
    public static final String MERCHANT_TRANSACTION_ID = "merchanttransId";//TID duy nhất trên hệ thống của đối tác cho 1 giao dịch để đối soát về sau với MoMo
    public static final String AMOUNT = "amount";//Số tiền thanh toán
    public static final String FEE = "fee";//Phi giao dich
    public static final String DESCRIPTION = "description";//Nội dung thanh toán do Đối tác gửi qua lúc mở POPUP trên app MoMo
    public static final String IP_ADDRESS = "ipaddress";//IP cua may thuc hien
    public static final String USER_NAME = "username";
    public static final String HASH = "hash";
    public static final String DATA = "data";
    public static final int GET_INFO = 1;
    public static final String ACCESS_KEY = "accesskey";//key dev hoac key production do MoMo cung cấp cho Merchant
    public static final String TOTAL_AMOUNT = "totalamount";//Tong chi phi
    public static final String CURRENCY = "currency";//đơn vị tính: mặc định đang la VND
    public static final String SDK_VERSION = "sdkversion";
    public static final String SDK_VERSION_VALUE = "Android.MoMoPaySDK.1.0";
    public static final String MERCHANT_PACKAGE_NAME = "merchantpackagename";
    public static final String REQUEST_URL = "http://10.10.10.186:8082/paygamebill";//"http://apptest2.momo.vn:8091/momopayment";
    public static int transactionFee = 10;
    public static final int TIMEOUT_PAYMENT_PROCESS = 90000;
    public static final char BELL_CHAR = 7;
    public static final String BELL = "" + BELL_CHAR;
    public static final String PUBLIC_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCFLBM/aAkFnTVWV3bD4BCbS2t6uDfsSFgkQgwD" +
            "p5VS5ro3PI1zIG2+BbAm/qvFM0YgwwjwE2ky0CoQSA60Bbm3BiglTBqni5AGU2x/8pwaAjjuEDiJ" +
            "MDsRucg8tZ+Mlu11Q2g7W2AY1t2lWpNZSyBQh0rlvOJxQNFQYGbPioZnYwIDAQAB";
}
