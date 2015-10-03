package vn.mservice.MoMo_Partner;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.*;
import org.json.JSONException;
import org.json.JSONObject;

public class MoMoPaymentActivity extends Activity implements RequestToServerAsyncTask.RequestToServerListener{
    Button btnPayment;
    TextView tvMessage;
    LinearLayout ll_Parent;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        tvMessage = (TextView) findViewById(R.id.tvMessage_Xml);
        ll_Parent = (LinearLayout) findViewById(R.id.ll_Parent_Xml);
        btnPayment = MoMoPayment.createMoMoPaymentButton(this, ll_Parent);
        btnPayment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MoMoPayment.getTokenByTID(MoMoPaymentActivity.this, "12345", 100000, 1000,
                        "Thanh toán tiền điện thoại",
                        "Nguyễn Duy Bảo");
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == MoMoConfig.GET_INFO && resultCode == RESULT_OK){
            if(data != null){
                if(data.getIntExtra(MoMoConfig.STATUS, -1) == 0){
                    Toast.makeText(this, data.getStringExtra(MoMoConfig.MESSAGE), Toast.LENGTH_SHORT).show();
                    String token = data.getStringExtra(MoMoConfig.DATA);
                    if(token != null && !token.equals("")){
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB){
                            new RequestToServerAsyncTask(this, this).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, token);
                        }else {
                            new RequestToServerAsyncTask(this, this).execute(token);
                        }
                    }else {
                        Toast.makeText(this, getString(R.string.not_receive_info), Toast.LENGTH_SHORT).show();
                    }
                }else if(data.getIntExtra(MoMoConfig.STATUS, -1) == 1){
                    Toast.makeText(this, data.getStringExtra(MoMoConfig.MESSAGE) != null? data.getStringExtra(MoMoConfig.MESSAGE) : "Thất bại", Toast.LENGTH_SHORT).show();
                }else if(data.getIntExtra(MoMoConfig.STATUS, -1) == 2){
                    Toast.makeText(this, getString(R.string.not_receive_info), Toast.LENGTH_SHORT).show();
                }else {
                    Toast.makeText(this, getString(R.string.not_receive_info), Toast.LENGTH_SHORT).show();
                }
            }else {
                Toast.makeText(this, getString(R.string.not_receive_info), Toast.LENGTH_SHORT).show();
            }
        }else {
            Toast.makeText(this, getString(R.string.not_receive_info), Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void receiveResultFromServer(String result) {
        Log.d("MoMo - receiveResult", result);
        try {
            JSONObject jsonObject = new JSONObject(result);
            int status = jsonObject.optInt(MoMoConfig.STATUS);
            if(status == 0){//Thành công
                Toast.makeText(this, jsonObject.optString(MoMoConfig.MESSAGE), Toast.LENGTH_SHORT).show();
            }else if(status == 1){//Thất bại
                Toast.makeText(this, jsonObject.optString(MoMoConfig.MESSAGE), Toast.LENGTH_SHORT).show();
            }else if(status == 2){//Thất bại
                Toast.makeText(this, jsonObject.optString(MoMoConfig.MESSAGE), Toast.LENGTH_SHORT).show();
            }else if(status == 3){//Thất bại
                Toast.makeText(this, jsonObject.optString(MoMoConfig.MESSAGE), Toast.LENGTH_SHORT).show();
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        tvMessage.setText(result);
    }
}
