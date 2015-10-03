Các bước tích hợp SDK:
1. Import SDK vào project
2. Cấu hình SDK
3. Tích hợp
 
1. Import SDK vào project
Download MoMoPaySDK cho Android và import thư viện vào IDE.

2. Cấu hình SDK
   2.1 Cấu hình <AndroidMainfest.xml>
     Mở file <AndroidMainfest.xml> trong project Android của bạn.
     Thêm dòng sau để cấu hình phân quyền: <uses-permission android:name="android.permission.INTERNET" />

   2.2 Thiết lập các tham số ban đầu:
     1. MoMoConfig.MERCHANT_CODE_VALUE: được định nghĩa trong lớp MoMoConfig, được Mservice cung cấp.
     2. MoMoConfig.REQUEST_URL: địa chỉ gọi đến server của MoMo, được Mservice cung cấp.
     3. MoMoConfig.PUBLIC_KEY: để mã hóa ra hash, được Mservice cung cấp.
     4. MerchantNameLabel: tiêu đề của tên công ty, được định nghĩa trong res/values/strings.xml với name:supplier_title,
     không cần thiết lập cũng được, mặc định là "Nhà cung cấp".
     5. MerchantName: tên của quý công ty, được định nghĩa trong res/values/strings.xml với name:supplier_name, mặc định là
     "Công ty ABC".
     

3. Tích hợp thanh toán
MoMoPay SDK cung cấp lớp MoMoPayment, RequestToServerAsyncTask, MoMoUtils đóng gói tất các hàm dùng để tương tác với hệ thống
MoMo để lấy token và gửi lệnh thanh toán.

Ở giao diện cần thêm nút thanh toán qua MoMo.

  3.1. Tạo nút thanh toán bằng ví MoMo bằng cách gọi hàm: MoMoPayment.createMoMoPaymentButton(...) và truyền vào các tham số:
    1. Activity đang làm việc.
    2. Đối tượng view cha chứa nút cần thêm vào.
  
  3.2 Thiết lập sự kiện setOnClickListener cho nút vừa mới tạo, trong hàm onClick(View v) gọi hàm MoMoPayment.getTokenByTID
  (...) và truyền vào các tham số:
    1. Activity đang làm việc.
    2. merchanttransId: Mã duy nhất trên hệ thống của đối tác cho 1 giao dịch để đối soát với MoMo. (bắt buộc)
    3. Số tiền giao dịch. (bắt buộc)
    4. Phí giao dịch. Phí của Merchant áp dụng đối với người dùng đang giao dịch (không bắt buộc)
    5. description: nội dung thanh toán. (không bắt buộc)
    6. userName: tên của người giao dịch. (không bắt buộc)

  3.3 implements RequestToServerAsyncTask.RequestToServerListener để override receiveResultFromServer(String result để 
  nhận kết quả trả về từ server của MoMo là 1 JSONObject có 2 key được định nghĩa trong MoMoConfig.STATUS, MoMoConfig.MESSAGE.
    giá trị của status = 0: thành công.
    giá trị của status = 1, 2, 3: lỗi.

  3.4 Override hàm onActivityResult(...) để nhận kết quả trả về (tham khảo SampleApp).
    1. Nhận data trả về từ MoMo app.
    2. Gọi lệnh "RequestToServerAsyncTask(this, this).execute(token);" để gửi yêu cầu thanh toán lên server bên MoMo.
    
4. Chạy SDK Samples
Tham khảo ví dụ mẫu trong SampleApp
