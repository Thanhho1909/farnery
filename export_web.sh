#!/bin/bash
# Script tự động export game Godot ra Web

set -e  # Exit on error

echo "🌐 =========================================="
echo "   FARM LIFE - WEB EXPORT SCRIPT"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Godot is installed
echo -e "${BLUE}📦 Kiểm tra Godot...${NC}"
if command -v godot &> /dev/null; then
    GODOT_CMD="godot"
    echo -e "${GREEN}✅ Tìm thấy Godot: $(godot --version)${NC}"
elif command -v godot4 &> /dev/null; then
    GODOT_CMD="godot4"
    echo -e "${GREEN}✅ Tìm thấy Godot: $(godot4 --version)${NC}"
elif [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
    GODOT_CMD="/Applications/Godot.app/Contents/MacOS/Godot"
    echo -e "${GREEN}✅ Tìm thấy Godot (macOS)${NC}"
elif [ -f "C:/Program Files/Godot/Godot.exe" ]; then
    GODOT_CMD="C:/Program Files/Godot/Godot.exe"
    echo -e "${GREEN}✅ Tìm thấy Godot (Windows)${NC}"
else
    echo -e "${RED}❌ Không tìm thấy Godot!${NC}"
    echo -e "${YELLOW}Vui lòng cài Godot 4.2+ từ: https://godotengine.org${NC}"
    echo ""
    echo "Hoặc chỉ định path thủ công:"
    echo "  export GODOT_BIN=/path/to/godot"
    echo "  ./export_web.sh"
    exit 1
fi

# Allow manual override
if [ ! -z "$GODOT_BIN" ]; then
    GODOT_CMD="$GODOT_BIN"
    echo -e "${YELLOW}⚙️  Sử dụng custom Godot: $GODOT_CMD${NC}"
fi

echo ""

# Check if export templates exist
echo -e "${BLUE}📦 Kiểm tra export templates...${NC}"
TEMPLATE_DIR="$HOME/.local/share/godot/export_templates"
if [ -d "$TEMPLATE_DIR" ]; then
    echo -e "${GREEN}✅ Export templates đã cài${NC}"
else
    echo -e "${YELLOW}⚠️  Chưa có export templates${NC}"
    echo -e "${YELLOW}Vui lòng cài từ Godot Editor:${NC}"
    echo "  Editor > Manage Export Templates > Download and Install"
    echo ""
    read -p "Tiếp tục thử export? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""

# Create web directory if doesn't exist
if [ ! -d "web" ]; then
    echo -e "${BLUE}📁 Tạo thư mục web/...${NC}"
    mkdir -p web
fi

# Backup existing build
if [ -f "web/index.pck" ]; then
    echo -e "${YELLOW}📦 Backup build cũ...${NC}"
    BACKUP_DIR="web/backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    mv web/index.pck "$BACKUP_DIR/" 2>/dev/null || true
    mv web/index.wasm "$BACKUP_DIR/" 2>/dev/null || true
    mv web/index.js "$BACKUP_DIR/" 2>/dev/null || true
    echo -e "${GREEN}✅ Đã backup vào $BACKUP_DIR${NC}"
fi

echo ""

# Export the game
echo -e "${BLUE}🚀 Đang export game...${NC}"
echo "   Preset: Web"
echo "   Output: ./web/index.html"
echo ""

if "$GODOT_CMD" --headless --export-release "Web" ./web/index.html --verbose 2>&1; then
    echo ""
    echo -e "${GREEN}✅ =========================================="
    echo "   EXPORT THÀNH CÔNG!"
    echo "==========================================${NC}"
    echo ""

    # Check file sizes
    if [ -f "web/index.pck" ]; then
        PCK_SIZE=$(du -h web/index.pck | cut -f1)
        echo -e "${GREEN}📦 index.pck: $PCK_SIZE${NC}"
    fi
    if [ -f "web/index.wasm" ]; then
        WASM_SIZE=$(du -h web/index.wasm | cut -f1)
        echo -e "${GREEN}📦 index.wasm: $WASM_SIZE${NC}"
    fi

    echo ""
    echo -e "${BLUE}📁 Files trong web/:${NC}"
    ls -lh web/ | grep -E '\.(html|pck|wasm|js)$' || true
    echo ""

    # Offer to start web server
    echo -e "${YELLOW}🌐 Chạy web server để test?${NC}"
    echo ""
    echo "Chọn một option:"
    echo "  1) Python 3 server (port 8000)"
    echo "  2) Python 2 server (port 8000)"
    echo "  3) Node.js http-server (port 8000)"
    echo "  4) Không, thoát"
    echo ""
    read -p "Lựa chọn (1-4): " -n 1 -r SERVER_CHOICE
    echo ""
    echo ""

    cd web

    case $SERVER_CHOICE in
        1)
            echo -e "${GREEN}🚀 Starting Python 3 server...${NC}"
            echo -e "${BLUE}➡️  Game URL: http://localhost:8000${NC}"
            echo ""
            echo "Nhấn Ctrl+C để dừng server"
            echo ""
            python3 -m http.server 8000
            ;;
        2)
            echo -e "${GREEN}🚀 Starting Python 2 server...${NC}"
            echo -e "${BLUE}➡️  Game URL: http://localhost:8000${NC}"
            echo ""
            echo "Nhấn Ctrl+C để dừng server"
            echo ""
            python -m SimpleHTTPServer 8000
            ;;
        3)
            echo -e "${GREEN}🚀 Starting Node.js server...${NC}"
            echo -e "${BLUE}➡️  Game URL: http://localhost:8000${NC}"
            echo ""
            echo "Nhấn Ctrl+C để dừng server"
            echo ""
            npx http-server -p 8000 --cors
            ;;
        4)
            echo -e "${YELLOW}✋ Đã bỏ qua web server${NC}"
            echo ""
            echo -e "${BLUE}Để chạy game sau này:${NC}"
            echo "  cd web"
            echo "  python3 -m http.server 8000"
            echo "  # Mở http://localhost:8000"
            ;;
        *)
            echo -e "${YELLOW}Lựa chọn không hợp lệ. Thoát.${NC}"
            ;;
    esac

else
    echo ""
    echo -e "${RED}❌ =========================================="
    echo "   EXPORT THẤT BẠI!"
    echo "==========================================${NC}"
    echo ""
    echo -e "${YELLOW}Có thể do:${NC}"
    echo "  - Export templates chưa cài"
    echo "  - Preset 'Web' không tồn tại"
    echo "  - Godot version không khớp"
    echo ""
    echo -e "${YELLOW}Thử export thủ công:${NC}"
    echo "  1. Mở Godot Editor"
    echo "  2. Project > Export"
    echo "  3. Chọn preset 'Web'"
    echo "  4. Export Project"
    echo ""
    exit 1
fi
