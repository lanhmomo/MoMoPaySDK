/**
 * Created by lanhluu on 3/6/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */

package vn.momo.momo_partner.Server;

import android.app.Activity;
import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.UUID;

import static vn.momo.momo_partner.Server.ServerConfig.MERCHANT_CODE;
import static vn.momo.momo_partner.Server.ServerConfig.MOMO_API_PAYMENT_URL_DEVELOPMENT;
import static vn.momo.momo_partner.Server.ServerConfig.MOMO_API_PAYMENT_URL_PRODUCTION;
import static vn.momo.momo_partner.Server.ServerConfig.MOMO_PUBLIC_KEY_DEVELOPMENT;
import static vn.momo.momo_partner.Server.ServerConfig.MOMO_PUBLIC_KEY_PRODUCTION;


public class ServerProceedToCheckout {

    /* FOLLOW DOCUMENTATION
    * 1.2 Service flow
    * STEP 4.0
    * */
    public static String sendRequestPaymentOrder(boolean isProduction, String userPhonenumber, String token, String email, int totalAmount, int feeAmount, String referenceValue) {
        String result = "";

        //referenceValue is your extra info value

        String your_ipAdress = "10.10.10.10";
        JSONObject jsonServerPost = new JSONObject();
        JSONObject merchantPakage = new JSONObject();

        try{
            your_ipAdress = ServerUtils.getIPAddress(true);
        }catch (Exception ex){
            your_ipAdress = "10.10.10.10";
        }

        //your uniqueue id here
        final String tranId_test = UUID.randomUUID().toString().replaceAll("-", "");
        final String billId_test = UUID.randomUUID().toString().replaceAll("-", "");

        try {
            jsonServerPost.put("merchantcode", MERCHANT_CODE);  //Require field
            jsonServerPost.put("ipaddress", your_ipAdress);     //Require field - server IP address
            jsonServerPost.put("phonenumber", userPhonenumber); //Require field
            jsonServerPost.put("data", token);                  //Require field

            //Merchant create pakage json before hash
            merchantPakage.put("merchantcode", MERCHANT_CODE);   //Require field
            merchantPakage.put("phonenumber",userPhonenumber);   //Require field
            merchantPakage.put("amount",totalAmount);            //Require field
            merchantPakage.put("fee",feeAmount);                 //Require field
            merchantPakage.put("transid", tranId_test);          //Require field
            merchantPakage.put("username", email);               //Require field
            merchantPakage.put("billid", billId_test);           //Require field
            merchantPakage.put("extra",referenceValue);           //Optional
            String public_key = isProduction ? MOMO_PUBLIC_KEY_PRODUCTION : MOMO_PUBLIC_KEY_DEVELOPMENT;
            String rsa_encrypted = ServerUtils.encryptRSA(merchantPakage.toString(), public_key);

            jsonServerPost.put("hash", rsa_encrypted);   //Require field

            Log.d("merchantPakage ", merchantPakage.toString());

        } catch (JSONException e) {
            Log.d("JSONException ", e.toString());

        }

        Log.d("jsonServerPost ", jsonServerPost.toString());

        String api_createOrder = isProduction ? MOMO_API_PAYMENT_URL_PRODUCTION : MOMO_API_PAYMENT_URL_DEVELOPMENT;

        Log.d("API ",MOMO_API_PAYMENT_URL_DEVELOPMENT);
        try {
            HttpPost request = new HttpPost(api_createOrder);
            //request.addHeader("content-type", "application/json");
            StringEntity se = new StringEntity(jsonServerPost.toString());
            request.setEntity(se);
            DefaultHttpClient client = new DefaultHttpClient();
            HttpResponse response = client.execute(request);
            result = EntityUtils.toString(response.getEntity(), "UTF-8");
        } catch (Exception var7) {
            Log.d("ERROR REQUEST TO SERVER", var7.toString());
        }
        //Log.d("payment_result ",result);

        return result;
    }
}
