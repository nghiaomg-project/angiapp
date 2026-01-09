# Authentication Flow Documentation (JWT Implementation)

Tài liệu này mô tả luồng xác thực (Authentication Flow) sử dụng JWT (JSON Web Token) giữa Client (Flutter App) và Server (Go Backend).

## 1. Token Usage
Hệ thống sử dụng mô hình "Access Token + Refresh Token":
- **Access Token:**
  - Thời hạn: Ngắn (1 giờ).
  - Dùng để: Xác thực các request gửi lên API (trong header `Authorization: Bearer <token>`).
- **Refresh Token:**
  - Thời hạn: Dài (7 ngày).
  - Dùng để: Lấy Access Token mới khi cái cũ hết hạn mà không cần user đăng nhập lại (Tính năng này có thể implement sau ở endpoint `/api/refresh-token`).

## 2. Generate Token (Backend)
**File:** `pkg/token/token.go` -> `GenerateTokenPair(userID)`
- Tạo Access Token chứa `user_id` và `exp` (1 giờ).
- Tạo Refresh Token chứa `user_id` và `exp` (7 ngày).
- Ký JWT bằng khóa bí mật (`JWT_SECRET` trong `.env`).

## 3. Login Flow (Google)

### Bước 1: App gửi ID Token (Client)
- **File:** `app/lib/core/auth/auth_service.dart` -> `loginWithGoogle()`
- App đăng nhập qua Google Sign-In SDK, nhận về `idToken`.
- Gửi `POST /api/login/google` kèm `id_token`.

### Bước 2: Backend xử lý (Server)
- **File:** `internal/handler/user.handler.go` -> `GoogleLogin`
- Gọi `service.LoginWithGoogle`.
- **Logic (`user.service.go`):**
  1. Verify `idToken` với Google Server.
  2. Lấy `email` từ token. Tìm user trong DB. Nếu chưa có -> Tạo mới.
  3. Gọi `token.GenerateTokenPair(user.ID)` để tạo cặp token mới.
- **Response:** Trả về JSON:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "access_token": "...",
      "refresh_token": "...",
      "user": { ... }
    }
  }
  ```

### Bước 3: App lưu Token (Client)
- `AuthService` nhận response.
- Lưu `access_token` và `refresh_token` vào `FlutterSecureStorage` (kho lưu trữ oan toàn trên điện thoại).

## 4. Auto-Login Flow (Khi mở lại App)

### Bước 1: Khởi tạo (App Start)
- **File:** `main.dart` -> gọi `AuthService().init()`.
- **File:** `AuthService.dart` -> `init()`:
  - Đọc `access_token` từ Secure Storage.
  - Nếu có token -> Gọi `fetchUserProfile(accessToken)`.

### Bước 2: Verify Token (Backend)
- App gửi `GET /api/profile` với header `Authorization: Bearer <access_token>`.
- **Middleware (`middleware/auth.middleware.go`):**
  - Chặn request, tách token từ header.
  - Gọi `token.ValidateToken(tokenString)`.
  - Nếu Token hợp lệ: Lấy `UserID` từ token -> Gắn vào `Context` (`r.WithContext`).
  - Nếu Token lỗi/hết hạn: Trả về 401 Unauthorized.

### Bước 3: Kết quả
- Nếu Backend trả về 200 OK (Profile):
  - App: Set `_isLoggedIn = true`.
  - User vào thẳng màn hình chính.
- Nếu Backend trả về 401 (Lỗi):
  - App: Gọi `logout()` (xóa token lỗi) -> Chuyển về màn hình Login.
