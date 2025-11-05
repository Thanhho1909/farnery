# 🚀 EXPORT WEB - HƯỚNG DẪN NHANH

## ⚡ Cách Nhanh Nhất (3 Bước)

### 1️⃣ Mở Godot

```bash
# Mở project trong Godot 4.2+
godot project.godot
```

### 2️⃣ Export Game

Trong Godot Editor:
- `Project` > `Export...`
- Chọn preset **"Web"**
- Click **"Export Project"**
- ✅ Done!

### 3️⃣ Chạy Game

```bash
cd web
python3 -m http.server 8000
```

Mở trình duyệt: **http://localhost:8000**

---

## 🤖 Tự Động Với Script

```bash
./export_web.sh
```

Script sẽ:
- ✅ Tự động export
- ✅ Tự động backup build cũ
- ✅ Tự động mở web server
- ✅ Hiển thị URL game

---

## 📦 Yêu Cầu

### Lần Đầu Tiên:

1. **Cài Godot 4.2+**
   - Download: https://godotengine.org/download

2. **Cài Export Templates**
   - Mở Godot
   - `Editor` > `Manage Export Templates`
   - Click `Download and Install`

### Sau Đó:

Chỉ cần chạy script hoặc export trong editor!

---

## 🎮 Chơi Game

Sau khi export, game sẽ ở folder `web/`:

```
web/
├── index.html    ← Mở file này (qua web server)
├── index.pck     ← Game data
├── index.wasm    ← Game engine
└── index.js      ← Game loader
```

**⚠️ LƯU Ý:** Phải chạy qua web server, không mở trực tiếp `index.html`!

---

## 🌐 Web Servers Đơn Giản

### Python (Có sẵn trên macOS/Linux):
```bash
cd web
python3 -m http.server 8000
```

### Node.js:
```bash
cd web
npx http-server -p 8000
```

### VS Code:
1. Cài extension "Live Server"
2. Right-click `web/index.html`
3. "Open with Live Server"

---

## 🐛 Troubleshooting

### "Could not find export template"
→ Cài export templates trong Godot Editor

### Game không load
→ Phải chạy qua web server (http://localhost)

### Chạy chậm
→ Giảm Graphics Quality trong Settings

---

## 📤 Deploy Online

### GitHub Pages:
```bash
git add web/
git commit -m "Add web build"
git push
# Enable GitHub Pages trong repo settings
```

### Netlify:
- Kéo thả folder `web/` vào netlify.com

---

## 💡 Tips

- **File size**: ~50MB (tối ưu sẵn)
- **Tương thích**: Chrome, Firefox, Edge, Safari
- **Performance**: Tốt nhất trên Chrome
- **Saves**: Lưu trong LocalStorage browser

---

Đọc hướng dẫn đầy đủ: **HUONG_DAN_XUAT_WEB.md**

Happy farming! 🌾
