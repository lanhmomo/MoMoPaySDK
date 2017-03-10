/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu,Hung.Do on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */

package vn.momo.momo_partner.Client;


public class ClientConfig {

    public static final String MERCHANT_CODE = "merchantcode";

    public static final String MERCHANT_NAME_LABEL = "merchantnamelabel";
    public static final String MERCHANT_NAME = "merchantname";
    public static final String KEY_AMOUNT = "amount";
    public static final String KEY_FEE = "fee";
    public static final String KEY_USER_NAME = "username";
    public static final String KEY_USER_EMAIL = "useremail";
    public static final String SDK_VERSION_VALUE = "Android.MoMoPaySDK.2.1";
    public static final String KEY_MOMO_IS_PRODUCTION = "KEY_MOMO_IS_PRODUCTION";
    public static final String KEY_APP_PAKAGE_CLASS = "KEY_APP_PAKAGE_CLASS";

    public static final String YOUR_SERVER_API_PAYMENT_URL = "http://your_server_ip/api_path";
    public static final String MOMO_APP_PAKAGE_CLASS = "com.mservice"; //Development "com.mservice" - PRODUCTION "com.mservice.momotransfer";
    public static final String MERCHANT_CODE_VALUE = "SCB01"; //follow merchantcode provided by MoMo
    public static final String MERCHANT_NAME_VALUE = "CGV Cinemas";
    public static final String MERCHANT_ALIAS_VALUE = "Nhà cung cấp";

    public ClientConfig() {
    }

    public enum MOMO_ENVIRONMENT {
        DEVELOPMENT,
        PRODUCTION,
        DEBUG,
    }
}
