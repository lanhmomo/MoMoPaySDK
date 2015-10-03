package vn.mservice.MoMo_Partner;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.graphics.Color;
import android.net.Uri;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.util.InetAddressUtils;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

/**
 * Created by duybao on 01/10/2015.
 * 1. Tao nut nut thanh toan qua MoMo
 * 2. Mo app MoMo lay token
 * 3. Post thong tin qua server de request thanh toan
 */
public class MoMoPayment {
    public static Button createMoMoPaymentButton(Activity activity, ViewGroup parent){
        Button btn = (Button)activity.getLayoutInflater().inflate(R.layout.btn_momo_payment_layout, null);
        parent.addView(btn);
        return btn;
    }

    public static void getTokenByTID(Activity activity, String merchanttransId, int amount, int fee,
                                     String description, String userName){
        if(hasMoMo(activity)){
            Intent intent = new Intent();
            intent.setAction(MoMoConfig.INTENT_FILTER);
            intent.putExtra(MoMoConfig.IS_MOMO_PARTNER, true);
            intent.putExtra(MoMoConfig.DIALOG_TITLE, activity.getString(R.string.confirm_payment));
            intent.putExtra(MoMoConfig.BUTTON_TITLE, activity.getString(R.string.confirm));

            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put(MoMoConfig.MERCHANT_CODE, MoMoConfig.MERCHANT_CODE_VALUE);
                jsonObject.put(MoMoConfig.MERCHANT_NAME_LABEL, activity.getString(R.string.supplier_title));
                jsonObject.put(MoMoConfig.MERCHANT_NAME, activity.getString(R.string.supplier_name));
                jsonObject.put(MoMoConfig.MERCHANT_TRANSACTION_ID, merchanttransId);
                jsonObject.put(MoMoConfig.AMOUNT, amount);
                jsonObject.put(MoMoConfig.FEE, fee);
                jsonObject.put(MoMoConfig.DESCRIPTION, description);
                jsonObject.put(MoMoConfig.USER_NAME, userName);
            } catch (JSONException e) {
                e.printStackTrace();
            }

            intent.putExtra(MoMoConfig.JSON_PARAM, jsonObject.toString());
            activity.startActivityForResult(intent, MoMoConfig.GET_INFO);
        }
    }

    public static boolean hasMoMo(Activity activity){
        boolean result = false;
        Iterator iterator = activity.getPackageManager().getInstalledApplications(0).iterator();
        while (iterator.hasNext()){
            if(((ApplicationInfo)iterator.next()).packageName.equals(MoMoConfig.momoPackageName)){
                return true;
            }
        }

        if(!result){
            Toast.makeText(activity, activity.getString(R.string.notice_install_app), Toast.LENGTH_LONG).show();
            try {
                activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + MoMoConfig.momoPackageName)));
            }catch (Exception ex){
                activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://play.google.com/store/apps/details?id=" + MoMoConfig.momoPackageName)));
            }
        }
        return result;
    }

    public static String sendRequestToServer(String URLConnect, String para){
        String result = "";
        try{
            HttpPost httppost = new HttpPost(URLConnect);
            StringEntity se = new StringEntity(para);
            httppost.setEntity(se);

            HttpClient client = new DefaultHttpClient();

            HttpResponse response = client.execute(httppost);
            result = EntityUtils.toString(response.getEntity(), HTTP.UTF_8);
        }catch (Exception e){
            Log.d("MoMo REQUEST TO SERVER", e.toString());
        }
        return result;
    }

}
