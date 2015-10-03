package vn.mservice.MoMo_Partner;

import android.util.Base64;
import org.apache.http.conn.util.InetAddressUtils;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
import java.util.Collections;
import java.util.List;

/**
 * Created by duybao on 02/10/2015.
 */
public class MoMoUtils {
    public static String getIPAddress(boolean useIPv4) {
        try {
            List<NetworkInterface> interfaces = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface intf : interfaces) {
                List<InetAddress> addrs = Collections.list(intf.getInetAddresses());
                for (InetAddress addr : addrs) {
                    if (!addr.isLoopbackAddress()) {
                        String sAddr = addr.getHostAddress().toUpperCase();
                        boolean isIPv4 = InetAddressUtils.isIPv4Address(sAddr);
                        if (useIPv4) {
                            if (isIPv4)
                                return sAddr;
                        } else {
                            if (!isIPv4) {
                                int delim = sAddr.indexOf('%'); // drop ip6 port suffix
                                return delim<0 ? sAddr : sAddr.substring(0, delim);
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) { } // for now eat exceptions
        return "0.0.0.0";
    }

    public static String encryptRSA(String source, String publicKey) {
        byte[] publicKeyByte = Base64.decode(publicKey, Base64.NO_WRAP);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyByte);
        String encrypted = "";
        try {
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
            cipher.init(Cipher.ENCRYPT_MODE, keyFactory.generatePublic(keySpec));
            encrypted = Base64.encodeToString(cipher.doFinal(source.getBytes()), Base64.NO_WRAP);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e1) {
            e1.printStackTrace();
        } catch (InvalidKeySpecException e1) {
            e1.printStackTrace();
        } catch (InvalidKeyException e1) {
            e1.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        }
        return encrypted;
    }

    public static String buildRequestData(String token){
        String hash = MoMoUtils.encryptRSA(MoMoConfig.MERCHANT_CODE_VALUE + token.split(MoMoConfig.BELL)[0], MoMoConfig.PUBLIC_KEY);
        return token + MoMoConfig.BELL + hash + MoMoConfig.BELL + MoMoUtils.getIPAddress(true) + MoMoConfig.BELL + MoMoConfig.MERCHANT_CODE_VALUE;
    }

}
