---
description: Hướng dẫn build release cho Android
---
# Hướng dẫn Build Release Android

Bạn đã cấu hình xong signing config. Thực hiện các bước sau để build phiên bản release:

1.  **Cập nhật mật khẩu Keystore:**
    *   Mở file `android/key.properties`.
    *   Cập nhật `storePassword` và `keyPassword` bằng mật khẩu bạn đã nhập khi tạo keystore.
    *   Kiểm tra `keyAlias` xem có đúng là `my-key` không (hoặc alias bạn đã chọn).

2.  **Chạy lệnh Build:**
    *   Mở terminal tại thư mục gốc của dự án (`app/`).
    *   Chạy lệnh:
        ```bash
        flutter build apk --release
        ```
    *   Hoặc để build App Bundle (để upload lên Play Store):
        ```bash
        flutter build appbundle --release
        ```

3.  **Lấy file cài đặt:**
    *   File APK sẽ nằm tại: `build/app/outputs/flutter-apk/app-release.apk`
    *   File AAB sẽ nằm tại: `build/app/outputs/bundle/release/app-release.aab`
