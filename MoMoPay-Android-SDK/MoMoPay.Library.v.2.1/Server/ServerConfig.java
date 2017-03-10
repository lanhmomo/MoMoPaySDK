package vn.momo.momo_partner.Server;

/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */

public class ServerConfig {

    public static final String MERCHANT_CODE = "SCB01";
    public static final String KEY_MERCHANT_TRANSACTION_ID = "merchanttransId";
    public static final String KEY_AMOUNT = "amount";
    public static final String KEY_FEE = "fee";

    public static final String KEY_USER_NAME = "username";
    public static final String KEY_BILL_ID = "billid";

    public static final String MOMO_API_PAYMENT_URL_PRODUCTION = "http://app.momo.vn:8082/paygamebill";
    public static final String MOMO_API_QUERY_URL_PRODUCTION   = "http://app.momo.vn:8082/queryorder";

    public static final int TIMEOUT_PAYMENT_PROCESS = 90000;
    public static final String MOMO_PUBLIC_KEY_PRODUCTION = "";

    public static final String MOMO_API_PAYMENT_URL_DEVELOPMENT = "http://apptest2.momo.vn:8091/paygamebill";
    public static final String MOMO_API_QUERY_URL_DEVELOPMENT   = "http://apptest2.momo.vn:8091/queryorder";
    public static final String MOMO_PUBLIC_KEY_DEVELOPMENT      = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkpa+qMXS6O11x7jBGo9W3yxeHEsAdyDE40UoXhoQf9K6attSIclTZMEGfq6gmJm2BogVJtPkjvri5/j9mBntA8qKMzzanSQaBEbr8FyByHnf226dsLt1RbJSMLjCd3UC1n0Yq8KKvfHhvmvVbGcWfpgfo7iQTVmL0r1eQxzgnSq31EL1yYNMuaZjpHmQuT24Hmxl9W9enRtJyVTUhwKhtjOSOsR03sMnsckpFT9pn1/V9BE2Kf3rFGqc6JukXkqK6ZW9mtmGLSq3K+JRRq2w8PVmcbcvTr/adW4EL2yc1qk9Ec4HtiDhtSYd6/ov8xLVkKAQjLVt7Ex3/agRPfPrNwIDAQAB";

    public ServerConfig() {
    }

    public enum MOMO_ENVIRONMENT {
        DEVELOPMENT,
        PRODUCTION,
        DEBUG,
    }
}
