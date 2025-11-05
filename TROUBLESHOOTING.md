# 🔧 TROUBLESHOOTING - Xử Lý Lỗi Game

## ❌ Lỗi: Không thấy nhân vật, giao diện hay bất cứ thứ gì

### Triệu chứng:
- Mở game chỉ thấy màn hình đen hoặc xanh trời
- Không có nhân vật, đất, UI
- Không nhìn thấy bất cứ gì

### ✅ Giải pháp:

#### **Bước 1: Kiểm tra Scene đã mở đúng chưa**

1. Trong **Godot Editor**, xem tab **Scene** (bên trái)
2. Kiểm tra có thấy structure như sau không:

```
Main (Node3D)
├── WorldEnvironment
├── DirectionalLight3D
├── Ground (StaticBody3D)
│   ├── MeshInstance3D
│   └── CollisionShape3D
├── Player (CharacterBody3D)
│   ├── MeshInstance3D
│   ├── CollisionShape3D
│   ├── CameraPivot
│   │   └── Camera3D
│   └── RayCast3D
├── FarmPlots (Node3D)
│   ├── FarmPlot1...FarmPlot8
├── Buildings (Node3D)
├── Animals (Node3D)
├── NPCs (Node3D)
└── UI (Node)
    ├── HUD (CanvasLayer)
    └── ShopUI (CanvasLayer)
```

**Nếu KHÔNG thấy structure trên:**
- Scene chưa được load đúng
- Đóng project và import lại

#### **Bước 2: Reload scene file mới**

Game đã được update với scene file đầy đủ hơn. Làm theo các bước:

```bash
# 1. Đóng Godot Editor (nếu đang mở)

# 2. Xóa cache (Windows)
cd farnery
rmdir /s .godot

# 2b. Xóa cache (Linux/Mac)
rm -rf .godot/

# 3. Mở lại project trong Godot
# Godot sẽ tự động re-import tất cả
```

#### **Bước 3: Kiểm tra Console Output**

1. Trong Godot Editor, tìm tab **Output** (dưới cùng)
2. Chạy game (F5)
3. Xem có lỗi màu đỏ không?

**Các lỗi thường gặp:**

❌ **"Cannot find autoload GameManager"**
```
Fix: Project > Project Settings > Autoload
     Kiểm tra các autoload có đúng path:
     - GameManager: res://scripts/autoload/game_manager.gd
     - InventoryManager: res://scripts/autoload/inventory_manager.gd
     - WeatherSystem: res://scripts/autoload/weather_system.gd
     - CraftingSystem: res://scripts/autoload/crafting_system.gd
```

❌ **"Script parsing error"**
```
Fix: Project > Reload Current Project
     Hoặc đóng và mở lại Godot
```

❌ **"Scene file corrupted"**
```
Fix: Download lại code mới nhất từ Git
     git pull origin <branch-name>
```

#### **Bước 4: Kiểm tra Camera**

Có thể camera không hoạt động đúng:

1. Chọn node **Player** trong Scene tree
2. Tìm child node **CameraPivot > Camera3D**
3. Click chuột phải vào **Camera3D**
4. Chọn **"Preview"** để xem camera view
5. Điều chỉnh position nếu cần:
   - Position: (0, 8, 10)
   - Rotation: (-35, 0, 0)

**Hoặc trong game đang chạy:**
- Nhấn **F8** để stop
- Edit Camera3D position trong Inspector
- Chạy lại (F5)

#### **Bước 5: Kiểm tra 3D Viewport Settings**

1. Click vào **3D viewport** (màn hình giữa editor)
2. Góc trên trái viewport, tìm menu **Perspective**
3. Thử các view khác:
   - **Top View**: Nhìn từ trên xuống
   - **Front View**: Nhìn từ phía trước
   - **Right View**: Nhìn từ bên phải

4. Zoom out (cuộn chuột lùi) để xem có objects ở xa không

5. Check các icons góc trên viewport:
   - **Camera icon**: Bật để preview camera
   - **Sun icon**: Kiểm tra lighting

#### **Bước 6: Pull code mới nhất**

Scene file đã được fix. Pull code mới:

```bash
cd farnery
git pull origin claude/3d-farm-game-lowpoly-011CUpGeTpwwDjZa7jZrJqiv
```

Sau đó:
1. Đóng Godot
2. Xóa folder `.godot/`
3. Mở lại project

---

## ❌ Lỗi: Game chạy nhưng HUD không hiện

### Triệu chứng:
- Thấy nhân vật và đất
- KHÔNG thấy UI (tiền, ngày, mùa)

### ✅ Giải pháp:

1. **Kiểm tra CanvasLayer visible:**
   - Chọn node **UI > HUD** trong Scene tree
   - Trong Inspector, check **Visible** = ON

2. **Kiểm tra script attached:**
   - Chọn **HUD** node
   - Trong Inspector, check có script `hud.gd` attached không
   - Nếu không: Kéo file `scripts/ui/hud.gd` vào **Script** property

3. **Test UI trực tiếp:**
   ```gdscript
   # Trong script bất kỳ, thêm dòng:
   print("HUD exists: ", has_node("/root/Main/UI/HUD"))
   ```

