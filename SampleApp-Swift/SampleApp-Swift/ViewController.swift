//
//  ViewController.swift
//  SampleApp-Swift
//
//  Created by Luu Lanh on 4/24/17.
//  Copyright © 2017 LuuLanh. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var lblMessage: UILabel!
    var txtAmount: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterCreateOrderReceived), name:NSNotification.Name(rawValue: "NoficationCenterCreateOrderReceived"), object: nil)
        
        initLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * SERVER SIDE DEMO
     * SERVER CALL MOMO API apptest2.momo.vn:8091/paygamebill
     */
    func NoficationCenterTokenReceived(notif: NSNotification) {
        //Token Replied - Call Payment to MoMo Server
        print("::MoMoPay Log::Received Token Replied::\(notif.object!)")
        lblMessage.text = "RequestToken response:\n \(notif.object!)"
        
        let response:NSMutableDictionary     = notif.object as! NSMutableDictionary
        
        print(">>response::\(notif.object!)")
        print(">>status::\(response["status"] as! String)   :: message \(response["message"] as! String) ")
        
        let _status:Int = Int(response.value(forKey: "status") as! String)!
        
        if _status == 0 {
            
            print("::MoMoPay Log: SUCESS TOKEN. CONTINUE TO CALL API PAYMENT")
            print(">>phone \(response["phonenumber"] as! String)   :: data \(response["data"] as! String)")
            
            let merchant_code       = "SCB01"
            let merchant_transaction_id = "123456789"
            let merchant_bill_id        = "bill1001"
            let merchant_username       = "username_001"
            let merchant_server_ip       = "192.16.17.120"
            
            let orderInfo = NSMutableDictionary();
            orderInfo.setValue(Int(10000),			forKey: "amount");
            orderInfo.setValue(Int(0),			forKey: "fee");
            orderInfo.setValue(merchant_code,			forKey: "merchantcode");
            orderInfo.setValue(merchant_transaction_id,			forKey: "transid");
            orderInfo.setValue(merchant_bill_id,			forKey: "billid");
            orderInfo.setValue(merchant_username,			forKey: "username");
            orderInfo.setValue(response["phonenumber"] as! String,			forKey: "phonenumber");

            
            let your_hash_value_sample = "RSA_orderInfo_by_public_key" ;// RSA orderInfo json using MoMo's Public key
            
            
            let dataPayment : NSMutableDictionary = NSMutableDictionary()
            dataPayment .setValue(merchant_code,                       forKey: "merchantcode")
            dataPayment.setValue(your_hash_value_sample,		 forKey: "hash");
            dataPayment.setValue(merchant_server_ip,		 forKey: "ipaddress");
            dataPayment.setValue(response["data"] as! String,		 forKey: "data");
            dataPayment.setValue(response["phonenumber"] as! String,	 forKey: "phonenumber");

            //MoMoPayment.sharedInstance.requestPayment(parram: dataPayment)
            lblMessage.text = "RequestToken response:\n \(notif.object!) | Please continue to proccess on server "
        }
        else{
            lblMessage.text = "RequestToken response:\n \(notif.object!) | Fail token. Please check input params "
        }
    }
    
    func NoficationCenterCreateOrderReceived(notif: NSNotification) {
        //Payment Order Replied
        //    NSString *responseString = [[NSString alloc] initWithData:[notif.object dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
        //
        print("::MoMoPay Log::Request Payment Replied::\(notif.object!)")

        lblMessage.text = "RequestPayViaMoMo response:\n \(notif.object!)"
        if (notif.object! is [NSObject : AnyObject]) {
            let response:NSDictionary = notif.object! as! NSDictionary

            let _status:Int = Int(response.value(forKey: "status") as! String)!
            if _status == 0 {
                print("::MoMoPay Log::Payment Success")
            }
            else {
                print("::MoMoPay Log::Payment Error::\(response["message"] as! String)")
            }
            
            //continue your checkout order here
        }
    }
    
    func dictionaryFromUrlParram(_ urlPararm: String) -> NSDictionary {
       
        let mapdata = NSMutableDictionary();
        
        //var params = NSMutableDictionary()
        let sourceText = urlPararm
        let components = sourceText.components(separatedBy:"&")
        for param: String in components {
            if let arrayKeyVal: NSArray = param.components(separatedBy: "=") as NSArray? {
                
                if arrayKeyVal.count < 2 {
                    continue;
                }
                
                let key = (arrayKeyVal[0] as! String).removingPercentEncoding!
                let value = (arrayKeyVal[1] as! String).removingPercentEncoding!
                mapdata.setValue(value, forKey: key)
            }
        }
        
        return mapdata
    }
    
    
    func initLayout() {
        
        let codedLabel:UILabel = UILabel()
        codedLabel.frame = CGRect(x: 10, y: 50, width: 300, height: 30)
        codedLabel.textAlignment = .center
        codedLabel.text = "Development Environment"
        codedLabel.numberOfLines=1
        codedLabel.textColor=UIColor.red
        codedLabel.font=UIFont.systemFont(ofSize: 18)
        codedLabel.backgroundColor=UIColor.clear
        self.view .addSubview(codedLabel)
        
        //var paymentArea = UIView(frame: CGRectMake(20, 100, 300, 300))
        //paymentArea.backgroundColor = UIColor.whiteColor()
        
        let paymentArea:UIView = UIView()
        paymentArea.frame = CGRect(x: 20, y: 100, width: 300, height: 300)
        paymentArea.backgroundColor=UIColor.clear
        
        //var imgMoMo = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        
        let imgMoMo:UIImageView = UIImageView()
        imgMoMo.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imgMoMo.image = UIImage(named: "momo.png")!
        paymentArea.addSubview(imgMoMo)
        
        let lbl:UILabel = UILabel()
        lbl.frame = CGRect(x: 60, y: 0, width: 200, height: 20)
        lbl.text = "Merchant Id: \(MoMoConfig.getMerchantcode())"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.backgroundColor = UIColor.clear
        paymentArea.addSubview(lbl)
        
        let lbl2:UILabel = UILabel()
        lbl2.frame = CGRect(x: 60, y: 30, width: 200, height: 20)
        lbl2.text = "Merchant Name: \(MoMoConfig.getMerchantname())"
        lbl2.font  = UIFont.boldSystemFont(ofSize: 15)
        lbl2.backgroundColor = UIColor.clear
        paymentArea.addSubview(lbl2)
        
        let lbl3:UILabel = UILabel()
        lbl3.frame = CGRect(x: 10, y: 60, width: 200, height: 30)
        lbl3.text = "Total amount:   10.000 đ"
        lbl3.font = UIFont.boldSystemFont(ofSize: 15)
        lbl3.accessibilityValue = "10000"
        lbl3.backgroundColor = UIColor.clear
        paymentArea.addSubview(lbl3)
        
        let line:UIView = UIView()
        line.frame = CGRect(x: 110, y: 85, width: 100, height: 1)
        line.backgroundColor = UIColor.gray
        paymentArea.addSubview(line)
        
        //Tạo button Thanh toán bằng Ví MoMo
        var btnPay:UIButton = UIButton()
        btnPay.frame = CGRect(x: 10, y: 100, width: 260, height: 40)
        btnPay.setTitle("Pay Via MoMo Wallet", for: .normal)
        btnPay.setTitleColor(UIColor.white, for: .normal)
        btnPay.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        btnPay.backgroundColor = UIColor.purple
        btnPay = MoMoPayment.sharedInstance .addMoMoPayCustomButton(button: btnPay, forControlEvents: .touchUpInside, toView: paymentArea)
        
        //let lblMessage:UILabel = UILabel()
        lblMessage = UILabel()
        lblMessage.frame = CGRect(x: 60, y: 100, width: 300, height: 200)
        lblMessage.text = "{MoMo Response}"
        lblMessage.font = UIFont.systemFont(ofSize: 15)
        lblMessage.backgroundColor = UIColor.clear
        lblMessage.lineBreakMode = NSLineBreakMode.byWordWrapping // || NSLineBreakMode.byTruncatingTail
        lblMessage.numberOfLines = 0
        paymentArea.addSubview(lblMessage)
        
        
        let amount = "10000"
        //Số tiền thanh toán ở đây
        let fee = "0"
        //Phí của bạn đặt ở đây (phí của Merchant charge user)
        let username = "your_username_or_accountId"
        //Tai khoan dang login de thuc hien giao dich nay (khong bat buoc)
        
        //Buoc 1: Khoi tao Payment info, add button MoMoPay
        let paymentinfo = NSMutableDictionary()
        paymentinfo[MOMO_PAY_CLIENT_MERCHANT_TRANS_ID] = "41129898989"
        paymentinfo[MOMO_PAY_CLIENT_AMOUNT_TRANSFER] = amount
        paymentinfo[MOMO_PAY_CLIENT_FEE_TRANSFER] = fee
        paymentinfo[MOMO_PAY_CLIENT_USERNAME] = username
        paymentinfo[MOMO_PAY_CLIENT_ACTION]   = MOMO_PAY_SDK_ACTION_GETTOKEN
        MoMoPayment.sharedInstance.createPaymentInformation(info: paymentinfo)
        
        //Buoc 2: add button Thanh toan bang Vi MoMo vao khu vuc ban can hien thi (Vi du o day la vung paymentArea)
        ///Default MoMo Button [[MoMoPayment shareInstant] addMoMoPayDefaultButtonToView:paymentArea];
        ///Custom button
        
        
        
        //Code của bạn
        self.view.addSubview(paymentArea)
    }
}

