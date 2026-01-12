#!/bin/bash

# PR Watcher Script
# 监测 GitHub PR 并触发 Claude Auto Review

set -e

# 配置
REPO_OWNER="${GITHUB_REPOSITORY_OWNER:-yjp1510586926}"
REPO_NAME="${GITHUB_REPOSITORY_NAME:-yjp-agent}"
CHECK_INTERVAL="${PR_CHECK_INTERVAL:-300}"  # 默认 5 分钟检查一次
STATE_FILE="/tmp/pr_watcher_state.json"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 检查依赖
check_dependencies() {
    log_info "检查依赖..."

    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) 未安装"
        log_info "安装方法: https://cli.github.com/"
        exit 1
    fi

    if ! command -v jq &> /dev/null; then
        log_error "jq 未安装"
        log_info "安装方法: sudo apt-get install jq 或 brew install jq"
        exit 1
    fi

    # 检查 gh 认证状态
    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI 未认证"
        log_info "运行: gh auth login"
        exit 1
    fi

    log_success "所有依赖检查通过"
}

# 初始化状态文件
init_state_file() {
    if [ ! -f "$STATE_FILE" ]; then
        echo '{"last_check": 0, "processed_prs": []}' > "$STATE_FILE"
        log_info "初始化状态文件: $STATE_FILE"
    fi
}

# 获取已处理的 PR 列表
get_processed_prs() {
    jq -r '.processed_prs[]' "$STATE_FILE" 2>/dev/null || echo ""
}

# 标记 PR 为已处理
mark_pr_processed() {
    local pr_number=$1
    local temp_file=$(mktemp)

    jq --arg pr "$pr_number" '.processed_prs += [$pr] | .processed_prs |= unique' "$STATE_FILE" > "$temp_file"
    mv "$temp_file" "$STATE_FILE"

    log_info "PR #$pr_number 已标记为已处理"
}

# 获取开放的 PR 列表
get_open_prs() {
    log_info "获取开放的 PR 列表..."

    gh pr list \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --state open \
        --json number,title,author,headRefName,baseRefName,createdAt,updatedAt \
        --limit 100
}

