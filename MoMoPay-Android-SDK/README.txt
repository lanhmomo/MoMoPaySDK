Các bước tích hợp SDK:
1. Import SDK vào project
2. Cấu hình SDK
3. Tích hợp
 
1. Import SDK vào project
Download MoMoPaySDK cho Android và import thư viện vào IDE.

2. Cấu hình SDK
Cấu hình <AndroidMainfest.xml>
Mở file <AndroidMainfest.xml> trong project Android của bạn.
Thêm các dòng sau để cấu hình phân quyền:
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="com.android.vending.BILLING" />
Cài đặt giao diện thanh toán, cấu hình activity như bên dưới:
<activity android:name="com.mservice.momopaysdk.MoMoPaymentActivity" android:configChanges="orientation|keyboardHidden|screenSize"/>

Trước khi sử dụng SDK gọi các hàm thiết lập MERCHANT_CODE,  MERCHANT_NAME_LABEL, CLIENT_IP_ADDRESS, PUBLIC_KEY (chỉ cần khởi tạo 1 lần duy nhất):

Đối với ứng dụng đang ở trạng thái:
MoMoPayment *momoPayment = [MoMoPayment shareInstance];
momoPayment.merchantCode = MERCHANT_CODE;
momoPayment.merchantName = MERCHANT_NAME; //Tên Merchant 
momoPayment.merchantNameLabel = MERCHANT_NAME_LABEL;/ /Tên định nghĩa cho Merchant Name, nằm ở vị trí bên trái của Tên merchant. Ví dụ: Nhà cung cấp, nhà phát hành,...)
momoPayment.ipAddress = CLIENT_IP_ADDRESS;//lấy địa chỉ ip của ứng dụng
momoPayment.publicKey = PUBLIC_KEY;
Để xem lại các thông số MERCHANT_CODE, MERCHANT_NAME, MERCHANT_NAME_LABEL, PUBLIC_KEY (key dev hoặc key production). Vui lòng xem tại https://developer.momo.vn/ => Vào quản lý ứng dụng của tôi

3. Tích hợp thanh toán
MoMoPay SDK cung cấp lớp MoMoPayment đóng gói tất các hàm dùng để tương tác với hệ thống MoMo để lấy token và gửi lệnh thanh toán.

3.1 Request token: Mở app MoMo để lấy token thanh toán
Cần truyền các intent các thông tin khi gọi hàm mở app MoMo để lấy token
- merchanttransId (Mã duy nhất trên hệ thống của đối tác cho 1 giao dịch để đối soát với hệ thống MoMo)
- amount (Số tiền thanh toán)
- fee (Phí chưa áp dụng)
- description (Nội dung thanh toán do Đối tác gửi qua lúc mở POPUP trên app MoMo)
-  username : Là trường dữ liệu định danh người dùng của Merchant 
MoMoPayment.getTokenByTID(merchanttransId,amount,fee,description,username) 

4. Chạy SDK Samples
Tham khảo ví dụ mẫu trong SampleApp
