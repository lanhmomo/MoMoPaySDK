/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu,Hung.Do on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */


package vn.momo.momo_partner.Client;



import android.app.Activity;
import android.os.AsyncTask;
import android.util.Log;

import vn.momo.momo_partner.R;

public class ClientHttpAsyncTask extends AsyncTask<String, Void, String> {
    private Activity activity;
    private ClientProgressBar progressBar;
    private ClientHttpAsyncTask.RequestToServerListener listener;
    private String phoneNumber = "";

    public ClientHttpAsyncTask(Activity activity, ClientHttpAsyncTask.RequestToServerListener listener, String _phoneNumber) {
        this.activity = activity;
        this.listener = listener;
        phoneNumber = _phoneNumber;
    }

    protected void onPreExecute() {
        super.onPreExecute();
        if(this.progressBar == null) {
            this.progressBar = new ClientProgressBar();
        }
        Log.d("Đang thực hiện","");

        this.progressBar.showProgessDialog(this.activity, this.activity.getString(R.string.processing_payment_through_momo));
        this.progressBar.forceDimissProgessDialog(90000);
        this.progressBar.setCancelable(true);
    }

    protected String doInBackground(String... params) {

        String token = "";

        try{
            token = params[0];
        }
        catch (Exception ex){}

        return ClientProceedToCheckout.sendRequestToYourServer(this.activity,phoneNumber,token);
    }

    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        if(this.progressBar != null) {
            this.progressBar.dimissProgessDialog();
        }

        Log.d("post result ",result);
        this.listener.receiveResultFromServer(result);
    }

    public interface RequestToServerListener {
        void receiveResultFromServer(String var1);
    }
}
