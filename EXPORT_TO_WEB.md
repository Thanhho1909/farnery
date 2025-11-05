# 🌐 HƯỚNG DẪN EXPORT GAME RA HTML5/WEB

## 📋 Tổng Quan

Godot Engine hỗ trợ export game ra HTML5/WebGL để chạy trực tiếp trên trình duyệt web! Bạn không cần cài đặt gì, chỉ cần mở link là chơi được.

**Ưu điểm:**
- ✅ Chạy trên mọi trình duyệt (Chrome, Firefox, Safari, Edge)
- ✅ Không cần cài đặt
- ✅ Chia sẻ dễ dàng qua link
- ✅ Giữ nguyên 3D graphics và gameplay
- ✅ Cross-platform (Windows, Mac, Linux, Mobile)

---

## 🔧 BƯỚC 1: Cài Đặt HTML5 Export Template

### Cách 1: Download từ Godot Editor (Khuyến nghị)

1. **Mở Godot Editor**
2. **Menu: Editor > Manage Export Templates**
3. Click **"Download and Install"**
4. Chọn version **4.2.x** (phải match với Godot version bạn đang dùng)
5. Đợi download xong (khoảng 50-100 MB)
6. Click **"Install from File"** nếu download thủ công

### Cách 2: Download thủ công

1. Truy cập: https://godotengine.org/download/
2. Tìm phần **"Export Templates"**
3. Download file `.tpz` tương ứng version Godot của bạn
4. Trong Godot: **Editor > Manage Export Templates > Install from File**
5. Chọn file `.tpz` vừa download

### Kiểm tra đã cài thành công:

```
Editor > Manage Export Templates
→ Phải thấy version 4.2.x với status "Installed"
```

---

## 📦 BƯỚC 2: Export Game

### A. Mở Export Menu

1. **Menu: Project > Export**
2. Cửa sổ **"Export"** sẽ hiện ra

### B. Add HTML5 Export Preset

Nếu chưa có preset "Web":

1. Click nút **"Add..."** (góc trên)
2. Chọn **"Web"** từ danh sách
3. Preset "Web" sẽ xuất hiện bên trái

Nếu đã có (do file `export_presets.cfg` trong project):
- Preset "Web" đã sẵn sàng!

### C. Configure Export Settings

Click vào preset **"Web"** để xem settings:

#### **Export Path:**
```
./web/index.html
```
Hoặc chọn folder khác bạn muốn

#### **Runnable:**
- ✅ Check **"Runnable"** để test ngay sau khi export

#### **Resources:**
- **Export Mode**: "Export all resources in the project"
- Hoặc "Export selected scenes" nếu chỉ muốn export một số scenes

#### **Options Tab:**

Các settings quan trọng:

| Setting | Value | Mô tả |
|---------|-------|-------|
| **HTML/Export Icon** | ✅ Enabled | Export icon.svg làm favicon |
| **HTML/Canvas Resize Policy** | `2` (Adaptive) | Tự động resize canvas |
| **HTML/Focus Canvas on Start** | ✅ Enabled | Auto focus để bắt input |
| **VRAM Texture Compression/Desktop** | ✅ Enabled | Nén texture cho web |

### D. Export Game!

1. Click nút **"Export Project"** (dưới cùng)
2. Chọn vị trí lưu: `web/index.html`
3. Click **"Save"**
4. Đợi export (10-30 giây)

**Kết quả:**

Folder `web/` sẽ có các files:

```
web/
├── index.html              ← File chính để mở
├── index.pck               ← Game assets
├── index.wasm              ← Game engine (WebAssembly)
├── index.js                ← Loader script
├── index.audio.worklet.js  ← Audio processor
└── index.icon.png          ← Favicon
```

---

## 🚀 BƯỚC 3: Chạy Game Trên Web

### ⚠️ QUAN TRỌNG: Không thể mở trực tiếp file HTML!

Vì lý do bảo mật của trình duyệt, bạn **KHÔNG THỂ** double-click `index.html` để chạy. Phải dùng local web server!

### Cách 1: Dùng Godot Built-in Server (Dễ nhất)

Sau khi export xong:

1. Trong Export dialog, click **"Run"** (hoặc nhấn **Ctrl+R**)
2. Godot sẽ tự động:
   - Start local web server
   - Mở browser với game
3. Địa chỉ thường là: `http://localhost:8060`

### Cách 2: Python HTTP Server

**Nếu có Python 3:**

