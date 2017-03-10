package vn.momo.momo_partner.Server;

/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */


import android.util.Base64;
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
import org.apache.http.conn.util.InetAddressUtils;

import static android.content.Context.MODE_PRIVATE;

public class ServerUtils {
    public ServerUtils() {
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

    public static String encryptRSA(String source, String publicKey) {
        byte[] publicKeyByte = Base64.decode(publicKey, 2);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyByte);
        String encrypted = "";

        try {
            KeyFactory e = KeyFactory.getInstance("RSA");
            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
            cipher.init(1, e.generatePublic(keySpec));
            encrypted = Base64.encodeToString(cipher.doFinal(source.getBytes()), 2);
        } catch (NoSuchAlgorithmException var7) {
            var7.printStackTrace();
        } catch (NoSuchPaddingException var8) {
            var8.printStackTrace();
        } catch (InvalidKeySpecException var9) {
            var9.printStackTrace();
        } catch (InvalidKeyException var10) {
            var10.printStackTrace();
        } catch (BadPaddingException var11) {
            var11.printStackTrace();
        } catch (IllegalBlockSizeException var12) {
            var12.printStackTrace();
        }

        return encrypted;
    }
}