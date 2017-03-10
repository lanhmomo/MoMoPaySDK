package vn.momo.momo_partner.Server;

/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */


import android.app.Activity;
import android.os.AsyncTask;

public class ServerHttpAsyncTask extends AsyncTask<String, Void, String> {
    private Activity activity;
    private ServerHttpAsyncTask.RequestToServerListener listener;
    private String bill_phoneNumber = "";
    private String bill_useremail = "";
    private int bill_amount = 0;
    private String bill_extra = "";
    private  boolean isProduction;

    public ServerHttpAsyncTask(Activity activity, ServerHttpAsyncTask.RequestToServerListener listener, String _phoneNumber, String _email, int totalAmount, String extra, boolean _isProduction) {
        this.activity = activity;
        this.listener = listener;
        bill_phoneNumber = _phoneNumber;
        bill_extra = extra;
        bill_amount = totalAmount;
        bill_useremail = _email;
        isProduction = _isProduction;
    }

    protected void onPreExecute() {
        super.onPreExecute();

    }

    protected String doInBackground(String... params) {

        String token = "";

        try{
            token = params[0];
        }
        catch (Exception ex){}

        return ServerProceedToCheckout.sendRequestPaymentOrder(isProduction,bill_phoneNumber,token,bill_useremail,bill_amount,0,"your_extra");
    }

    protected void onPostExecute(String result) {
        super.onPostExecute(result);

        this.listener.receiveResultFromServer(result);
    }

    public interface RequestToServerListener {
        void receiveResultFromServer(String var1);
    }
}