```bash
# Di chuyển vào folder web
cd web

# Start server
python -m http.server 8000

# Hoặc Python 2
python -m SimpleHTTPServer 8000
```

Mở browser: `http://localhost:8000`

### Cách 3: Node.js http-server

**Nếu có Node.js:**

```bash
# Install http-server (chỉ cần 1 lần)
npm install -g http-server

# Di chuyển vào folder web
cd web

# Start server
http-server -p 8000
```

Mở browser: `http://localhost:8000`

### Cách 4: VS Code Live Server Extension

**Nếu dùng VS Code:**

1. Install extension **"Live Server"** by Ritwick Dey
2. Mở folder `web/` trong VS Code
3. Click chuột phải vào `index.html`
4. Chọn **"Open with Live Server"**
5. Browser tự động mở

### Cách 5: Dùng itch.io App

Upload lên itch.io và chạy local qua itch app (xem phần deploy bên dưới)

---

## 🎮 BƯỚC 4: Test Game

Khi game load thành công:

1. **Loading screen** sẽ hiện (5-30 giây)
2. Màn hình game hiện ra
3. Test các controls:
   - WASD: Di chuyển
   - E: Tương tác
   - B: Mở shop
   - I: Inventory

### Debug trong Browser

**Mở Developer Console:**
- Chrome/Edge: `F12` hoặc `Ctrl+Shift+I`
- Firefox: `F12`
- Safari: `Cmd+Option+I`

**Xem logs:**
- Tab **Console** sẽ hiện Godot print() messages
- Kiểm tra lỗi JavaScript/WebAssembly

**Common issues:**

❌ **"SharedArrayBuffer not available"**
```
Fix: Cần HTTPS hoặc set headers (xem troubleshooting)
```

❌ **"Loading stuck at 90%"**
```
Fix: File .pck quá lớn, cần optimize assets
```

❌ **"WebGL not supported"**
```
Fix: Update graphics drivers, thử browser khác
```

---

## 🌍 BƯỚC 5: Deploy Lên Internet

### Option 1: itch.io (Khuyến nghị - Miễn phí)

**itch.io** là platform tốt nhất cho indie games HTML5.

1. **Tạo tài khoản:** https://itch.io/register
2. **Create New Project:** https://itch.io/game/new
3. **Fill form:**
   - Title: Farm Life - Low Poly
   - Project URL: `your-name.itch.io/farm-life`
   - Classification: Games
   - Kind: HTML

4. **Upload files:**
   - Zip toàn bộ folder `web/`
   - Upload file `.zip`
   - Check **"This file will be played in the browser"**
   - Set `index.html` as main file

5. **Settings:**
   - Viewport dimensions: 1920 x 1080 (hoặc auto)
   - Mobile friendly: Tùy chọn
   - Fullscreen button: Yes

6. **Save & View Page**

**Ưu điểm itch.io:**
- ✅ Miễn phí unlimited hosting
- ✅ HTTPS included
- ✅ Analytics built-in
- ✅ Community & ratings
- ✅ Monetization options (pay what you want)

### Option 2: GitHub Pages (Miễn phí)

1. **Tạo repo:** `farm-life-game`
2. **Push folder web/ lên GitHub:**

```bash
cd web
git init
git add .
git commit -m "Deploy Farm Life HTML5"
git branch -M main
git remote add origin https://github.com/username/farm-life-game.git
git push -u origin main
```

3. **Enable GitHub Pages:**
   - Settings > Pages
   - Source: main branch
   - Folder: / (root)
   - Save

4. **Truy cập:** `https://username.github.io/farm-life-game/`

**Lưu ý:** GitHub Pages có giới hạn 1GB, game phải nhỏ gọn.

### Option 3: Netlify / Vercel (Miễn phí)

**Netlify:**

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy
cd web
netlify deploy --prod

# Follow prompts
```

**Vercel:**

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd web
vercel --prod
```

### Option 4: Self-hosting (Cần server)

Upload folder `web/` lên server của bạn qua FTP/SFTP.

**NGINX config:**

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    root /var/www/farm-life/web;
    index index.html;

    # Enable CORS
    add_header Access-Control-Allow-Origin *;
    add_header Cross-Origin-Opener-Policy same-origin;
    add_header Cross-Origin-Embedder-Policy require-corp;

    # Compression
    gzip on;
    gzip_types application/wasm application/javascript;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

## 🎨 BƯỚC 6: Customize HTML Page

