# AuthGuard Documentation

**File:** `lib/core/auth/auth_guard.dart`

`AuthGuard` là lớp tiện ích (utility class) chịu trách nhiệm quản lý việc điều hướng (navigation) dựa trên trạng thái xác thực của người dùng. Nó đảm bảo rằng người dùng không thể truy cập vào các màn hình được bảo vệ (protected screens) nếu chưa đăng nhập.

## 1. Import
```dart
import 'package:flutter/material.dart';
import '../config/protected_screens.dart'; // Danh sách các màn hình cần bảo vệ
import 'auth_service.dart'; // Dịch vụ xác thực
```

## 2. Properties
- `static final AuthService _authService = AuthService();`
  - Instance của `AuthService` để kiểm tra trạng thái đăng nhập (`isLoggedIn`).

## 3. Methods

### 3.1. `navigate`
```dart
static void navigate(BuildContext context, String routeName)
```
- **Chức năng:** Điều hướng người dùng đến một route cụ thể, có kiểm tra quyền truy cập.
- **Hoạt động:**
  1. Kiểm tra xem `routeName` có nằm trong danh sách `ProtectedScreens` hay không VÀ người dùng ĐÃ ĐĂNG NHẬP chưa (`!_authService.isLoggedIn`).
  2. **Nếu chưa đăng nhập & màn hình yêu cầu bảo vệ:**
     - Lưu `routeName` hiện tại vào `pendingRoute` trong `AuthService` (để redirect lại sau khi login thành công).
     - Chuyển hướng người dùng sang màn hình Login (`/login`) bằng `Navigator.pushReplacementNamed`.
  3. **Nếu đã đăng nhập hoặc màn hình không cần bảo vệ:**
     - Kiểm tra xem người dùng có đang ở chính màn hình đó không (để tránh push chồng lặp).
     - Nếu không phải màn hình hiện tại, thực hiện điều hướng đến `routeName` bằng `Navigator.pushReplacementNamed`.

### 3.2. `navigateAfterLogin`
```dart
static void navigateAfterLogin(BuildContext context)
```
- **Chức năng:** Được gọi sau khi đăng nhập thành công để điều hướng người dùng về màn hình họ mong muốn trước đó.
- **Hoạt động:**
  1. Lấy `pendingRoute` từ `AuthService`. Nếu không có, mặc định là `/home`.
  2. Xóa `pendingRoute` (reset về null).
  3. Điều hướng đến route vừa lấy được.

### 3.3. `navigateToTab`
```dart
static void navigateToTab(BuildContext context, int tabIndex)
```
- **Chức năng:** Điều hướng giữa các tab (Home, Search, Favorites, Profile) thông qua index.
- **Hoạt động:**
  1. Gọi `_getRouteForTab` để lấy tên route tương ứng với index.
  2. Gọi `navigate` để thực hiện điều hướng (đã bao gồm kiểm tra quyền).

### 3.4. `_getRouteForTab` (Private)
```dart
static String _getRouteForTab(int index)
```
- **Chức năng:** Helper function chuyển đổi tab index (int) sang route name (String).
- **Mapping:**
  - `0` -> `/home` (Trang chủ)
  - `1` -> `/search` (Tìm kiếm)
  - `2` -> `/favorites` (Yêu thích)
  - `3` -> `/profile` (Hồ sơ)
  - Mặc định -> `/home`
