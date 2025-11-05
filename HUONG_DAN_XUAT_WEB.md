# 🌐 HƯỚNG DẪN XUẤT GAME RA WEB

## 📋 Yêu Cầu

- ✅ Godot Engine 4.2+ đã cài đặt
- ✅ Web Export Template đã tải về

---

## 🚀 CÁCH 1: Export Trong Godot Editor (Khuyên Dùng)

### Bước 1: Cài Web Export Template

1. Mở **Godot 4.2+**
2. Vào menu `Editor > Manage Export Templates`
3. Chọn `Download and Install` cho phiên bản hiện tại
4. Đợi tải xuống hoàn tất

### Bước 2: Export Game

1. Mở project **Farm Life** trong Godot
2. Vào menu `Project > Export...`
3. Chọn preset **"Web"** (đã cấu hình sẵn)
4. Click nút **"Export Project"**
5. Chọn thư mục output (mặc định: `web/`)
6. Đợi export hoàn tất (1-2 phút)

### Bước 3: Chạy Game

#### Cách A: Sử dụng Web Server Đơn Giản

```bash
# Nếu có Python 3
cd web
python -m http.server 8000

# Hoặc nếu có Python 2
python -m SimpleHTTPServer 8000

# Hoặc nếu có Node.js
npx http-server -p 8000
```

Mở trình duyệt: `http://localhost:8000`

#### Cách B: Dùng Live Server (VS Code)

1. Cài extension "Live Server" trong VS Code
2. Click phải vào `web/index.html`
3. Chọn "Open with Live Server"

---

## ⚡ CÁCH 2: Export Bằng Command Line (Nhanh)

### Yêu Cầu: Godot phải được thêm vào PATH

```bash
# Windows
godot --headless --export-release "Web" ./web/index.html

# Linux/Mac
godot --headless --export-release "Web" ./web/index.html
```

---

## 🎯 CÁCH 3: Tự Động Hóa Với Script

Đã tạo sẵn script `export_web.sh`:

```bash
chmod +x export_web.sh
./export_web.sh
```

Script sẽ:
1. ✅ Kiểm tra Godot đã cài
2. ✅ Export game ra web/
3. ✅ Tự động mở trình duyệt

---

## 📁 Cấu Trúc Sau Khi Export

```
web/
├── index.html          # Game wrapper (đã tạo sẵn)
├── index.pck           # Game data (Godot tạo)
├── index.wasm          # WebAssembly (Godot tạo)
├── index.js            # Game engine (Godot tạo)
└── index.icon.png      # Icon (tự động)
```

---

## 🌟 Tính Năng Web Build

- ✅ **Chạy trực tiếp** trong trình duyệt
- ✅ **Không cần cài đặt**
- ✅ **Hỗ trợ đầy đủ** game features
- ✅ **Responsive design** - tự động resize
- ✅ **Loading screen** đẹp mắt
- ✅ **Hướng dẫn điều khiển** hiển thị sẵn
- ✅ **Tương thích** Chrome, Firefox, Edge, Safari

---

## 🎮 Điều Khiển Trong Web

### Di Chuyển
- **WASD** hoặc **Phím mũi tên**

### Tương Tác
- **E** hoặc **Click chuột**

### Menu
- **I** hoặc **Tab** - Mở inventory
- **B** - Mở shop
- **C** - Mở build menu
- **F5** - Quick Save
- **F9** - Quick Load
- **ESC** - Pause/Settings

---

## 🔧 Troubleshooting

### Lỗi: "Exporting for Web: Could not find export template"

**Giải pháp:**
```bash
# Tải export template thủ công
# Vào https://godotengine.org/download
# Tải "Export templates" cho Godot 4.2.x
# Giải nén vào: ~/.local/share/godot/export_templates/4.2.x.stable/
```

### Lỗi: Game không load trên web

**Nguyên nhân:** Không dùng web server (mở trực tiếp file://)

**Giải pháp:** Phải chạy qua web server (http://localhost)

### Lỗi: "SharedArrayBuffer is not defined"

**Giải pháp:**
Cần headers đặc biệt. Thêm vào web server hoặc dùng:
```bash
npx http-server -p 8000 --cors
```

### Game chạy chậm

**Giải pháp:**
1. Vào Settings trong game
2. Giảm Graphics Quality xuống "Low" hoặc "Medium"
3. Tắt VSync nếu cần

---

## 🌐 Deploy Lên Internet

### GitHub Pages (Miễn Phí)

1. Tạo repo GitHub
2. Push thư mục `web/` lên
3. Vào Settings > Pages
4. Chọn branch và folder `/web`
5. Game sẽ live tại: `https://username.github.io/repo-name`

### Netlify (Miễn Phí)

1. Kéo thả folder `web/` vào netlify.com
2. Hoặc connect GitHub repo
3. Auto deploy khi có update

### Vercel (Miễn Phí)

```bash
cd web
vercel deploy
```

---

## 📊 Optimization Cho Web

Game đã được tối ưu với:

- ✅ Auto performance scaling
- ✅ Low-poly graphics
- ✅ Efficient particle system
- ✅ Audio pooling
- ✅ Small file size (~50MB)

### Tips Để Game Chạy Mượt:

1. **Giảm độ phân giải** canvas nếu cần
2. **Tắt shadows** trong settings
3. **Giảm MSAA** trong graphics options
4. **Sử dụng Chrome** để hiệu suất tốt nhất

---

## 💡 Lưu Ý Quan Trọng

### ✅ Được Hỗ Trợ:
- Save/Load (vào LocalStorage)
- Toàn bộ gameplay
- Audio và music
- Particle effects
- Settings persistence

### ⚠️ Hạn Chế:
- Không hỗ trợ mod/custom assets
- Performance phụ thuộc trình duyệt
- Save data chỉ local (xóa cache = mất save)

---

## 🎉 Hoàn Tất!

Sau khi export xong, bạn có thể:

1. ✅ Chơi game trên localhost
2. ✅ Share link cho bạn bè
3. ✅ Deploy lên hosting
4. ✅ Embed vào website

**Game đã sẵn sàng để chơi trên web!** 🚀

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Check console (F12) trong browser
2. Đọc phần Troubleshooting ở trên
3. Kiểm tra Godot export logs

Happy farming! 🌾🐄🐔