4. **Manual fix:**
   - Xóa node **UI** trong scene
   - Click chuột phải vào **Main** > Add Child Node
   - Tìm **Node**, tạo node tên "UI"
   - Click phải **UI** > Add Child Node > **CanvasLayer** tên "HUD"
   - Attach script `hud.gd` vào HUD

---

## ❌ Lỗi: "Invalid get index 'current_season' (on base: 'null instance')"

### Triệu chứng:
- Console đầy lỗi về GameManager
- Game crash ngay khi start

### ✅ Giải pháp:

**Autoload chưa được setup đúng:**

1. Menu: **Project > Project Settings**
2. Tab: **Autoload**
3. Thêm các singletons (nếu chưa có):

| Name | Path | Enabled |
|------|------|---------|
| GameManager | res://scripts/autoload/game_manager.gd | ✅ |
| InventoryManager | res://scripts/autoload/inventory_manager.gd | ✅ |
| WeatherSystem | res://scripts/autoload/weather_system.gd | ✅ |
| CraftingSystem | res://scripts/autoload/crafting_system.gd | ✅ |

4. Click **Close**
5. **Project > Reload Current Project**

---

## ❌ Lỗi: Player không di chuyển được

### Triệu chứng:
- Nhấn WASD không có gì xảy ra
- Player đứng yên

### ✅ Giải pháp:

1. **Kiểm tra Input Map:**
   - Menu: **Project > Project Settings**
   - Tab: **Input Map**
   - Check có các actions sau không:
     - `move_forward` (W, Up)
     - `move_backward` (S, Down)
     - `move_left` (A, Left)
     - `move_right` (D, Right)
     - `interact` (E, Mouse Left)

2. **Kiểm tra Player có collision:**
   - Chọn **Player** node
   - Check có **CollisionShape3D** child không
   - Shape phải là **CapsuleShape3D**

3. **Kiểm tra Ground có collision:**
   - Chọn **Ground** node
   - Check có **CollisionShape3D**
   - Shape phải là **BoxShape3D** size (100, 1, 100)

4. **Check console lỗi:**
   - Có thể script player.gd có lỗi parsing
   - Output panel sẽ hiện lỗi đỏ

---

## ❌ Lỗi: Không tương tác được với ô đất, động vật

### Triệu chứng:
- Nhấn E không có gì xảy ra
- Không thể cày đất, cho động vật ăn

### ✅ Giải pháp:

1. **Check RayCast3D:**
   - Player phải có child **RayCast3D**
   - Target position: (0, -1, -3)
   - Collision mask: 29 (binary: 11101)

2. **Test trong game:**
   - Mở **Remote** tab (khi game đang chạy)
   - Chọn Player > RayCast3D
   - Check **"Is Colliding"** = true khi đứng gần object

3. **Kiểm tra collision layers:**
   - FarmPlots phải ở layer 3 (Crops)
   - Animals phải ở layer 4
   - Buildings phải ở layer 5

---

## ❌ Lỗi: Game lag / FPS thấp

### ✅ Giải pháp:

1. **Giảm quality settings:**
   ```
   Project > Project Settings > Rendering > Quality
   - MSAA: Disabled hoặc 2x
   - SSAO: Disabled
   - Screen Space Reflections: Off
   ```

2. **Tắt shadows:**
   - Chọn **DirectionalLight3D**
   - Inspector > Shadow > **Enabled** = OFF

3. **Giảm viewport size:**
   ```
   Project Settings > Display > Window
   - Width: 1280
   - Height: 720
   ```

---

## 🆘 Vẫn Không Fix Được?

### Cách debug cuối cùng:

1. **Tạo scene test đơn giản:**

```
File > New Scene
Add Node3D (root)
Add DirectionalLight3D
Add Camera3D (position: 0, 5, 10)
Add CSGBox3D (ground)
Run (F5)
```

Nếu thấy box → Godot hoạt động OK → Lỗi ở scene main.tscn

2. **Xóa và tạo lại scene:**

```bash
# Backup
mv scenes/main.tscn scenes/main.tscn.backup

# Pull fresh copy
git checkout scenes/main.tscn

# Reload trong Godot
```

3. **Reinstall Godot:**
   - Có thể Godot bị corrupt
   - Download lại từ godotengine.org
   - Giải nén vào folder mới
   - Mở project

4. **Check system requirements:**
   - OpenGL 3.3+ support
   - Updated graphics drivers
   - Enough RAM (2GB+)

---

## 📝 Ghi Log Debug

Nếu cần hỗ trợ, chạy game và copy log:

```bash
# Run từ terminal
cd godot_folder
./Godot_v4.2.x_win64.exe --path /path/to/farnery > game_log.txt 2>&1

# Log được save vào game_log.txt
# Gửi file này khi báo bug
```

---

## ✅ Checklist Tổng Hợp

Trước khi báo lỗi, hãy check:

- [ ] Godot version >= 4.2
- [ ] Đã xóa folder `.godot/` và reload
- [ ] Scene `main.tscn` có đầy đủ nodes
- [ ] Autoloads đã setup đúng
- [ ] Console Output không có lỗi đỏ
- [ ] Camera position đúng (0, 8, 10)
- [ ] Player có Mesh + Collision
- [ ] Ground có Mesh + Collision
- [ ] Input Map có đủ actions

Nếu tất cả đều ✅ mà vẫn lỗi → Có thể là bug nghiêm trọng, cần report!

---

**Happy Debugging! 🐛🔨**
