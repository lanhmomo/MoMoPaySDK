MoMoPay SDK  Version 1.0
MoMoPay là cách nhanh nhất, an toàn nhất để trả tiền và thanh toán trực tuyến. Với phương thức thanh toán này cho phép các thành viên có thể chuyển tiền mà không cần chia sẻ thông tin tài chính, với sự linh hoạt trong thanh toán sử dụng số dư tài khoản MoMo, tài khoản ngân hàng, thẻ tín dụng, đặc biệt hữu ích cho các giao dịch mua bán hàng trong nước và nước ngoài.

MoMoPay là một tiện ích của ứng dụng Ví MoMo, thuộc sở hữu của công ty cổ phần M_Service JSC, trụ sở chính ở TP. Hồ Chí Minh, Việt Nam.

Điều kiện sử dụng: Thành viên phải có tài khoản Ví MoMo. Tham khảo cách tạo tài khoản và sử dụng tài khoản tại website của công ty: http://momo.vn/

Các bước tích hợp SDK:
1. Cài đặt SDK
2. Cấu hình SDK
3. Tích hợp mã nguồn
---------------------------------------------***----------------------------------------------
1. Cài đặt SDK
Import gói MoMoPaySDK framework vào xcode project của bạn. Thư viện gồm 3 thành phần: Crypto, Resource, API

Trong source file mà bạn cần sử dụng thư viện MoMoPay SDK:
#import <MoMoPaySDK/MoMoPaySDK.h>

2. Cấu hình MoMoPay SDK

2.1 Cấu hình
Cài đặt lớp MoMoPaySDK vào AppDelegate của ứng dụng
#import "MoMoPaySDK.h"
Trước khi sử dụng SDK, cần thiết lập từ đầu các tham số:
 MERCHANT_CODE: mã thành viên do MoMo cung cấp
MERCHANT_NAME: tên thành viên
 MERCHANT_NAME_LABEL: Tên định nghĩa cho MERCHANT_NAME.  Ví dụ: Nhà cung cấp, nhà phát hành, nhà phân phối
PUBLIC_KEY: mã bí mật do MoMo cung cấp, dùng để Mã hóa chuỗi dữ liệu khi gửi lệnh thanh toán

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [MoMoPaySDK initializingAppBundleId:@"com.appdemoios.momosdk"
                           merchantCode:@"YourCode"
                           merchantName:@"Vinagame"
                           merchantNameLabel:@"Nhà cung cấp"
                           merchantPublicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCI5P/JzX3pA1YC0s/pbfkxznTZSF/iUrnGaYlgI+Lug764cRESreQ6GjSwMPNDjZO8NAyDafd2q7kmbwMhp2stm1901fNA+sSmlrunathGEhuMRUQT4NB3F9rL7fQvMs8pKiPLoDwZEfe5wN2pHcCa6GkOcUMNh1rqX55rGyimXQIDAQAB"];
    return YES;
}

Ưng dụng bạn đang ở phát triển trên sandbox hay production được MoMo phân biệt bởi publickey mà bạn thiết lập. Publickey sẽ được cung cấp cho Merchant khi tạo tài khoản thành viên
Để xem lại các thông số MERCHANT_CODE, MERCHANT_NAME, MERCHANT_NAME_LABEL, PUBLIC_KEY (key dev hoặc key production). Vui lòng xem tại https://developer.momo.vn/ => Vào quản lý ứng dụng của tôi

2.2 Cấu hình handleOpenURL
Trong AppDelegate của ứng dụng gọi hàm [[MoMoPayment shareInstance] handleOpenURL:url] như sau:

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[MoMoPayment shareInstant] handleOpenUrl:url];
    
    return YES;
}
 
3. Tích hợp phương thức thanh toán
Trong MoMoPay SDK, Lớp MoMoPayment chứa tất cả giao diện cần thiết để thực hiện thanh toán. Tất cả hàm trong SDK được sử dụng qua class MoMoPayment này. Các phương thức sử dụng  thông qua việc gọi  [MoMoPayment shareInstance] 

3.1 Đăng ký Notification nhận Token và Kết quả giao dịch
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenReceived:) name:@"NoficationCenterTokenReceived" object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterCreateOrderReceived:) name:@"NoficationCenterCreateOrderReceived" object:nil];
 
3.2 Request token: Mở app MoMo để lấy token thanh toán từ việc mở app MoMo
Cần param các thông tin khi gọi hàm mở app MoMo để lấy token
- merchanttransId: Mã duy nhất trên hệ thống của đối tác cho 1 giao dịch để đối soát với MoMo (bắt buộc)
- amount: Số tiền thanh toán (bắt buộc)
- fee: Phí của Merchant áp dụng đối với người dùng đang giao dịch (không bắt buộc)
- description: Nội dung thanh toán do Đối tác gửi qua lúc mở POPUP trên app MoMo (không bắt buộc)
- username : Là trường dữ liệu định danh người dùng của Merchant (không bắt buộc)

Buoc  1: Khoi tao Payment info và thêm button MoMoPay vào vùng cần hiển thị
NSMutableDictionary *paymentinfo = [[NSMutableDictionary alloc] init];
    [paymentinfo setValue:sampleTransId forKey:MOMO_PAY_CLIENT_MERCHANT_TRANS_ID];
    [paymentinfo setValue:amount forKey:MOMO_PAY_CLIENT_AMOUNT_TRANSFER];
    [paymentinfo setValue:fee forKey:MOMO_PAY_CLIENT_FEE_TRANSFER];//phí, khong bat buoc
    [paymentinfo setValue:description forKey:MOMO_PAY_CLIENT_TRANSFER_DESCRIPTION];
    [paymentinfo setValue:username forKey:MOMO_PAY_CLIENT_USERNAME];
//    [paymentinfo setValue:yourvalue1 forKey:yourkey1];  //key mở rộng thành viên muôn thêm vào
//    [paymentinfo setValue:yourvalue2 forKey:yourkey2]; //key mở rộng thành viên muôn thêm vào 
[[MoMoPayment shareInstant] createPaymentInformation:paymentinfo];

Buoc 2: add button Thanh toan bằng Vi MoMo vao khu vuc ban can hien thi (Vi du o day la vung paymentArea)
  [[MoMoPayment shareInstant] addMoMoPayDefaultButtonToView:paymentArea];
 
3.3 Received token và Request Payment: 
 Dữ liệu trả về khi request Token: dạng JSON
 - giá trị của key "status" = 0: thành công.
 - giá trị của "status" <> 0: có lỗi xảy ra. Thông báo lỗi có trong key "message" trả về.

Video hướng dẫn:
https://www.youtube.com/watch?v=y_zCRqWfIKE&feature=youtu.be
Sample code và Video được thực hiên trên XCode 6.4 

