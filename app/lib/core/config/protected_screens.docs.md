# ProtectedScreens Documentation

**File:** `lib/core/config/protected_screens.dart`

`ProtectedScreens` là một lớp cấu hình tĩnh (static configuration class) dùng để định nghĩa danh sách các route (màn hình) yêu cầu người dùng phải đăng nhập mới được truy cập.

## 1. Properties

### `protectedRoutes`
```dart
static const Set<String> protectedRoutes = { ... };
```
- **Kiểu dữ liệu:** `Set<String>` (Tập hợp các chuỗi duy nhất).
- **Chức năng:** Chứa danh sách các đường dẫn (route names) được bảo vệ.
- **Danh sách hiện tại:**
  - `'/profile'`: Màn hình hồ sơ cá nhân.
  - `'/favorites'`: Màn hình danh sách yêu thích.

## 2. Methods

### `isProtected`
```dart
static bool isProtected(String routeName)
```
- **Chức năng:** Kiểm tra xem một `routeName` có nằm trong danh sách được bảo vệ hay không.
- **Tham số:**
  - `routeName`: Tên route cần kiểm tra (Ví dụ: `'/home'`, `'/profile'`).
- **Trả về:**
  - `true`: Nếu route nằm trong `protectedRoutes`.
  - `false`: Nếu route không nằm trong danh sách này.
- **Sử dụng:** Thường được gọi bởi `AuthGuard` hoặc `BottomNavConfig` để quyết định xem có cần chuyển hướng người dùng sang trang Login hay không.
