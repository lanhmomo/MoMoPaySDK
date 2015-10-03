package vn.mservice.MoMo_Partner;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Handler;

public class MoMoProgressBar {
    private ProgressDialog progress;
    private Handler mHandler = new Handler();
    private onListennerDismissTimeOut Listener;
    private onListennerDismiss ListenerNormal;

    public interface onListennerDismissTimeOut{
        public void onDismiss();
    }

    public interface onListennerDismiss{
        public void onDismissNormal();
    }

    public void setOnDismissTimeOutListenner(onListennerDismissTimeOut onListennerDismissTimeOut) {
        Listener = onListennerDismissTimeOut;
    }

    public void setOnDismissListenner(onListennerDismiss onListennerDismiss) {
        ListenerNormal = onListennerDismiss;
    }

    public void showProgessDialog(final Context context, String message) {
        if (progress == null) {
            progress = new ProgressDialog(context);
            progress.setMessage(message);
            progress.setProgressStyle(ProgressDialog.STYLE_SPINNER);
            progress.setIndeterminate(true);
            progress.setCancelable(false);
            progress.setCanceledOnTouchOutside(false);
            progress.show();
        }
    }

    public void setCancelable(boolean isCancelable){
        progress.setCancelable(isCancelable);
    }

    public void setCanceledOnTouchOutside(boolean isCanceledOnTouchOutside){
        progress.setCanceledOnTouchOutside(isCanceledOnTouchOutside);
    }

    public void dimissProgessDialog() {
        try {
            if (progress != null) {
                progress.dismiss();
                progress = null;

                if (ListenerNormal != null) {
                    ListenerNormal.onDismissNormal();
                    ListenerNormal = null;
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            progress = null;
        }

    }

    public void forceDimissProgessDialog() {
        if (mHandler != null) {
            mHandler = new Handler();
        }
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                dimissProgessDialog();
            }
        }, 5000);
    }

    public void forceDimissProgessDialog(int miliseconds) {
        if (mHandler != null) {
            mHandler = new Handler();
        }
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                try {
                    if (progress != null) {
                        progress.dismiss();
                        progress = null;

                        if(Listener != null){
                            Listener.onDismiss();
                        }
                    }
                }catch (Exception ex){
                    progress = null;
                }
            }
        }, miliseconds);
    }
}
