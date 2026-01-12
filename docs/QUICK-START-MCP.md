# GitHub MCP 快速开始指南

快速设置 GitHub MCP 来监测 PR 并触发 Claude Auto Review。

## 一键安装

```bash
cd /home/user/yjp-agent

# 1. 设置 GitHub Token
export GITHUB_TOKEN="your_github_personal_access_token"

# 2. 运行安装脚本
./scripts/setup-pr-watcher.sh
```

## 验证安装

```bash
# 检查 GitHub CLI 认证
gh auth status

# 测试 PR Watcher
./scripts/pr-watcher.sh check

# 查看配置
cat .claude/settings.json
```

## 运行 PR Watcher

### 选项 1: Systemd Service (推荐)

```bash
# 启动服务
sudo systemctl start pr-watcher

# 查看状态
sudo systemctl status pr-watcher

# 查看日志
sudo journalctl -u pr-watcher -f
```

### 选项 2: 手动运行

```bash
# 持续监测
./scripts/pr-watcher.sh watch

# 单次检查
./scripts/pr-watcher.sh check
```

### 选项 3: Cron Job

```bash
# 添加到 crontab（每 5 分钟）
*/5 * * * * /home/user/yjp-agent/scripts/pr-watcher.sh check
```

## 测试流程

1. **创建测试 PR**:
   ```bash
   git checkout -b test-pr
   echo "test" > test.txt
   git add test.txt
   git commit -m "test: PR watcher"
   git push -u origin test-pr
   gh pr create --title "Test PR" --body "Testing PR watcher"
   ```

2. **等待检测**: PR Watcher 会在下一次检查时发现新 PR

3. **查看结果**: 检查 PR 评论中的 Claude 审查请求

## 常用命令

```bash
# PR Watcher 命令
./scripts/pr-watcher.sh help    # 帮助信息
./scripts/pr-watcher.sh watch   # 持续监测
./scripts/pr-watcher.sh check   # 单次检查
./scripts/pr-watcher.sh reset   # 重置状态

# GitHub CLI 命令
gh pr list                      # 查看 PR 列表
gh pr view <number>             # 查看 PR 详情
gh pr checks <number>           # 查看 PR 检查状态

# Claude Code CLI
claude                          # 启动 Claude
/code-review                    # 代码审查
```

## 故障排除

### GitHub CLI 未认证
```bash
gh auth login
```

### GITHUB_TOKEN 未设置
```bash
export GITHUB_TOKEN="your_token"
echo 'export GITHUB_TOKEN="your_token"' >> ~/.bashrc
```

### 检查依赖
```bash
which gh jq
```

## 下一步

- 📖 阅读完整文档: [GITHUB-MCP-SETUP.md](./GITHUB-MCP-SETUP.md)
- 🔧 自定义配置: `.claude/settings.json`
- 🚀 配置 GitHub Actions: `.github/workflows/claude-auto-review.yml`

---

**需要帮助?** 查看 [GITHUB-MCP-SETUP.md](./GITHUB-MCP-SETUP.md) 获取详细说明。
