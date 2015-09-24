MoMoPay SDK 

MoMoPay là cách nhanh nhất, an toàn nhất để trả tiền và thanh toán trực tuyến. Dịch vụ này cho phép các thành viên có thể chuyển tiền mà không cần chia sẻ thông tin tài chính, với sự linh hoạt trong thanh toán sử dụng số dư tài khoản, tài khoản ngân hàng, thẻ tín dụng, đặc biệt hữu ích cho các giao dịch bán hàng xuyên biên giới.
MoMoPay là một tiện ích của ứng dụng Ví MoMo, thuộc sở hữu của công ty của MService, trụ sở chính ở TP. Hồ Chí Minh, Việt Nam.
Điều kiện sử dụng: Thành viên phải có tài khoản Ví MoMo. Tham khảo cách tạo tài khoản và sử dụng tài khoản tại website của công ty: http://momo.vn/
Các bước tích hợp SDK:
1. Cài đặt SDK
2. Cấu hình SDK
3. Tích hợp mã nguồn
----------------------------------------------------***----------------------------------------------------

1. Cài đặt SDK
Thêm MoMoPaySDK.framework vào project
Import gói MoMoPaySDK.framework và file MoMoPaySDKBundle.bundle vào project của bạn.
Trong mục project app’s target settings, tìm mục Build phases và mở Link Binary with Libraries. Click vào nút ‘+’ và chọn để add các framework:
SystemConfiguration.framework, Security.framework, CFNetwork.framework, QuaztCore.framework,
MessageUI.framework, StoreKit.framework, AudioToolbox.framework, MobileCoreServices.framework

Import headers vào trong source files cần hiển thị Link Thanh toán Bằng Ví MoMo:
Trong source file mà bạn cần sử dụng thư viện MoMoPay SDK:
#import <MoMoPaySDK/MoMoPaySDK.h>

2. Cấu hình SDK
2.1 Cấu hình MoMoPay Configuration

Các hàm trong MoMoPay được sử dụng qua class MoMoPayment. Các phương thức cấu hình SDK sử dụng thông qua lớp shareInstance [MoMoPayment shareInstance]

Trước khi sử dụng SDK gọi các hàm thiết lập MERCHANT_CODE,  MERCHANT_NAME_LABEL, CLIENT_IP_ADDRESS, PUBLIC_KEY (chỉ cần khởi tạo 1 lần duy nhất):
Đối với ứng dụng đang ở trạng thái sandbox:
MoMoPayment *momoPayment = [MoMoPayment shareInstance];
momoPayment.merchantCode = MERCHANT_CODE;
momoPayment.merchantName = MERCHANT_NAME; //Tên Merchant 
momoPayment.merchantNameLabel = MERCHANT_NAME_LABEL;/ /Tên định nghĩa cho Merchant Name, nằm ở vị trí bên trái của Tên merchant. Ví dụ: Nhà cung cấp, nhà phát hành,...)
momoPayment.ipAddress = CLIENT_IP_ADDRESS;//lấy địa chỉ ip của ứng dụng
momoPayment.publicKey = PUBLIC_KEY;

Để xem lại các thông số MERCHANT_CODE, MERCHANT_NAME, MERCHANT_NAME_LABEL, PUBLIC_KEY (key dev hoặc key production). Vui lòng xem tại https://developer.momo.vn/ => Vào quản lý ứng dụng của tôi

2.2 Cấu hình handleOpenURL
Trong AppDelegate của ứng dụng gọi hàm [[MoMoPayment shareInstance] handleOpenURL:url] như sau:
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*) sourceApplication annotation:(id)annotation {     
    [[MoMoPayment shareInstance] handleOpenURL:url];
    return YES;
}

3. Tích hợp mã nguồn
Trong MoMoPay SDK, Lớp MoMoPayment chứa tất cả giao diện cần thiết để thực hiện thanh toán. 
 
3.1 Request token: Mở app MoMo để lấy token thanh toán
Cần input các thông tin khi gọi hàm mở app MoMo để lấy token
- merchanttransId (Mã duy nhất trên hệ thống của đối tác cho 1 giao dịch để đối soát với hệ thống MoMo)
- amount (Số tiền thanh toán)
- fee (Phí chưa áp dụng)
- description (Nội dung thanh toán do Đối tác gửi qua lúc mở POPUP trên app MoMo)
-  username : Là trường dữ liệu định danh người dùng của Merchant 
[[MoMoPayment shareInstance] getTokenByTID: merchanttransId andAmount: amount andFee: fee andDescription: description andAccount: username];

3.2 Reply token và Do Payment: Được xử lý tại phương thức handleOpenURL của lớp MoMoPayment
Đã cài đặt tại AppDelegate
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*) sourceApplication annotation:(id)annotation {     
    [[MoMoPayment shareInstance] handleOpenURL:url];
    return YES;
}

Tham khảo thêm ví dụ mẫu tại SampleApp-Xcode hoặc SampleApp-Swift

Copyright @MoMo 2015
