//
//  MoMoPaySDK.swift
//  SampleApp-Swift
//
//  Created by Luu Lanh on 4/24/17.
//  Copyright © 2017 LuuLanh. All rights reserved.
//

import Foundation

class MoMoPaySDK: NSObject {
    open class func initializingAppBundleId(bundleid: String, merchantCode merchantcode: String, merchantName merchantname: String, merchantNameLabel merchantnamelabel: String, merchantPublicKey publickey: String) {
        
        MoMoConfig .setAppBundleId(bundleId: bundleid)
        MoMoConfig .setMerchantcode(merchantCode: merchantcode)
        MoMoConfig .setMerchantname(merchantName: merchantname)
        MoMoConfig .setMerchantnameLabel(merchantnameLabel: merchantnamelabel)
        MoMoConfig .setPublickey(merchantpublickey:publickey)
        print("<MoMoPay> initializing successful - Your app bundleId \(bundleid)")
    }
}
