# ⚡ QUICK START: Export Game Ra Web

## 🚀 3 Bước Đơn Giản

### 1️⃣ Cài Export Template (Chỉ cần 1 lần)

```
Godot Editor → Editor → Manage Export Templates → Download and Install
```

### 2️⃣ Export Game

```
Godot Editor → Project → Export → Chọn "Web" → Export Project → Save vào web/index.html
```

### 3️⃣ Chạy

**Option A - Godot (Nhanh nhất):**
```
Trong Export dialog → Click "Run"
```

**Option B - Python:**
```bash
cd web
python -m http.server 8000
# Mở: http://localhost:8000
```

**Option C - Node.js:**
```bash
npm install -g http-server
cd web
http-server -p 8000
# Mở: http://localhost:8000
```

---

## 🌍 Deploy Online

### itch.io (Khuyến nghị - Miễn phí):

1. Tạo account: https://itch.io/register
2. Create New Project: https://itch.io/game/new
3. Upload folder `web/` (nén thành .zip)
4. Check "This file will be played in the browser"
5. Publish!

### GitHub Pages:

```bash
cd web
git init
git add .
git commit -m "Deploy"
git remote add origin https://github.com/username/repo.git
git push -u origin main
# Enable GitHub Pages in Settings
```

---

## ❓ Gặp Lỗi?

### "Cross-Origin Request Blocked"
→ Không thể mở file:// trực tiếp. Phải dùng web server!

### "Loading stuck"
→ File quá lớn. Optimize assets trong project.

### "WebGL not supported"
→ Update graphics drivers, thử browser khác.

---

## 📖 Chi Tiết

Xem file `EXPORT_TO_WEB.md` để biết:
- Optimization tips
- Troubleshooting đầy đủ
- Advanced configuration
- Deploy options chi tiết

---

**🎮 Done! Game giờ chạy trên web browser! 🌐**
