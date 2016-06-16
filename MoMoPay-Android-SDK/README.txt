Các bước tích hợp SDK:
1. Import SDK vào project
2. Cấu hình SDK
3. Tích hợp
 
1. Import SDK vào project
Download MoMoPaySDK cho Android và import thư viện vào IDE.

2. Cấu hình SDK
   Cấu hình <AndroidMainfest.xml>
     Mở file <AndroidMainfest.xml> trong project Android của bạn.
     Thêm dòng sau để cấu hình phân quyền: <uses-permission android:name="android.permission.INTERNET" />

3. Tích hợp thanh toán
MoMoPay SDK cung cấp lớp MoMoPayment, MoMoConfig, MoMoProgressBar đóng gói tất các hàm dùng để tương tác với hệ thống
MoMo để lấy token và gửi lệnh thanh toán.

Ở giao diện cần thêm nút thanh toán qua MoMo.

  3.1. Tạo nút thanh toán bằng ví MoMo, rồi trong sự kiện onClick() của nút hãy gọi hàm: MoMoPayment.requestToken(...) và truyền vào các tham số:
    1. Activity đang làm việc (Activity activity).
    2. Số tiền cần thanh toán (int amount).
    3. Phí (của bên các bạn, nếu có) (int fee).
    4. Nội dung thanh toán (String description).
    5. Tên của người sử dụng (String userName).
    6. Mã merchant do bên MoMo cung cấp(String merchantCode).
    7. Tiêu đề (ví dụ : Nhà cung cấp)(String merchantNameLabel).
    8. Tên nhà cung cấp (Ví dụ : Công ty ABC) (String merchantName).
    9. Các tham số muốn truyền thêm tùy ý, dạng Json, sẽ được nhận lại từ app MoMo trong hàm onActivityResult (data.getStringExtra(MoMoConfig.DATA), đã được mã hóa) (JSONObject jsObj).
 
  3.2 Override hàm onActivityResult(...) để nhận kết quả trả về từ app MoMo(tham khảo SampleApp).
    1. Nhận data trả về từ MoMo app gồm các key:
    2. "status" : kết quả trả về: 0 là thành công, các trạng thái lỗi còn lại được mô tả chi tiết trong file hướng dẫn
    3. "message" : nội dung thông báo trả về
    4. "data" : dữ liệu đã được mã hóa từ app MoMo trả về.
    5. "phonenumber" : số điện thoại đang đăng nhập app MoMo.
4. Chạy SDK Samples
Tham khảo ví dụ mẫu trong SampleApp

Video hướng dẫn:  https://www.youtube.com/watch?v=dROKDXQ965o&feature=youtu.be
