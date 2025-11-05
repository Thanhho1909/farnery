# 🌐 Farm Life - Web Version

Đây là folder chứa game đã export ra HTML5/WebGL.

## 📦 Files

Sau khi export từ Godot, folder này sẽ chứa:

```
web/
├── index.html              ← Mở file này trong browser (qua web server)
├── index.pck               ← Game assets (textures, models, sounds)
├── index.wasm              ← Game engine (WebAssembly)
├── index.js                ← JavaScript loader
├── index.audio.worklet.js  ← Audio processor
└── index.icon.png          ← Game icon
```

## 🚀 Cách Chạy

### ⚠️ KHÔNG thể mở trực tiếp!

**KHÔNG** double-click vào `index.html` - sẽ không hoạt động!

Phải dùng web server:

### Option 1: Python

```bash
cd web
python -m http.server 8000
```

Mở: `http://localhost:8000`

### Option 2: Node.js

```bash
npm install -g http-server
cd web
http-server -p 8000
```

Mở: `http://localhost:8000`

### Option 3: Godot

1. Trong Godot Editor
2. Menu: Project > Export
3. Chọn preset "Web"
4. Click "Export Project"
5. Click "Run" để test ngay

## 📖 Hướng Dẫn Đầy Đủ

Xem file `EXPORT_TO_WEB.md` ở thư mục gốc project để biết:
- Cách export từ Godot
- Cách deploy lên internet
- Troubleshooting
- Optimization tips

## 🎮 Game Controls

- **WASD**: Di chuyển
- **E**: Tương tác
- **1/2/3**: Chọn công cụ
- **B**: Mở shop
- **I**: Inventory
- **F11**: Fullscreen

## 🌍 Deploy Online

Có thể deploy lên:
- itch.io (khuyến nghị)
- GitHub Pages
- Netlify
- Vercel
- Server riêng

Chi tiết trong `EXPORT_TO_WEB.md`

---

**🌾 Enjoy farming! 🐔**
