//
//  MoMoPayment.swift
//  SampleApp-Swift
//
//  Created by Luu Lanh on 4/24/17.
//  Copyright © 2017 LuuLanh. All rights reserved.
//

import Foundation
import UIKit
//let IS_IOS_10_OR_LATER = Int(UIDevice.current.systemVersion) >= 10.0

var paymentInfo: NSMutableDictionary? = nil
let _sharedInstance = MoMoPayment()
struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0)
}
class MoMoPayment: NSObject {
    class var sharedInstance:MoMoPayment {
        return _sharedInstance
    }
//    
//    open func requestToken() {
//        print("requestToken")
//    }
//    
    
    
    open func handleOpenUrl(url: URL, sourceApp: String) {
        //let sourceURI = url.absoluteString! as String
        let sourceURI = url.absoluteString;
        let response = getDictionaryFromUrlQuery(query: sourceURI)
        //let partner = "\(response["fromapp"] as! String)"
        if response.count > 0 {
            let status = "\(response["status"] as! String)"
            let message = "\(response["message"] as! String)"
            if (status == MOMO_TOKEN_RESPONSE_SUCCESS) {
                print("<MoMoPay> SUCESS TOKEN.")
            }
            else if (status == MOMO_TOKEN_RESPONSE_REGISTER_PHONE_NUMBER_REQUIRE) {
                print("<MoMoPay> REGISTER_PHONE_NUMBER_REQUIRE.")
            }
            else if (status == MOMO_TOKEN_RESPONSE_LOGIN_REQUIRE) {
                print("<MoMoPay> LOGIN_REQUIRE.")
            }
            else if (status == MOMO_TOKEN_RESPONSE_NO_WALLET) {
                print("<MoMoPay> NO_WALLET. You need to cashin to MoMo Wallet ")
            }
            
            print("<MoMoPay> \(message)")
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "NoficationCenterTokenReceived"), object: response, userInfo: nil)
        }
        else {
            print("<MoMoPay> Do nothing")
        }
    }
    
    open func getDictionaryFromUrlQuery(query: String) -> (NSDictionary) {
        let info : NSMutableDictionary = NSMutableDictionary()
        
        var correctQuery = query.replacingOccurrences(of: "===", with: "[333]", options: .literal, range: nil)
        correctQuery = query.replacingOccurrences(of: "==", with: "[33]", options: .literal, range: nil)
        
        
        for parameter in correctQuery.components(separatedBy:"&"){
            let parts = parameter.components(separatedBy:"=")
            if parts.count > 1{
                let key = (parts[0] as String).removingPercentEncoding
                let value = (parts[1] as String)  //.removingPercentEncoding
                if key != nil && value != nil{
                    //info[key!] = value
                    var correctValue = value.replacingOccurrences(of: "[333]", with: "===", options: .literal, range: nil)
                    correctValue = value.replacingOccurrences(of: "[33]", with: "==", options: .literal, range: nil)
                    info.setValue(correctValue, forKey: key!)
                }
            }
        }
        
        return info
    }
    
    open func createPaymentInformation(info: NSMutableDictionary) {
        paymentInfo = info
    }
    
    open func addMoMoPayCustomButton(button: UIButton, forControlEvents controlEvents: UIControlEvents, toView parrentView: UIView) -> UIButton {
        
        button.addTarget(self, action: #selector(self.requestToken), for: .touchUpInside)
        
        parrentView.addSubview(button)
        return button
    }
    
    
    open func requestToken() {

        if (paymentInfo as NSMutableDictionary!) == nil {
            print("<MoMoPay> Payment pakageApp should not be null.")
            return;
        }
        
        print("<MoMoPay> requestToken")
        
        //Open MoMo App to get token
        var inputParams = "action=\(MoMoConfig.getAction())&partner=merchant"
        paymentInfo?[MOMO_PAY_CLIENT_MERCHANT_CODE_KEY] = MoMoConfig.getMerchantcode()
        paymentInfo?[MOMO_PAY_CLIENT_MERCHANT_NAME_KEY] = MoMoConfig.getMerchantname()
        paymentInfo?[MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY] = MoMoConfig.getMerchantnameLabel()
        paymentInfo?[MOMO_PAY_CLIENT_PUBLIC_KEY_KEY] = "pubkey"
        paymentInfo?[MOMO_PAY_CLIENT_IP_ADDRESS_KEY] = MoMoConfig.getIPAddress()
        paymentInfo?[MOMO_PAY_CLIENT_OS_KEY] = MoMoConfig.getDeviceInfoString()
        paymentInfo?[MOMO_PAY_CLIENT_APP_SOURCE_KEY] = MoMoConfig.getAppBundleId()
        paymentInfo?[MOMO_PAY_SDK_VERSION_KEY] = MOMO_PAY_SDK_VERSION
        for key in (paymentInfo?.allKeys)! {
            inputParams.append("&\(key as! String)=\(paymentInfo?[key] as! String)")
        }
        
        var appSource:String = "\(MOMO_APP_BUNDLE_ID)://?\(inputParams)"
        appSource = appSource.removingPercentEncoding! as String
        appSource = appSource.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

        print(appSource)
        //let ourURL:URL = (NSURL(string: appSource)?.absoluteURL)! as URL  ;//URL(string: appSource)!
        
        if let urlAppMoMo = URL(string: appSource) {
            //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            if UIApplication.shared.canOpenURL(urlAppMoMo) {
                if let momoAppURL:URL = URL(string:""+"\(appSource)") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(momoAppURL, options: [:], completionHandler: nil);
                    }
                    else {
                        UIApplication.shared.openURL(momoAppURL);
                    }
                }
                else{
                    print("<MoMoPay> momoAppURL fail")
                }
            }
            else {
                var appStoreURL:String = "\(MOMO_APP_ITUNES_DOWNLOAD_PATH)"
                appStoreURL = appStoreURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                if let downloadURL:URL = URL(string:appStoreURL) {
                    if UIApplication.shared.canOpenURL(downloadURL) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(downloadURL, options: [:], completionHandler: nil);
                        }
                        else {
                            UIApplication.shared.openURL(downloadURL);
                        }
                    }
                    
                }
            }
        }
        else {
            print("<MoMoPay> momoAppURL fail")
        }
        
    }
    
    
    /*
     * SERVER SIDE DEMO
     * CALL MOMO API apptest2.momo.vn:8091/paygamebill
     */
    
    open func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    open func requestPayment(parram: NSMutableDictionary) {
        //Sample send request Server-To-Server
//        let jsonHash = "{\"data\":\"\(parram["data"] as! String)\",\"hash\":\"\(parram["hash"] as! String)\",\"ipaddress\":\"\(parram["ipaddress"] as! String)\",\"merchantcode\":\"\(MoMoConfig.getMerchantcode())\",\"phonenumber\":\"\(parram["phonenumber"] as! String)\"}"
//        
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: parram, options: .prettyPrinted)
//            // here "jsonData" is the dictionary encoded in JSON data
//            
//            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//            // here "decoded" is of type `Any`, decoded from JSON data
//            
//            // you can now cast it with the right type
//            if let dictFromJSON = decoded as? [String:String] {
//                // use dictFromJSON
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: parram, options: .prettyPrinted)
            
            // create post request
            let url = NSURL(string: MOMO_PAYMENT_URL)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "NoficationCenterCreateOrderReceived"), object: String(describing: error), userInfo: nil)
                }
                else{
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        
                        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "NoficationCenterCreateOrderReceived"), object: result, userInfo: nil)
                        
                    } catch {
                        //print("Error -> \(error)")
                        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "NoficationCenterCreateOrderReceived"), object: String(describing: error), userInfo: nil)
                    }
                }
                
            }
            
            task.resume()
            
        } catch {
            print(error)
        }
    }
}
