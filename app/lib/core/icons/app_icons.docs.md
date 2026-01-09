# AppIcons Documentation

**File:** `lib/core/icons/app_icons.dart`

`AppIcons` là một lớp tiện ích chứa các hằng số (constants) định nghĩa toàn bộ icon được sử dụng trong ứng dụng. Mục đích là để quản lý tập trung các icon, giúp dễ dàng thay đổi hoặc bảo trì (ví dụ: chuyển đổi bộ icon từ Material Icons sang HeroIcons hoặc SVG).

Hiện tại, ứng dụng đang sử dụng bộ icon **HeroIcons** (`package:heroicons`).

## 1. Import
```dart
import 'package:heroicons/heroicons.dart';
```

## 2. Constants (Icons)

Dưới đây là danh sách các icon được định nghĩa và ý nghĩa sử dụng:

| Tên biến | Icon (HeroIcons) | Mô tả / Vị trí sử dụng |
| :--- | :--- | :--- |
| `home` | `HeroIcons.home` | Tab Trang chủ trên thanh điều hướng. |
| `user` | `HeroIcons.user` | Tab Hồ sơ cá nhân. |
| `logout` | `HeroIcons.arrowRightOnRectangle` | Nút đăng xuất. |
| `heart` | `HeroIcons.heart` | Biểu tượng yêu thích (tim). |
| `random` | `HeroIcons.sparkles` | Tính năng gợi ý món ăn ngẫu nhiên. |
| `restaurant` | `HeroIcons.buildingStorefront` | Biểu tượng quán ăn/nhà hàng. |
| `dining` | `HeroIcons.cake` | Biểu tượng món ăn/ẩm thực (cũng dùng làm logo tạm). |
| `category` | `HeroIcons.squares2x2` | Danh mục món ăn. |
| `receipt` | `HeroIcons.documentText` | Hóa đơn hoặc chi tiết đơn hàng (nếu có). |
| `email` | `HeroIcons.envelope` | Biểu tượng email trong hồ sơ. |
| `phone` | `HeroIcons.phone` | Biểu tượng số điện thoại. |
| `location` | `HeroIcons.mapPin` | Biểu tượng địa chỉ/vị trí. |
| `calendar` | `HeroIcons.calendar` | Lịch sử hoặc ngày tháng. |
| `lock` | `HeroIcons.lockClosed` | Bảo mật/Mật khẩu. |
| `visibility` | `HeroIcons.eye` | Hiển thị mật khẩu. |
| `visibilityOff` | `HeroIcons.eyeSlash` | Ẩn mật khẩu. |
| `chevronRight` | `HeroIcons.chevronRight` | Mũi tên điều hướng sang phải (trong danh sách). |
| `appLogo` | `HeroIcons.cake` | Logo của ứng dụng (dùng chung với dining). |
| `search` | `HeroIcons.magnifyingGlass` | Tab Tìm kiếm & Thanh tìm kiếm. |

## 3. Cách sử dụng
Thay vì gọi trực tiếp `HeroIcon(HeroIcons.home)`, hãy sử dụng:
```dart
import '../core/icons/app_icons.dart';

// ...
HeroIcon(AppIcons.home)
```
Điều này giúp code sạch hơn và nhất quán trên toàn bộ ứng dụng.
