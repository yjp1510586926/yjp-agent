#!/bin/bash

# 配置
REPO=$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\).git/\1/')
INTERVAL=30 # 轮询间隔（秒）

echo "🚀 Codex 本地监听器已启动"
echo "📡 正在监听仓库: $REPO"
echo "waiting for tasks..."

while true; do
    # 1. 检查是否有带 "codex-task" 标签且未处理的 Issue
    # 我们查找没有 "processing" 标签的任务，防止重复处理
    ISSUE_JSON=$(gh issue list --repo "$REPO" --label "codex-task" --search "-label:processing state:open" --limit 1 --json number,title,body)
    
    # 检查是否获取到任务
    ISSUE_NUM=$(echo "$ISSUE_JSON" | jq -r '.[0].number // empty')
    
    if [ -n "$ISSUE_NUM" ]; then
        TITLE=$(echo "$ISSUE_JSON" | jq -r '.[0].title')
        BODY=$(echo "$ISSUE_JSON" | jq -r '.[0].body')
        
        echo "---------------------------------------------------"
        echo "🔥 发现新任务: #$ISSUE_NUM - $TITLE"
        
        # 2. 标记任务为进行中，避免重复获取
        echo "🔒 锁定任务..."
        gh issue edit "$ISSUE_NUM" --add-label "processing" --repo "$REPO"
        gh issue comment "$ISSUE_NUM" --body "🤖 Codex (Local) 正在处理此任务..." --repo "$REPO"
        
        # 3. 调用本地 Codex 执行任务
        echo "👨‍💻 Codex 正在编码..."
        
        # 构建 Prompt，强调是本地执行
        PROMPT="你现在在本地开发环境中。请处理以下 GitHub Issue 任务：\n\n标题：$TITLE\n\n描述：\n$BODY\n\n请修改本地代码以实现需求。完成后请确保代码可通过编译。"
        
        # 运行 Codex (非交互模式)
        # 注意：这里假设 codex 接受单个字符串参数作为 prompt
        # 如果需要确认，可以加上 -y 参数或者配置 --ask-for-approval never
        codex "$PROMPT" --dangerously-bypass-approvals-and-sandbox
        
        CODEX_EXIT_CODE=$?
        
        # 4. 提交结果
        if [ $CODEX_EXIT_CODE -eq 0 ]; then
            echo "✅ 编码完成，正在提交代码..."
            
            # 检查是否有文件变更
            if [[ -n $(git status -s) ]]; then
                git add .
                git commit -m "feat: [Codex] resolve issue #$ISSUE_NUM - $TITLE"
                git push
                
                gh issue comment "$ISSUE_NUM" --body "✅ 任务已完成，代码已推送。" --repo "$REPO"
                gh issue close "$ISSUE_NUM" --repo "$REPO"
                echo "🎉 任务 #$ISSUE_NUM 已完成并关闭。"
            else
                echo "⚠️ Codex 似乎没有修改任何文件。"
                gh issue comment "$ISSUE_NUM" --body "🤔 Codex 执行完成，但没有检测到文件变更。请检查任务描述是否足够清晰。" --repo "$REPO"
                # 移除 processing 标签以便重试或人工介入
                gh issue edit "$ISSUE_NUM" --remove-label "processing" --repo "$REPO"
            fi
        else
            echo "❌ Codex 执行失败。"
            gh issue comment "$ISSUE_NUM" --body "❌ Codex 本地执行遇到错误。" --repo "$REPO"
            gh issue edit "$ISSUE_NUM" --remove-label "processing" --repo "$REPO"
        fi
        
        echo "---------------------------------------------------"
        echo "👀 继续监听..."
    fi
    
    sleep $INTERVAL
done
