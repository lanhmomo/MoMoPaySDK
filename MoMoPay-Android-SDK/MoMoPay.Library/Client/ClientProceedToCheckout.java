/**
 * Created by lanhluu on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */

package vn.momo.momo_partner.Client;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.net.Uri;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.Button;

import java.util.Iterator;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import vn.momo.momo_partner.R;
import vn.momo.momo_partner.Server.ServerProceedToCheckout;

import static vn.momo.momo_partner.Client.ClientConfig.KEY_AMOUNT;
import static vn.momo.momo_partner.Client.ClientConfig.KEY_APP_PAKAGE_CLASS;
import static vn.momo.momo_partner.Client.ClientConfig.KEY_FEE;
import static vn.momo.momo_partner.Client.ClientConfig.KEY_MOMO_IS_PRODUCTION;
import static vn.momo.momo_partner.Client.ClientConfig.KEY_USER_EMAIL;
import static vn.momo.momo_partner.Client.ClientConfig.KEY_USER_NAME;
import static vn.momo.momo_partner.Client.ClientConfig.MERCHANT_CODE;
import static vn.momo.momo_partner.Client.ClientConfig.MERCHANT_NAME;
import static vn.momo.momo_partner.Client.ClientConfig.MERCHANT_NAME_LABEL;
import static vn.momo.momo_partner.Client.ClientConfig.SDK_VERSION_VALUE;
import static vn.momo.momo_partner.Client.ClientConfig.YOUR_SERVER_API_PAYMENT_URL;


public class ClientProceedToCheckout {
    public ClientProceedToCheckout() {
    }

    public static Button createMoMoPaymentButton(Activity activity, ViewGroup parent) {
        Button btn = (Button)activity.getLayoutInflater().inflate(R.layout.btn_momo_payment_layout, (ViewGroup)null);
        parent.addView(btn);
        return btn;
    }

    public  static void InitMerchant(Activity activity, String pakageMoMoApp, String merchantCode, String aliasname, String aliasLabel){
        ClientUtils.savePreferences(activity,MERCHANT_CODE,merchantCode);
        ClientUtils.savePreferences(activity,MERCHANT_NAME,aliasname);
        ClientUtils.savePreferences(activity,MERCHANT_NAME_LABEL,aliasLabel);
        ClientUtils.savePreferences(activity,KEY_APP_PAKAGE_CLASS,pakageMoMoApp);
    }


    public  static  void  SetupEnvironment(Activity activity, ClientConfig.MOMO_ENVIRONMENT environmentValue){
        String isProduct = (environmentValue == ClientConfig.MOMO_ENVIRONMENT.PRODUCTION)? "1" : "0";
        ClientUtils.savePreferences(activity,KEY_MOMO_IS_PRODUCTION,isProduct);

    }


    /* FOLLOW DOCUMENTATION
   * 1.2 Service flow
   * STEP 1.0
   * */
    public static void getTokenByTID(Activity activity, int amount, String description, String userName, String userEmail) {

        boolean isProduction = Boolean.getBoolean(ClientUtils.getPreferences(activity,KEY_MOMO_IS_PRODUCTION));

        if(hasMoMo(activity)) {
            Intent intent = new Intent();
            intent.setAction("com.android.momo.PAYMENT");
            intent.putExtra("IS_MOMO_PARTNER", true);
            intent.putExtra("DIALOG_TITLE", "Xác nhận thanh toán");
            intent.putExtra("BUTTON_TITLE", activity.getString(R.string.confirm));
            intent.putExtra("IS_PRODUCTION", isProduction);
            JSONObject jsonObject = new JSONObject();

            String _appname = "Unknown";
            try{
                ApplicationInfo applicationInfo = activity.getApplicationContext().getApplicationInfo();
                int stringId = applicationInfo.labelRes;
                _appname = (stringId == 0) ? applicationInfo.nonLocalizedLabel.toString() : activity.getApplicationContext().getString(stringId);
            }
            catch (Exception ex){}

            try {
                jsonObject.put("merchantcode", ClientUtils.getPreferences(activity,MERCHANT_CODE));
                jsonObject.put("merchantnamelabel", ClientUtils.getPreferences(activity,MERCHANT_NAME_LABEL));
                jsonObject.put("merchantname", ClientUtils.getPreferences(activity,MERCHANT_NAME));
                jsonObject.put("merchanttransId", "");
                jsonObject.put("amount", amount);
                jsonObject.put("fee", 0);
                jsonObject.put("description", description);
                jsonObject.put("username", userEmail);
                jsonObject.put("sdkversion",SDK_VERSION_VALUE);
                jsonObject.put("clientIp",ClientUtils.getIPAddress(true));
                jsonObject.put("appname",_appname);

                ClientUtils.savePreferences(activity,KEY_AMOUNT,""+amount);
                ClientUtils.savePreferences(activity,KEY_FEE,"0");
                ClientUtils.savePreferences(activity,KEY_USER_NAME,userName);
                ClientUtils.savePreferences(activity,KEY_USER_EMAIL,userEmail);
            } catch (JSONException var9) {
                var9.printStackTrace();
            }

            intent.putExtra("JSON_PARAM", jsonObject.toString());
            Log.d("Open app intent ", jsonObject.toString());
            activity.startActivityForResult(intent, 1);
        }

    }

