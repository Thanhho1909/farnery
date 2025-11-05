# 🎮 HƯỚNG DẪN CÀI ĐẶT VÀ CHƠI GAME

## 📥 PHẦN 1: CÀI ĐẶT GODOT ENGINE

### 🪟 Cho Windows:

1. **Download Godot**:
   - Truy cập: https://godotengine.org/download/windows/
   - Click nút **"Download Godot 4.2.x Standard"** (khoảng 50-70 MB)
   - Hoặc link trực tiếp: https://github.com/godotengine/godot/releases

2. **Giải nén**:
   - File tải về là `.zip`
   - Click chuột phải > **Extract All** hoặc dùng WinRAR/7-Zip
   - Giải nén vào thư mục bất kỳ (VD: `C:\Godot\`)

3. **Chạy Godot**:
   - Vào thư mục vừa giải nén
   - Double-click file `Godot_v4.2.x_win64.exe`
   - Godot Project Manager sẽ mở ra

### 🐧 Cho Linux:

```bash
# Download
wget https://github.com/godotengine/godot/releases/download/4.2.2-stable/Godot_v4.2.2-stable_linux.x86_64.zip

# Giải nén
unzip Godot_v4.2.2-stable_linux.x86_64.zip

# Phân quyền
chmod +x Godot_v4.2.2-stable_linux.x86_64

# Chạy
./Godot_v4.2.2-stable_linux.x86_64
```

### 🍎 Cho macOS:

1. Download từ: https://godotengine.org/download/macos/
2. Chọn **macOS Universal**
3. Mở file `.dmg` và kéo Godot vào Applications
4. Mở Godot từ Launchpad

---

## 📂 PHẦN 2: MỞ PROJECT GAME

### Cách 1: Import từ Godot Project Manager

1. **Mở Godot** (file .exe hoặc app)
2. Cửa sổ **Project Manager** sẽ hiện ra
3. Click nút **"Import"** (góc phải)
4. Duyệt đến thư mục `farnery/`
5. Chọn file **`project.godot`**
6. Click **"Import & Edit"**
7. Project sẽ mở trong Godot Editor

### Cách 2: Mở trực tiếp từ Command Line

```bash
# Di chuyển vào thư mục game
cd farnery

# Chạy Godot với project (thay đường dẫn Godot của bạn)
# Windows:
"C:\Godot\Godot_v4.2.x_win64.exe" project.godot

# Linux/macOS:
./Godot_v4.2.x_linux.x86_64 project.godot
```

### Cách 3: Kéo thả (Drag & Drop)

1. Mở **File Explorer** (Windows) hoặc **Finder** (macOS)
2. Tìm file `project.godot` trong thư mục `farnery/`
3. **Kéo thả** file này vào cửa sổ Godot Project Manager
4. Click **"Import & Edit"**

---

## ▶️ PHẦN 3: CHẠY GAME

### Lần đầu mở project:

1. Godot Editor sẽ mở và **import các resources** (mất 10-30 giây)
2. Bạn sẽ thấy:
   - **Scene dock** (trái): Cây scene hierarchy
   - **FileSystem** (dưới trái): Files và folders
   - **Inspector** (phải): Properties
   - **3D viewport** (giữa): Preview scene

### Chạy game:

**Cách 1: Nhấn phím tắt**
- Nhấn **F5** để chạy game
- Hoặc **F6** để chạy scene hiện tại

**Cách 2: Click nút Play**
- Tìm nút **▶️ Play** (góc trên phải)
- Click để chạy game

**Lần đầu tiên:**
- Godot sẽ hỏi chọn **Main Scene**
- Chọn `scenes/main.tscn`
- Click **"Select"**

### Nếu gặp lỗi:

**Lỗi "Main scene not found":**
```
1. Menu: Project > Project Settings
2. Tab Application > Run
3. Tại "Main Scene": Click icon folder
4. Chọn: res://scenes/main.tscn
5. Click OK
```

**Lỗi "Script parsing error":**
```
1. Menu: Project > Reload Current Project
2. Hoặc đóng Godot và mở lại
```

**Lỗi "Invalid scene":**
```
1. Check version Godot >= 4.2
2. Menu: Project > Tools > Orphan Resource Explorer
3. Clear orphans
```

---

## 🎮 PHẦN 4: ĐIỀU KHIỂN GAME

### Phím di chuyển:
- **W** / **↑**: Tiến lên
- **S** / **↓**: Lùi lại
- **A** / **←**: Sang trái
- **D** / **→**: Sang phải

### Phím tương tác:
- **E**: Tương tác với đối tượng gần nhất
- **Click chuột trái**: Tương tác (thay thế E)

### Phím menu:
- **I** / **Tab**: Mở/đóng kho đồ (Inventory)
- **B**: Mở/đóng cửa hàng (Shop)
- **C**: Mở menu xây dựng (Build)

### Phím chọn công cụ:
- **1**: Cuốc (Hoe) - Cày đất
- **2**: Bình tưới (Watering Can) - Tưới nước
- **3**: Rìu (Axe) - Chặt cây (future)

### Debug/System:
- **Esc**: Tạm dừng / Menu
- **F11**: Fullscreen
- **F8**: Stop game khi đang test

---

## 🌾 PHẦN 5: GAMEPLAY CƠ BẢN

### 🌱 Trồng trọt:

1. **Cày đất**:
   - Nhấn phím **1** để chọn cuốc
   - Đến gần ô đất màu nâu tối
   - Nhấn **E** để cày đất
   - Đất sẽ chuyển sang màu nâu sáng

2. **Gieo hạt**:
   - Đến gần đất đã cày
   - Nhấn **E**
   - Nếu có hạt giống trong kho, cây sẽ được trồng

3. **Tưới nước**:
   - Nhấn phím **2** để chọn bình tưới
   - Nhấn **E** vào cây đã trồng
   - Tưới **mỗi ngày** để cây lớn

4. **Thu hoạch**:
   - Khi cây chín (màu vàng sáng)
   - Nhấn **E** để thu hoạch
   - Nhận 1-3 sản phẩm

### 🐔 Chăn nuôi:

1. **Cho ăn**:
   - Mua "Thức ăn chăn nuôi" từ shop (phím B)
   - Đến gần động vật
   - Nhấn **E** > Chọn "Cho ăn"

2. **Vệ sinh**:
   - Đến gần động vật
   - Nhấn **E** > Chọn "Vệ sinh"
   - Làm sạch chuồng để động vật vui vẻ

3. **Thu sản phẩm**:
   - Khi tên động vật màu vàng = có sản phẩm
   - Nhấn **E** để thu:
     - Gà → Trứng
     - Bò → Sữa
     - Cừu → Len
     - Ong → Mật ong

### 💰 Buôn bán:

1. **Mở shop**: Nhấn **B**
2. **Mua hàng**:
   - Chọn vật phẩm
   - Click "Mua x1", "x5", hoặc "x10"
3. **Bán hàng**:
   - Nếu có vật phẩm trong kho
   - Click nút "Bán"
4. **Giá thay đổi theo mùa!**

### 🔨 Chế biến:

1. **Tại Cối xay** (Mill):
   - Đến gần tòa nhà màu be
   - Nhấn **E**
   - Lúa mì → Bột mì

2. **Tại Xưởng** (Workshop):
   - Đến gần tòa nhà màu xám
   - Nhấn **E**
   - Chế tạo: Bánh mì, Phô mai, v.v.

---

## 🎨 PHẦN 6: EDIT GAME (DÀNH CHO DEVELOPERS)

### Mở các file code:

1. Trong Godot, mở tab **FileSystem** (dưới trái)
2. Duyệt đến `scripts/` folder
3. Double-click file `.gd` để mở editor

### Các hệ thống chính:

```
scripts/
├── autoload/               # Singleton managers
│   ├── game_manager.gd     # Tiền, ngày, mùa
│   ├── inventory_manager.gd # Kho đồ
│   ├── weather_system.gd   # Thời tiết
│   └── crafting_system.gd  # Chế tạo
│
├── farming/                # Trồng trọt
│   ├── crop_data.gd        # Data cây trồng
│   └── farm_plot.gd        # Ô đất farming
│
├── animal/                 # Chăn nuôi
│   └── animal.gd           # Logic động vật
│
├── building/               # Xây dựng
│   └── building.gd         # Logic công trình
│
├── player/                 # Người chơi
│   └── player.gd           # Điều khiển
│
└── ui/                     # Giao diện
    ├── hud.gd              # Hiển thị info
    └── shop_ui.gd          # Cửa hàng
```

### Chỉnh sửa và test nhanh:

1. **Sửa code**: Edit file `.gd`
2. **Save**: Ctrl+S
3. **Test ngay**: F5 (không cần restart Godot!)
4. **Debug**: Menu > Debug > Deploy with Remote Debug

### Thêm cây trồng mới:

Mở `scripts/farming/farm_plot.gd`, tìm hàm `_initialize_crop_database()`:

```gdscript
# Thêm cây mới
var strawberry = CropData.new()
strawberry.crop_id = "strawberry"
strawberry.crop_name = "Dâu tây"
strawberry.seed_id = "seed_strawberry"
strawberry.harvest_id = "strawberry"
strawberry.growth_stages = 4
strawberry.hours_per_stage = 16.0
strawberry.valid_seasons = ["spring"]
CROPS["strawberry"] = strawberry
```

Sau đó thêm vào `inventory_manager.gd`:

```gdscript
"seed_strawberry": {"name": "Hạt dâu", "type": "seed", ...},
"strawberry": {"name": "Dâu tây", "type": "crop", ...},
```

---

## ❓ TROUBLESHOOTING

### Game không chạy được:

**Kiểm tra:**
1. Godot version >= 4.2? (Menu: Help > About)
2. File `project.godot` có tồn tại?
3. Folder `scripts/` và `scenes/` có đầy đủ?

**Fix:**
```bash
# Re-import project
rm -rf .godot/    # Xóa cache
# Mở lại trong Godot
```

### Lỗi "Cannot find autoload":

1. Menu: **Project > Project Settings**
2. Tab **Autoload**
3. Check các autoload có đúng path:
   - GameManager → `res://scripts/autoload/game_manager.gd`
   - InventoryManager → `res://scripts/autoload/inventory_manager.gd`
   - WeatherSystem → `res://scripts/autoload/weather_system.gd`
   - CraftingSystem → `res://scripts/autoload/crafting_system.gd`

### Game chạy nhưng không có gì hiện:

1. Check **Output** panel (dưới cùng Godot)
2. Xem có lỗi đỏ không?
3. Thử: **Scene > Reload Saved Scene**

### Không thấy HUD/UI:

1. Vào scene `main.tscn`
2. Check node `UI/HUD` có active?
3. Check script `hud.gd` có attach đúng?

---

## 📚 TÀI LIỆU THAM KHẢO

- **Godot Docs**: https://docs.godotengine.org/en/stable/
- **GDScript Guide**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/
- **Godot Community**: https://godotengine.org/community

---

## 🎉 CHÚC BẠN CHƠI GAME VUI VẺ!

Nếu gặp vấn đề, hãy:
1. Check file `README.md`
2. Xem Output console trong Godot
3. Tạo issue trên GitHub (nếu có)

**Happy Farming! 🌾🐔🏡**