File `web/index.html` đã có styling đẹp! Bạn có thể customize:

### Thay đổi màu sắc:

```css
/* Line 20-25 trong index.html */
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
/* Đổi thành màu bạn thích */
```

### Thêm logo:

```html
<!-- Trong <header> -->
<img src="logo.png" alt="Logo" style="max-width: 200px;">
```

### Thêm social links:

```html
<!-- Trong <footer> -->
<div class="social">
    <a href="https://twitter.com/...">🐦 Twitter</a>
    <a href="https://github.com/...">💻 GitHub</a>
</div>
```

### Analytics:

Thêm Google Analytics trong `<head>`:

```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

---

## ⚡ OPTIMIZATION TIPS

### Giảm kích thước game:

1. **Compress textures:**
   - Project Settings > Rendering > Textures
   - Enable VRAM compression

2. **Remove unused assets:**
   - Xóa files không dùng trong project
   - Export mode: "Export selected scenes"

3. **Audio compression:**
   - Convert audio sang .ogg
   - Bitrate: 96-128 kbps là đủ

4. **LOD (Level of Detail):**
   - Giảm polygon count cho 3D models xa

### Tăng tốc loading:

1. **Progressive Web App (PWA):**
   - Enable trong Export settings
   - Browser sẽ cache game

2. **Asset streaming:**
   - Split assets thành chunks nhỏ
   - Load on-demand

### Tối ưu performance:

1. **Target 60 FPS:**
   - Project Settings > Display > Window > Vsync: Enabled
   - Rendering > Quality > MSAA: 2x (không dùng 4x-8x)

2. **Mobile optimization:**
   - Disable shadows cho mobile
   - Lower resolution textures

---

## 🐛 TROUBLESHOOTING

### Lỗi "Cross-Origin Request Blocked"

**Nguyên nhân:** Mở file:// trực tiếp

**Fix:** Dùng web server (xem Bước 3)

### Lỗi "SharedArrayBuffer is not defined"

**Nguyên nhân:** Browser yêu cầu HTTPS + headers

**Fix Option 1 - Production:**
```
Deploy lên HTTPS server với headers:
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

**Fix Option 2 - Local dev:**
```
Dùng Godot's built-in server (nút Run trong Export dialog)
```

### Loading quá lâu (>1 phút)

**Check file size:**
```bash
ls -lh web/
# index.pck không nên >100 MB
```

**Fix:**
- Compress textures
- Remove unused assets
- Optimize 3D models

### Game lag trên web

**Check browser console:**
- Có warning về WebGL?
- GPU acceleration có bật?

**Fix:**
- Update graphics drivers
- Thử browser khác (Chrome thường tốt nhất)
- Lower graphics settings trong Godot project

### Không có âm thanh

**Check:**
- Browser có block autoplay audio?
- User phải tương tác (click) trước khi có audio

**Fix:**
- Show "Click to start" prompt
- Request audio permission sau user click

---

## 📊 File Size Benchmarks

Game Farm Life khoảng:
- **index.html**: ~10 KB
- **index.js**: ~500 KB
- **index.wasm**: ~30 MB
- **index.pck**: ~5-50 MB (tùy assets)
- **Total**: ~40-80 MB

**Acceptable sizes:**
- < 50 MB: Excellent (load nhanh)
- 50-100 MB: Good (chấp nhận được)
- > 100 MB: Cần optimize

---

## 🎯 CHECKLIST TRƯỚC KHI DEPLOY

- [ ] Test trên local server - game chạy OK
- [ ] Test controls - tất cả phím hoạt động
- [ ] Test trên nhiều browsers (Chrome, Firefox, Safari)
- [ ] Check mobile compatibility (nếu cần)
- [ ] Optimize file size < 100 MB
- [ ] Customize HTML page (title, description)
- [ ] Add analytics (optional)
- [ ] Test loading time (< 30 giây)
- [ ] Check console không có lỗi
- [ ] Fullscreen button hoạt động

---

## 📚 TÀI LIỆU THAM KHẢO

- **Godot HTML5 Export:** https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html
- **WebGL Browser Support:** https://caniuse.com/webgl
- **itch.io Guide:** https://itch.io/docs/creators/html5
- **GitHub Pages:** https://pages.github.com/

---

## 🎉 DONE!

Bây giờ game của bạn đã chạy trên web! Share link với bạn bè và enjoy! 🌾🚜🐔

**Cần hỗ trợ?** Check file `TROUBLESHOOTING.md` trong project!
