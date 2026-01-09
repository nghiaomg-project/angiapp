# AuthService Documentation

**File:** `lib/core/auth/auth_service.dart`

`AuthService` là một lớp Singleton quản lý toàn bộ logic xác thực của ứng dụng, bao gồm đăng nhập Google, quản lý phiên đăng nhập (session state), và lưu trữ thông tin người dùng. Nó kế thừa `ChangeNotifier` để thông báo cho UI khi trạng thái đăng nhập thay đổi.

## 1. Import
```dart
import 'package:flutter/foundation.dart'; // Cho ChangeNotifier
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In Plugin
import 'package:http/http.dart' as http; // Gọi API Backend
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Đọc biến môi trường (.env)
```

## 2. Singleton Pattern
Lớp sử dụng singleton pattern để đảm bảo chỉ có một instance duy nhất tồn tại trong suốt vòng đời ứng dụng.
```dart
static final AuthService _instance = AuthService._internal();
factory AuthService() => _instance;
```

## 3. State Properties
- `bool _isLoggedIn`: Trạng thái đăng nhập hiện tại. Mặc định là `false`.
- `String? _pendingRoute`: Route mà người dùng muốn truy cập nhưng bị chặn do chưa login. Dùng để redirect sau khi login xong.
- `GoogleSignInAccount? _currentUser`: Thông tin tài khoản Google của người dùng hiện tại (nếu login bằng Google).
- `GoogleSignIn _googleSignIn`: Instance của plugin Google Sign-In.
- `bool _isGoogleInitialized`: Cờ đánh dấu đã khởi tạo Google Sign-In hay chưa.

## 4. Getters
- `bool get isLoggedIn`: Trả về trạng thái đăng nhập.
- `String? get pendingRoute`: Trả về route đang chờ (nếu có).
- `GoogleSignInAccount? get currentUser`: Trả về thông tin user.

## 5. Methods

### 5.1. `login` (Mock/Manual)
```dart
void login()
```
- **Chức năng:** Đánh dấu người dùng đã đăng nhập thủ công (thường dùng cho dev/test hoặc login thường không qua Google).
- **Hoạt động:** Set `_isLoggedIn = true` và gọi `notifyListeners()` để cập nhật UI.

### 5.2. `loginWithGoogle`
```dart
Future<bool> loginWithGoogle() async
```
- **Chức năng:** Thực hiện quy trình đăng nhập bằng Google OAuth2.
- **Quy trình:**
  1. **Khởi tạo:** Kiểm tra và khởi tạo `GoogleSignIn` với `serverClientId` từ file `.env` (chỉ làm 1 lần).
  2. **Authenticate:** Gọi `_googleSignIn.authenticate()` để mở popup đăng nhập Google của thiết bị.
  3. **Lấy Token:** Từ kết quả đăng nhập (`googleUser`), lấy `idToken` thông qua `googleUser.authentication`.
  4. **Verify với Backend:** Gửi `idToken` lên Backend API (`POST /login/google`) để xác thực và lấy session/token từ hệ thống riêng (nếu có).
  5. **Xử lý kết quả:**
     - Nếu Backend trả về 200 OK -> Đăng nhập thành công (`_isLoggedIn = true`), thông báo listener, trả về `true`.
     - Nếu lỗi -> In log lỗi, trả về `false`.

### 5.3. `logout`
```dart
void logout() async
```
- **Chức năng:** Đăng xuất người dùng.
- **Hoạt động:**
  1. Khởi tạo Google Sign-In nếu cần (để gọi hàm signOut).
  2. Gọi `_googleSignIn.signOut()` để đăng xuất khỏi tài khoản Google trên thiết bị.
  3. Reset state: `_isLoggedIn = false`, `_currentUser = null`, `_pendingRoute = null`.
  4. Gọi `notifyListeners()` để UI chuyển về trạng thái chưa đăng nhập.

### 5.4. `setPendingRoute`
```dart
void setPendingRoute(String? route)
```
- **Chức năng:** Lưu lại route đích mà người dùng muốn đến. Thường được gọi bởi `AuthGuard` trước khi đẩy người dùng về trang Login.

### 5.5. `clearPendingRoute`
```dart
void clearPendingRoute()
```
- **Chức năng:** Xóa route đang chờ sau khi đã điều hướng xong (hoặc khi hủy điều hướng).
