package vn.mservice.MoMo_Partner;

import android.app.Activity;
import android.os.AsyncTask;
import android.util.Log;

/**
 * Created by duybao on 02/10/2015.
 */
public class RequestToServerAsyncTask extends AsyncTask<String, Void, String> {
    public interface RequestToServerListener{
        void receiveResultFromServer(String result);
    }

    private Activity activity;
    private MoMoProgressBar progressBar;
    private RequestToServerListener listener;

    public RequestToServerAsyncTask(Activity activity, RequestToServerListener listener){
        this.activity = activity;
        this.listener = listener;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        if(progressBar == null){
            progressBar = new MoMoProgressBar();
        }
        progressBar.showProgessDialog(activity, activity.getString(R.string.processing_payment_through_momo));
        progressBar.forceDimissProgessDialog(MoMoConfig.TIMEOUT_PAYMENT_PROCESS);
        progressBar.setCancelable(true);
    }

    @Override
    protected String doInBackground(String... params) {
        String requestData = MoMoUtils.buildRequestData(params[0]);
        Log.d("MoMo - requestData", requestData);
        return MoMoPayment.sendRequestToServer(MoMoConfig.REQUEST_URL, requestData);
    }

    @Override
    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        if(progressBar != null){
            progressBar.dimissProgessDialog();
        }
        listener.receiveResultFromServer(result);
    }
}
