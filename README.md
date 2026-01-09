## AnGi – Ứng dụng gợi ý món ăn

Ứng dụng gồm:
- **Frontend**: Flutter (`frontend/`)
- **Backend**: (đang phát triển) – cung cấp các API gợi ý món ăn, lưu món ưa thích, đăng nhập Google (`backend/`).

---

## Cấu trúc thư mục

- `frontend/`: Mã nguồn Flutter app AnGi.
- `backend/`: Mã nguồn backend (REST API, ví dụ: Node.js/Express, .NET, v.v.).

---

## Thiết kế API backend

### Chuẩn format response chung

Tất cả API backend nên (và thực tế backend hiện tại sẽ) trả về JSON theo cấu trúc chuẩn:

```json
{
  "success": true,
  "message": "Mô tả ngắn gọn kết quả",
  "data": [
    {
      "...": "payload thực tế (có thể là 1 hoặc nhiều object)"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100
  }
}
```

Trong đó:

- **`success`**: `true` nếu xử lý thành công, `false` nếu lỗi (thiết kế chi tiết phần lỗi có thể bổ sung sau).
- **`message`**: thông điệp ngắn gọn cho client (vd: `"Success"`, `"Tạo mới thành công"`...).
- **`data`**: **mảng** các bản ghi/payload (nếu chỉ 1 object thì vẫn được bọc thành mảng có 1 phần tử).
- **`pagination`** *(optional)*: chỉ xuất hiện với API có phân trang, chứa các thông tin: `page`, `limit`, `total`, …

Các ví dụ response chi tiết bên dưới có thể chỉ minh họa **phần payload bên trong `data`**, khi hiện thực thật nên bọc trong cấu trúc chuẩn ở trên.

Giả định tất cả API đều có prefix: `/api`.

### 1. Gợi ý nấu món gì từ nguyên liệu hiện có (1 API)

- **Endpoint**: `POST /api/suggestions/from-ingredients`
- **Mô tả**: Trả về danh sách món ăn có thể nấu từ các nguyên liệu người dùng đang có.
- **Request body (JSON)**:

```json
{
  "ingredients": ["trung", "ca rot", "hanh la"],
  "maxTimeMinutes": 30,
  "servings": 2
}
```

- **Response 200 (JSON)**:

```json
{
  "suggestions": [
    {
      "id": "dish_1",
      "name": "Trứng chiên cà rốt",
      "usedIngredients": ["trung", "ca rot"],
      "missingIngredients": ["nuoc mam"],
      "estimatedTimeMinutes": 20,
      "imageUrl": "https://example.com/dish_1.png"
    }
  ]
}
```

---

### 2. Lưu các món ăn ưng ý (2 API)

#### 2.1. Thêm món ăn vào danh sách ưa thích

- **Endpoint**: `POST /api/favorites`
- **Auth**: Yêu cầu token sau đăng nhập Google (ví dụ: Bearer token).
- **Request body (JSON)**:

```json
{
  "dishId": "dish_1",
  "name": "Trứng chiên cà rốt",
  "imageUrl": "https://example.com/dish_1.png",
  "note": "Ngon, dễ làm"
}
```

- **Response 201 (JSON)**:

```json
{
  "id": "fav_123",
  "dishId": "dish_1",
  "name": "Trứng chiên cà rốt",
  "imageUrl": "https://example.com/dish_1.png",
  "note": "Ngon, dễ làm",
  "createdAt": "2025-12-18T10:00:00Z"
}
```

#### 2.2. Lấy danh sách các món ưa thích của người dùng

- **Endpoint**: `GET /api/favorites`
- **Auth**: Bearer token.
- **Response 200 (JSON)**:

```json
{
  "items": [
    {
      "id": "fav_123",
      "dishId": "dish_1",
      "name": "Trứng chiên cà rốt",
      "imageUrl": "https://example.com/dish_1.png",
      "note": "Ngon, dễ làm",
      "createdAt": "2025-12-18T10:00:00Z"
    }
  ]
}
```

---

### 3. Random một món trong danh sách ưa thích (1 API)

- **Endpoint**: `GET /api/favorites/random`
- **Auth**: Bearer token.
- **Mô tả**: Random 1 món ăn trong danh sách ưa thích của user.
- **Response 200 (JSON)**:

```json
{
  "item": {
    "id": "fav_123",
    "dishId": "dish_1",
    "name": "Trứng chiên cà rốt",
    "imageUrl": "https://example.com/dish_1.png",
    "note": "Ngon, dễ làm",
    "createdAt": "2025-12-18T10:00:00Z"
  }
}
```

Nếu người dùng chưa có món ưa thích:

```json
{
  "item": null
}
```

---

### 4. Đăng nhập với Google (1 API)

Tuỳ cách triển khai backend, có thể dùng OAuth 2.0 / OpenID Connect. Dưới đây là thiết kế đơn giản cho mobile app.

- **Endpoint**: `POST /api/auth/google`
- **Mô tả**: Frontend gửi `idToken` lấy từ Google Sign-In, backend xác thực và trả về JWT của hệ thống.
- **Request body (JSON)**:

```json
{
  "idToken": "GOOGLE_ID_TOKEN"
}
```

- **Response 200 (JSON)**:

```json
{
  "accessToken": "JWT_TOKEN",
  "expiresIn": 3600,
  "user": {
    "id": "user_123",
    "email": "user@example.com",
    "name": "Nguyen Van A",
    "avatarUrl": "https://example.com/avatar.png"
  }
}
```

- **Headers sử dụng cho các API cần đăng nhập**:

```text
Authorization: Bearer JWT_TOKEN
```

---

## Gợi ý hiện thực backend

- **Công nghệ gợi ý**: có thể dùng rule-based (ghép nguyên liệu với công thức có sẵn) hoặc tích hợp AI.
- **Lưu dữ liệu**: dùng PostgreSQL/MySQL/MongoDB để lưu món ưa thích, thông tin user.
- **Bảo mật**:
  - Xác thực `idToken` với Google ở backend.
  - Ký JWT với secret/khóa riêng và kiểm tra ở các API `/favorites` và `/favorites/random`.


