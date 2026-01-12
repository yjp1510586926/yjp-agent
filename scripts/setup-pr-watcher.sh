#!/bin/bash

# Setup PR Watcher
# 安装和配置 PR 监测服务

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

log_info "设置 PR Watcher..."
log_info "项目目录: $PROJECT_DIR"

# 检查依赖
log_info "检查依赖..."

if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI (gh) 未安装"
    log_info "安装 GitHub CLI:"
    echo ""
    echo "  macOS:   brew install gh"
    echo "  Ubuntu:  sudo apt install gh"
    echo "  Arch:    sudo pacman -S github-cli"
    echo ""
    exit 1
fi

if ! command -v jq &> /dev/null; then
    log_error "jq 未安装"
    log_info "安装 jq:"
    echo ""
    echo "  macOS:   brew install jq"
    echo "  Ubuntu:  sudo apt install jq"
    echo "  Arch:    sudo pacman -S jq"
    echo ""
    exit 1
fi

log_success "依赖检查通过"

# 检查 GitHub 认证
log_info "检查 GitHub CLI 认证状态..."

if ! gh auth status &> /dev/null; then
    log_warning "GitHub CLI 未认证"
    log_info "正在启动认证流程..."
    gh auth login
fi

log_success "GitHub CLI 已认证"

# 设置执行权限
log_info "设置脚本执行权限..."
chmod +x "$SCRIPT_DIR/pr-watcher.sh"
log_success "执行权限已设置"

# 选择运行模式
echo ""
log_info "请选择 PR Watcher 运行模式:"
echo "  1) Systemd Service (推荐，后台持续运行)"
echo "  2) Cron Job (定时任务)"
echo "  3) 手动运行 (不安装服务)"
echo ""
read -p "请输入选择 [1-3]: " mode_choice

case $mode_choice in
    1)
        log_info "安装 Systemd Service..."

        # 创建 service 文件
        SERVICE_FILE="/etc/systemd/system/pr-watcher.service"

        if [ ! -w "/etc/systemd/system" ]; then
            log_warning "需要 sudo 权限来安装 systemd service"
        fi

        sudo cp "$SCRIPT_DIR/pr-watcher.service" "$SERVICE_FILE"

        # 更新 service 文件中的路径
        sudo sed -i "s|/home/user/yjp-agent|$PROJECT_DIR|g" "$SERVICE_FILE"
        sudo sed -i "s|User=%i|User=$USER|g" "$SERVICE_FILE"

        # 重载 systemd
        sudo systemctl daemon-reload

        # 启用服务
        sudo systemctl enable pr-watcher.service

        # 启动服务
        sudo systemctl start pr-watcher.service

        log_success "Systemd service 已安装并启动"
        log_info "查看状态: sudo systemctl status pr-watcher"
        log_info "查看日志: sudo journalctl -u pr-watcher -f"
        log_info "停止服务: sudo systemctl stop pr-watcher"
        log_info "重启服务: sudo systemctl restart pr-watcher"
        ;;

    2)
        log_info "设置 Cron Job..."

        # 创建 cron 任务（每 5 分钟运行一次）
        CRON_CMD="*/5 * * * * $SCRIPT_DIR/pr-watcher.sh check >> /tmp/pr-watcher.log 2>&1"

        # 检查是否已存在
        if crontab -l 2>/dev/null | grep -q "pr-watcher.sh"; then
            log_warning "Cron 任务已存在"
        else
            (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
            log_success "Cron 任务已添加"
        fi

        log_info "查看 cron 任务: crontab -l"
        log_info "查看日志: tail -f /tmp/pr-watcher.log"
        log_info "删除 cron 任务: crontab -e"
        ;;

    3)
        log_info "手动运行模式"
        log_success "设置完成"
        echo ""
        log_info "运行命令:"
        echo "  持续监测: $SCRIPT_DIR/pr-watcher.sh watch"
        echo "  单次检查: $SCRIPT_DIR/pr-watcher.sh check"
        echo "  重置状态: $SCRIPT_DIR/pr-watcher.sh reset"
        echo "  查看帮助: $SCRIPT_DIR/pr-watcher.sh help"
        ;;

    *)
        log_error "无效的选择"
        exit 1
        ;;
esac

echo ""
log_success "PR Watcher 设置完成！"
echo ""
log_info "配置文件: $PROJECT_DIR/.claude/settings.json"
log_info "GitHub MCP Server 已配置"
echo ""
log_info "下一步:"
echo "  1. 确保 GITHUB_TOKEN 环境变量已设置"
echo "  2. 检查 PR Watcher 是否正常运行"
echo "  3. 创建测试 PR 验证功能"
echo ""