    public static boolean hasMoMo(Activity activity) {
        boolean result = false;
        Iterator iterator = activity.getPackageManager().getInstalledApplications(0).iterator();

        String _pakageClass = ClientUtils.getPreferences(activity,KEY_APP_PAKAGE_CLASS);

        Log.d("_pakageClass ", _pakageClass);
        do {
            if(!iterator.hasNext()) {
                if(!result) {
                    //Toast.makeText(activity, activity.getString(R.string.notice_install_app), Toast.LENGTH_LONG).show();
                    try {
                        activity.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("market://details?id="+_pakageClass)));
                    } catch (Exception var4) {
                        activity.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("http://play.google.com/store/apps/details?id=com.mservice.momotransfer")));
                    }
                }

                return result;
            }
        } while(!((ApplicationInfo)iterator.next()).packageName.equals(_pakageClass));

        return true;
    }

    /* FOLLOW DOCUMENTATION
    * 1.2 Service flow
    * STEP 3.0
    * */
    public static String sendRequestToYourServer(final Activity activity, final String userPhonenumber, final String token) {

        final boolean isProduction = Boolean.getBoolean(ClientUtils.getPreferences(activity,KEY_MOMO_IS_PRODUCTION));

        /*
        String result = "";
        JSONObject clientPakage = new JSONObject();
        try{
            clientPakage.put("merchantcode", ClientUtils.getPreferences(activity,MERCHANT_CODE));
            clientPakage.put("amount",Integer.parseInt(ClientUtils.getPreferences(activity,KEY_AMOUNT)));
            clientPakage.put("fee",Integer.parseInt(ClientUtils.getPreferences(activity,KEY_FEE)));
            clientPakage.put("useremail", ClientUtils.getPreferences(activity,KEY_USER_EMAIL));
            clientPakage.put("token", token);           //Require field
            clientPakage.put("phonenumber",userPhonenumber);   //Require field
            clientPakage.put("extra","your_extra");           //Optional
            clientPakage.put("isProduction",isProduction);
        }
        catch (Exception ex){}



        try {
            HttpPost request = new HttpPost(YOUR_SERVER_API_PAYMENT_URL);
            //request.addHeader("content-type", "application/json");
            StringEntity se = new StringEntity(jsonServerPost.toString());
            request.setEntity(se);
            DefaultHttpClient client = new DefaultHttpClient();
            HttpResponse response = client.execute(request);
            result = EntityUtils.toString(response.getEntity(), "UTF-8");
        } catch (Exception var7) {
            Log.d("ERROR REQUEST TO SERVER", var7.toString());
        }

        return  result;
        */

        //Demo server checkout //Only testing environment
        
        return ServerProceedToCheckout.sendRequestPaymentOrder(isProduction,userPhonenumber,token,ClientUtils.getPreferences(activity,KEY_USER_EMAIL),Integer.valueOf(ClientUtils.getPreferences(activity,KEY_AMOUNT)),Integer.valueOf(ClientUtils.getPreferences(activity,KEY_FEE)),"your_extra");
    }
}