# 触发 Claude 自动审查
trigger_claude_review() {
    local pr_number=$1
    local pr_title=$2
    local pr_author=$3
    local pr_branch=$4

    log_info "触发 PR #$pr_number 的 Claude 自动审查"
    log_info "  标题: $pr_title"
    log_info "  作者: $pr_author"
    log_info "  分支: $pr_branch"

    # 检查是否已经有 Claude 审查评论
    local has_review_comment=$(gh pr view "$pr_number" \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --json comments \
        --jq '.comments[] | select(.body | contains("Claude Code Review"))' | wc -l)

    if [ "$has_review_comment" -gt 0 ]; then
        log_warning "PR #$pr_number 已经有 Claude 审查评论，跳过"
        return 0
    fi

    # 添加审查请求评论
    local comment="## 🤖 Claude Auto Review Triggered

此 PR 已触发 Claude 自动代码审查流程。

### 📋 审查流程

1. ✅ 自动化质量检查（通过 GitHub Actions）
2. 🔍 Claude AI 代码审查
3. 📝 生成审查报告和建议

### 🔄 审查状态

Claude 正在分析您的代码，请稍候...

**审查内容包括：**
- 代码质量和编码规范
- 安全漏洞检测
- 性能优化建议
- 测试覆盖率分析
- 架构设计审查

### 💡 手动审查

您也可以在本地使用 Claude Code CLI 进行审查：

\`\`\`bash
claude

# 在 Claude 中执行
/code-review
\`\`\`

或者：

\`\`\`bash
# 审查 PR #$pr_number
请审查 PR #$pr_number 的代码
重点检查：代码质量、安全性、性能、测试覆盖率
\`\`\`

---

*触发时间: $(date '+%Y-%m-%d %H:%M:%S')*
*仓库: $REPO_OWNER/$REPO_NAME*
"

    # 发布评论
    gh pr comment "$pr_number" \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --body "$comment"

    log_success "已为 PR #$pr_number 添加审查请求评论"

    # 添加标签
    gh pr edit "$pr_number" \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --add-label "claude-review-pending" 2>/dev/null || true

    log_success "已添加 claude-review-pending 标签"

    # 标记为已处理
    mark_pr_processed "$pr_number"
}

# 主循环
watch_prs() {
    log_info "开始监测 PR..."
    log_info "仓库: $REPO_OWNER/$REPO_NAME"
    log_info "检查间隔: ${CHECK_INTERVAL}秒"

    while true; do
        log_info "检查新的 PR..."

        # 获取已处理的 PR
        processed_prs=$(get_processed_prs)

        # 获取开放的 PR
        open_prs=$(get_open_prs)

        if [ -z "$open_prs" ] || [ "$open_prs" = "[]" ]; then
            log_info "当前没有开放的 PR"
        else
            # 处理每个 PR
            echo "$open_prs" | jq -c '.[]' | while read -r pr; do
                pr_number=$(echo "$pr" | jq -r '.number')
                pr_title=$(echo "$pr" | jq -r '.title')
                pr_author=$(echo "$pr" | jq -r '.author.login')
                pr_branch=$(echo "$pr" | jq -r '.headRefName')

                # 检查是否已处理
                if echo "$processed_prs" | grep -q "^${pr_number}$"; then
                    log_info "PR #$pr_number 已处理过，跳过"
                    continue
                fi

                log_info "发现新的 PR #$pr_number"

                # 触发审查
                trigger_claude_review "$pr_number" "$pr_title" "$pr_author" "$pr_branch"
            done
        fi

        # 更新最后检查时间
        temp_file=$(mktemp)
        jq --arg time "$(date +%s)" '.last_check = ($time | tonumber)' "$STATE_FILE" > "$temp_file"
        mv "$temp_file" "$STATE_FILE"

        log_info "等待 ${CHECK_INTERVAL} 秒后进行下一次检查..."
        sleep "$CHECK_INTERVAL"
    done
}

# 单次检查模式
check_once() {
    log_info "执行单次 PR 检查..."

    # 获取已处理的 PR
    processed_prs=$(get_processed_prs)

    # 获取开放的 PR
    open_prs=$(get_open_prs)

    if [ -z "$open_prs" ] || [ "$open_prs" = "[]" ]; then
        log_info "当前没有开放的 PR"
        exit 0
    fi

    # 处理每个 PR
    echo "$open_prs" | jq -c '.[]' | while read -r pr; do
        pr_number=$(echo "$pr" | jq -r '.number')
        pr_title=$(echo "$pr" | jq -r '.title')
        pr_author=$(echo "$pr" | jq -r '.author.login')
        pr_branch=$(echo "$pr" | jq -r '.headRefName')

        # 检查是否已处理
        if echo "$processed_prs" | grep -q "^${pr_number}$"; then
            log_info "PR #$pr_number 已处理过，跳过"
            continue
        fi

        log_info "发现新的 PR #$pr_number"

        # 触发审查
        trigger_claude_review "$pr_number" "$pr_title" "$pr_author" "$pr_branch"
    done

    log_success "单次检查完成"
}

# 重置状态
reset_state() {
    log_warning "重置 PR 监测状态..."
    rm -f "$STATE_FILE"
    init_state_file
    log_success "状态已重置"
}

# 显示帮助
show_help() {
    cat << EOF
PR Watcher - GitHub PR 监测工具

用法:
    $0 [命令] [选项]

命令:
    watch       持续监测 PR（默认）
    check       单次检查并退出
    reset       重置监测状态
    help        显示此帮助信息

环境变量:
    GITHUB_REPOSITORY_OWNER     GitHub 仓库所有者（默认: yjp1510586926）
    GITHUB_REPOSITORY_NAME      GitHub 仓库名称（默认: yjp-agent）
    PR_CHECK_INTERVAL           检查间隔（秒，默认: 300）

示例:
    # 持续监测
    $0 watch

    # 单次检查
    $0 check

    # 自定义检查间隔（60秒）
    PR_CHECK_INTERVAL=60 $0 watch

    # 重置状态
    $0 reset

EOF
}

# 主函数
main() {
    local command="${1:-watch}"

    case "$command" in
        watch)
            check_dependencies
            init_state_file
            watch_prs
            ;;
        check)
            check_dependencies
            init_state_file
            check_once
            ;;
        reset)
            reset_state
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac
}

# 捕获退出信号
trap 'log_info "收到退出信号，正在清理..."; exit 0' SIGINT SIGTERM

# 运行主函数
main "$@"
