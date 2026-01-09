# MainLayout Documentation

**File:** `lib/core/layouts/main_layout.dart`

`MainLayout` là widget khung sườn (scaffold wrapper) chính của ứng dụng. Nó cung cấp cấu trúc layout nhất quán cho các màn hình chính, bao gồm `AppBar` (thanh tiêu đề) và `BottomNavigationBar` (thanh điều hướng dưới).

## 1. Parameters
```dart
const MainLayout({
  super.key, 
  required this.title,    // Tiêu đề hiển thị trên AppBar
  required this.body,     // Nội dung chính của màn hình (Widget con)
  this.showAppBar = true, // Tùy chọn hiển thị/ẩn AppBar (Mặc định: true)
});
```

## 2. Components & Logic

### 2.1. AppBar
- **Hiển thị:** Được render nếu `showAppBar == true`.
- **Title:** Hiển thị `title` được truyền vào.
- **Actions (Avatar):**
  - Hiển thị avatar người dùng ở góc phải.
  - Sử dụng `AuthService` để lấy thông tin `currentUser`.
  - Nếu user đã login + có ảnh: Hiển thị ảnh từ `photoUrl`.
  - Nếu chưa login hoặc không có ảnh: Hiển thị icon mặc định `Icons.person`.
  - **Sự kiện onTap:** Chuyển hướng đến màn hình Profile (`'/profile'`).

### 2.2. Body
- Được bọc trong `SafeArea` để đảm bảo nội dung không bị che khuất bởi tai thỏ (notch) hoặc thanh trạng thái hệ thống.

### 2.3. BottomNavigationBar
Thanh điều hướng dưới cùng, cho phép chuyển đổi giữa các màn hình chính.

- **Dữ liệu tabs:** Lấy từ `BottomNavConfig.tabs` (gồm Home, Search, Favorites, Profile).
- **Active State (`currentIndex`):** Xác định tab đang active dựa trên route hiện tại (`ModalRoute`).
  - Sử dụng `BottomNavConfig.getTabIndex(currentRoute)` để map từ route name sang index.
  - Nếu không tìm thấy, mặc định về index 0 (Home).

- **Navigation Logic (`onTap`):**
  1. Kiểm tra nếu user tap vào tab đang active -> Không làm gì (return).
  2. Lấy route đích từ `BottomNavConfig.getRoute(index)`.
  3. **Kiểm tra quyền truy cập:**
     - Sử dụng `BottomNavConfig.requiresLogin(index)` để xem tab có yêu cầu login không.
     - Kiểm tra `AuthService.isLoggedIn`.
     - **Nếu chưa login & tab yêu cầu login:**
       - Lưu route đích vào `setPendingRoute`.
       - Chuyển hướng sang màn hình Login (`'/login'`).
  4. **Điều hướng bình thường:**
     - Nếu đã login hoặc tab public: Sử dụng `Navigator.pushReplacementNamed` để chuyển tab.

- **Custom Styling (Nút Search):**
  - Tab "Tìm món" (index 1) có thiết kế đặc biệt khi active:
    - Hình tròn màu cam nổi bật (`Color(0xFFFF6B35)`).
    - Có bóng đổ (`BoxShadow`).
    - Icon màu trắng.
  - Các tab còn lại sử dụng style mặc định (Icon đen khi active, xám khi inactive).
