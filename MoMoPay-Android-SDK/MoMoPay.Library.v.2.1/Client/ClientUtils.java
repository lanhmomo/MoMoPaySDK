package vn.momo.momo_partner.Client;

/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu,Hung.Do on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */


import android.app.Activity;
import android.content.SharedPreferences;
import android.util.Base64;

import org.apache.http.conn.util.InetAddressUtils;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import static android.content.Context.MODE_PRIVATE;

public class ClientUtils {
    public ClientUtils() {
    }

    public static String getIPAddress(boolean useIPv4) {
        try {
            ArrayList ex = Collections.list(NetworkInterface.getNetworkInterfaces());
            Iterator i$ = ex.iterator();

            while(i$.hasNext()) {
                NetworkInterface intf = (NetworkInterface)i$.next();
                ArrayList addrs = Collections.list(intf.getInetAddresses());
                Iterator i$1 = addrs.iterator();

                while(i$1.hasNext()) {
                    InetAddress addr = (InetAddress)i$1.next();
                    if(!addr.isLoopbackAddress()) {
                        String sAddr = addr.getHostAddress().toUpperCase();
                        boolean isIPv4 = InetAddressUtils.isIPv4Address(sAddr);
                        if(useIPv4) {
                            if(isIPv4) {
                                return sAddr;
                            }
                        } else if(!isIPv4) {
                            int delim = sAddr.indexOf(37);
                            return delim < 0?sAddr:sAddr.substring(0, delim);
                        }
                    }
                }
            }
        } catch (Exception var10) {
            ;
        }

        return "0.0.0.0";
    }

    public static void savePreferences(Activity context, String key, String value) {
        SharedPreferences sp = context.getPreferences(MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(key, value);
        editor.commit();
    }

    public static String getPreferences(Activity context, String key) {
        SharedPreferences sp = context.getPreferences(MODE_PRIVATE);

        return sp.getString(key,"");
    }


}