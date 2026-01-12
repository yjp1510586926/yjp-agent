#!/bin/bash

# 配置
REPO_URL=$(git remote get-url origin)
# 轮询间隔 (秒)
INTERVAL=300 

echo "👀 启动本地 PR 监控..."
echo "仓库: $REPO_URL"
echo "按 Ctrl+C 停止"

while true; do
    # 1. 获取最新一个 open 状态的 PR (由 Codex Worker 创建的)
    # 不仅仅看有没有，还要看它是不是刚才生成的
    PR_INFO=$(gh pr list --state open --limit 1 --json number,title,author,url --label "codex-submission" 2>/dev/null)
    
    if [ -n "$PR_INFO" ] && [ "$PR_INFO" != "[]" ]; then
        PR_NUM=$(echo "$PR_INFO" | jq -r '.[0].number')
        PR_TITLE=$(echo "$PR_INFO" | jq -r '.[0].title')
        PR_URL=$(echo "$PR_INFO" | jq -r '.[0].url')
        
        # 检查是否已经是处理过的 (这里简单用个文件标记，实际可以用更复杂的逻辑)
        if [ ! -f ".last_reviewed_pr" ] || [ "$(cat .last_reviewed_pr)" != "$PR_NUM" ]; then
            echo "---------------------------------------------------"
            echo "🚨 发现新 PR #$PR_NUM: $PR_TITLE"
            echo "🔗 链接: $PR_URL"
            echo "---------------------------------------------------"
            
            # 这里可以触发 Claude 进行审查
            # 例如: claude "Review PR $PR_URL"
            # 目前先仅做提示
            echo "💡 提示: 请使用 Claude 审查此 PR:"
            echo "   /code-review $PR_URL"
            
            # 记录已通知
            echo "$PR_NUM" > .last_reviewed_pr
            
            # (可选) 发出系统声音提示
            tput bel
        fi
    fi
    
    echo "😴 暂无新 PR，$(date "+%H:%M:%S") 休眠 ${INTERVAL}s..."
    sleep $INTERVAL
done
