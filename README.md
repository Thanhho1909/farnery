# 🌾 Farm Life - Low Poly

> Game nông trại 3D low-poly dễ thương, vui nhộn, thư giãn và đầy màu sắc!

![Godot Engine](https://img.shields.io/badge/Godot-4.2-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-Production%20Ready-brightgreen.svg)

## 🚀 Chơi Ngay Trên Web!

**Game đã sẵn sàng export ra web để chơi trực tiếp trên trình duyệt!**

### Export Nhanh (3 bước):
1. Mở project trong Godot 4.2+
2. `Project` > `Export...` > Chọn "Web" > `Export Project`
3. Chạy: `cd web && python3 -m http.server 8000`

📖 **Hướng dẫn chi tiết**: [HUONG_DAN_XUAT_WEB.md](HUONG_DAN_XUAT_WEB.md)
⚡ **Hướng dẫn nhanh**: [WEB_EXPORT_QUICK.md](WEB_EXPORT_QUICK.md)
🤖 **Auto script**: `./export_web.sh`

---

## 📖 Mô Tả

**Farm Life** là một game nông trại 3D với phong cách low-poly dễ thương. Người chơi sẽ trải nghiệm cuộc sống nông dân thư giãn với các hoạt động:

- 🌱 **Trồng trọt**: Gieo hạt, tưới nước, chăm sóc và thu hoạch nhiều loại cây trồng
- 🐔 **Chăn nuôi**: Nuôi gà, bò, cừu, ong - cho ăn, vệ sinh và thu thập sản phẩm
- 🏗️ **Xây dựng**: Xây và nâng cấp các công trình (nhà kho, chuồng trại, cối xay, xưởng chế biến)
- 💰 **Buôn bán**: Bán sản phẩm kiếm tiền, mua hạt giống và công cụ
- 🍂 **Hệ thống mùa**: 4 mùa với thời tiết khác nhau ảnh hưởng đến gameplay
- 👥 **NPC thân thiện**: Tương tác với dân làng và người bán hàng

## 🎮 Cách Chơi

### Điều Khiển

- **WASD** / **Phím mũi tên**: Di chuyển nhân vật
- **E** / **Click chuột**: Tương tác với đối tượng
- **I** / **Tab**: Mở/đóng kho đồ
- **B**: Mở/đóng cửa hàng
- **C**: Mở menu xây dựng
- **1-5**: Chọn công cụ (Cuốc, Bình tưới, Rìu, v.v.)

### Trồng Trọt

1. **Cày đất**: Dùng cuốc (1) để cày ô đất trống
2. **Gieo hạt**: Tương tác với đất đã cày và chọn hạt giống
3. **Tưới nước**: Dùng bình tưới (2) để tưới nước mỗi ngày
4. **Thu hoạch**: Khi cây chín (màu vàng), tương tác để thu hoạch

**Mẹo**: Một số cây chỉ trồng được trong mùa cụ thể!

### Chăn Nuôi

- **Cho ăn**: Tương tác với động vật đói để cho ăn (cần thức ăn chăn nuôi)
- **Vệ sinh**: Giữ chuồng sạch sẽ để động vật vui vẻ
- **Thu sản phẩm**: Khi có biểu tượng, tương tác để thu trứng/sữa/len/mật ong

**Lưu ý**: Động vật hạnh phúc cho sản phẩm chất lượng cao hơn!

### Xây Dựng & Nâng Cấp

Các công trình có thể xây:
- 🏠 **Nhà kho**: Tăng dung lượng kho đồ
- 🐄 **Chuồng trại**: Chứa bò và cừu
- 🐔 **Chuồng gà**: Chứa gà
- 🐝 **Nhà ong**: Nuôi ong mật
- ⚙️ **Cối xay**: Xay lúa mì thành bột
- 🔨 **Xưởng chế biến**: Chế biến sản phẩm nâng cao

### Chế Biến & Công Thức

Tại **Cối xay** và **Xưởng chế biến**, bạn có thể:
- Xay lúa mì → Bột mì
- Bột mì → Bánh mì
- Sữa → Phô mai
- Len → Vải
- Mật ong + Bột + Trứng → Bánh mật ong

## 🌤️ Hệ Thống Thời Tiết

Thời tiết thay đổi theo ngày và mùa, ảnh hưởng đến:
- ☀️ **Nắng**: Cây trồng tốt, động vật vui
- ☁️ **Nhiều mây**: Bình thường
- 🌧️ **Mưa**: Tự động tưới cây, động vật ít hạnh phúc hơn
- ⛈️ **Bão**: Cây phát triển chậm, ảnh hưởng sản xuất

## 🍂 Hệ Thống Mùa

- 🌸 **Xuân** (Spring): Mùa trồng cà rốt, lúa mì
- ☀️ **Hạ** (Summer): Mùa trồng cà chua, ngô
- 🍂 **Thu** (Fall): Mùa thu hoạch dồi dào
- ❄️ **Đông** (Winter): Mùa khó khăn, trồng khoai tây

Mỗi mùa kéo dài **28 ngày**.

## 💰 Kinh Tế

- Giá hạt giống và sản phẩm **thay đổi theo mùa**
- Bán sản phẩm để kiếm tiền
- Dùng tiền để:
  - Mua hạt giống và thức ăn
  - Xây dựng và nâng cấp công trình
  - Mở rộng trang trại

## 📋 Danh Sách Cây Trồng

| Cây | Thời gian | Mùa | Giá bán |
|-----|-----------|-----|---------|
| 🥕 Cà rốt | 2 ngày | Xuân, Hạ, Thu | 30 xu |
| 🍅 Cà chua | 3.3 ngày | Hạ, Thu | 40 xu |
| 🌾 Lúa mì | 1.6 ngày | Xuân, Hạ, Thu | 20 xu |
| 🌽 Ngô | 2.9 ngày | Hạ | 35 xu |
| 🥔 Khoai tây | 2 ngày | Xuân, Thu, Đông | 25 xu |

## 🐾 Danh Sách Động Vật

| Động vật | Sản phẩm | Chu kỳ | Giá bán |
|----------|----------|--------|---------|
| 🐔 Gà | Trứng | 1 ngày | 15 xu |
| 🐄 Bò | Sữa | 1 ngày | 25 xu |
| 🐑 Cừu | Len | 3 ngày | 35 xu |
| 🐝 Ong | Mật ong | 4 ngày | 50 xu |

## 🔧 Yêu Cầu Hệ Thống

- **Engine**: Godot 4.2+
- **Hệ điều hành**: Windows, Linux, macOS
- **RAM**: 2GB+
- **Card đồ họa**: Hỗ trợ OpenGL 3.3+

## 🚀 Hướng Dẫn Cài Đặt

### 🌐 Chơi Trên Web Browser (Khuyến Nghị!)

**Game có thể chạy ngay trên trình duyệt web!** Không cần cài đặt gì!

#### Option 1: Chơi Online
- 🔗 Truy cập link game (sau khi deploy)
- ✅ Click và chơi ngay!

#### Option 2: Chạy Local
1. **Export game từ Godot** (xem file `EXPORT_TO_WEB.md`)
2. **Start web server** trong folder `web/`:
   ```bash
   python -m http.server 8000
   ```
3. **Mở browser**: `http://localhost:8000`

📖 **Hướng dẫn chi tiết:** Xem file `EXPORT_TO_WEB.md`

---

### 💻 Chơi Game Desktop

1. Download bản release mới nhất
2. Giải nén file
3. Chạy file thực thi `FarmLife.exe` (Windows) hoặc `FarmLife` (Linux/Mac)

---

### 🛠️ Phát Triển

1. Clone repository:
```bash
git clone <repository-url>
cd farnery
```

2. Mở project trong Godot Engine 4.2+:
```bash
godot project.godot
```

3. Nhấn F5 để chạy game

📖 **Setup chi tiết:** Xem file `HUONG_DAN_CHOI.md`

## 📁 Cấu Trúc Project

```
farnery/
├── scenes/              # Các scene game
│   └── main.tscn       # Scene chính
├── scripts/            # Scripts GDScript
│   ├── autoload/       # Singleton managers
│   │   ├── game_manager.gd
│   │   ├── inventory_manager.gd
│   │   ├── weather_system.gd
│   │   └── crafting_system.gd
│   ├── farming/        # Hệ thống nông nghiệp
│   ├── animal/         # Hệ thống chăn nuôi
│   ├── building/       # Hệ thống xây dựng
│   ├── player/         # Điều khiển player
│   ├── npc/            # NPC system
│   ├── interaction/    # Hệ thống tương tác
│   └── ui/             # Giao diện người dùng
├── assets/             # Tài nguyên (models, textures, sounds)
├── project.godot       # File cấu hình Godot
└── README.md           # File này
```

## 🎨 Tính Năng

### ✅ Đã Hoàn Thành

- [x] Hệ thống trồng trọt với 5 loại cây
- [x] Hệ thống chăn nuôi với 4 loại động vật
- [x] Hệ thống thời gian và mùa vụ (4 mùa)
- [x] Hệ thống thời tiết (nắng, mây, mưa, bão)
- [x] Hệ thống xây dựng và nâng cấp (7 loại công trình)
- [x] Hệ thống chế biến với công thức
- [x] Hệ thống kho đồ và quản lý vật phẩm
- [x] Hệ thống buôn bán với giá theo mùa
- [x] NPC thân thiện
- [x] Điều khiển nhân vật 3D
- [x] Hệ thống tương tác (Area3D + prompts)
- [x] UI cơ bản (HUD, Shop)

### 🚧 Đang Phát Triển

- [ ] Hệ thống nhiệm vụ (quests)
- [ ] Tutorial và onboarding
- [ ] Âm thanh và hiệu ứng (SFX, BGM)
- [ ] 3D assets chuyên nghiệp (thay thế placeholders)
- [ ] Animations cho nhân vật và động vật
- [ ] Particle effects (mưa, bụi, sparkles)
- [ ] Lưu/Load game
- [ ] Multiplayer co-op (tương lai)

## 🤝 Đóng Góp

Mọi đóng góp đều được hoan nghênh! Nếu bạn muốn:
- Báo lỗi: Tạo issue
- Đề xuất tính năng: Tạo issue với label "enhancement"
- Code: Fork repo và tạo pull request

## 📜 License

MIT License - Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 🙏 Credits

- **Engine**: [Godot Engine](https://godotengine.org/)
- **Concept**: Inspired by Stardew Valley, Harvest Moon, Animal Crossing
- **Developer**: Phát triển với ❤️ và ☕

## 📞 Liên Hệ

Có câu hỏi? Hãy tạo issue hoặc liên hệ qua:
- GitHub Issues: [Link]
- Email: [Your Email]

---

**🌾 Chúc bạn có trải nghiệm nông trại vui vẻ! 🌾**
