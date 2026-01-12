# GitHub MCP 配置指南

本文档介绍如何配置 GitHub MCP (Model Context Protocol) 来监测 PR 并触发 Claude Auto Review 工作流。

## 目录

- [概述](#概述)
- [前置要求](#前置要求)
- [安装步骤](#安装步骤)
- [配置说明](#配置说明)
- [使用方法](#使用方法)
- [故障排除](#故障排除)

## 概述

GitHub MCP 配置允许 Claude Code 与 GitHub 集成，实现以下功能：

- **自动监测 PR**: 定期检查仓库中的新 PR
- **触发 Claude 审查**: 自动为新 PR 添加审查请求
- **集成 GitHub Actions**: 与现有的 CI/CD 流程配合
- **智能代码审查**: 使用 Claude AI 进行深度代码分析

## 前置要求

### 1. GitHub CLI (gh)

安装 GitHub CLI：

```bash
# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh

# Arch Linux
sudo pacman -S github-cli

# 其他平台
# 访问: https://cli.github.com/
```

认证 GitHub CLI：

```bash
gh auth login
```

### 2. jq (JSON 处理工具)

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt install jq

# Arch Linux
sudo pacman -S jq
```

### 3. GitHub Personal Access Token

创建 GitHub Token：

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 选择权限：
   - `repo` - 完整仓库访问权限
   - `workflow` - 工作流权限
   - `read:org` - 读取组织信息
4. 生成并保存 token

设置环境变量：

```bash
export GITHUB_TOKEN="your_github_token_here"

# 永久保存到 ~/.bashrc 或 ~/.zshrc
echo 'export GITHUB_TOKEN="your_github_token_here"' >> ~/.bashrc
source ~/.bashrc
```

## 安装步骤

### 方法一：自动安装（推荐）

运行安装脚本：

```bash
cd /home/user/yjp-agent
./scripts/setup-pr-watcher.sh
```

按照提示选择运行模式：

1. **Systemd Service** (推荐) - 后台持续运行
2. **Cron Job** - 定时任务
3. **手动运行** - 按需运行

### 方法二：手动配置

#### 1. 配置 Claude Settings

编辑 `.claude/settings.json`：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

#### 2. 设置脚本权限

```bash
chmod +x scripts/pr-watcher.sh
chmod +x scripts/setup-pr-watcher.sh
```

#### 3. 启动 PR Watcher

```bash
# 持续监测模式
./scripts/pr-watcher.sh watch

# 单次检查模式
./scripts/pr-watcher.sh check
```

## 配置说明

### PR Watcher 配置

环境变量配置：

```bash
# 仓库所有者
export GITHUB_REPOSITORY_OWNER="yjp1510586926"

# 仓库名称
export GITHUB_REPOSITORY_NAME="yjp-agent"

# 检查间隔（秒）
export PR_CHECK_INTERVAL=300  # 默认 5 分钟
```

### Systemd Service 配置

Service 文件位置：`/etc/systemd/system/pr-watcher.service`

```ini
[Unit]
Description=GitHub PR Watcher for Claude Auto Review
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/home/user/yjp-agent
ExecStart=/home/user/yjp-agent/scripts/pr-watcher.sh watch
Restart=always
RestartSec=10

Environment="GITHUB_REPOSITORY_OWNER=yjp1510586926"
Environment="GITHUB_REPOSITORY_NAME=yjp-agent"
Environment="PR_CHECK_INTERVAL=300"

[Install]
WantedBy=multi-user.target
```

管理服务：

```bash
# 启动服务
sudo systemctl start pr-watcher

# 停止服务
sudo systemctl stop pr-watcher

# 重启服务
sudo systemctl restart pr-watcher

# 查看状态
sudo systemctl status pr-watcher

# 查看日志
sudo journalctl -u pr-watcher -f
```

### Cron Job 配置

编辑 crontab：

```bash
crontab -e
```

添加定时任务（每 5 分钟）：

```cron
*/5 * * * * /home/user/yjp-agent/scripts/pr-watcher.sh check >> /tmp/pr-watcher.log 2>&1
```

查看日志：

```bash
tail -f /tmp/pr-watcher.log
```

## 使用方法

### 1. PR Watcher 命令

```bash
# 显示帮助
./scripts/pr-watcher.sh help

# 持续监测 PR
./scripts/pr-watcher.sh watch

# 单次检查
./scripts/pr-watcher.sh check

# 重置状态（重新处理所有 PR）
./scripts/pr-watcher.sh reset
```

### 2. 工作流程

1. **创建 PR**: 开发者创建 Pull Request
2. **自动检测**: PR Watcher 检测到新 PR
3. **触发审查**: 自动添加 Claude 审查请求评论
4. **GitHub Actions**: 运行自动化检查（lint, test, build）
5. **Claude 审查**: Claude AI 进行代码审查
6. **反馈结果**: 在 PR 中添加审查结果和建议

### 3. GitHub Actions 集成

PR 提交时自动触发的检查：

- ✅ 代码质量检查 (ESLint)
- ✅ TypeScript 类型检查
- ✅ 单元测试
- ✅ 构建测试
- ✅ 安全扫描
- ✅ PR 大小检查

### 4. Claude Code CLI 手动审查

在本地使用 Claude 审查 PR：

```bash
# 启动 Claude Code
claude

# 在 Claude 中执行
/code-review

# 或者手动审查
请审查 PR #<number> 的代码
重点检查：代码质量、安全性、性能、测试覆盖率
```

## 故障排除

### 问题 1: GitHub CLI 未认证

**错误信息**:
```
GitHub CLI 未认证
```

**解决方法**:
```bash
gh auth login
# 按照提示完成认证
```

### 问题 2: GITHUB_TOKEN 未设置

**错误信息**:
```
GITHUB_PERSONAL_ACCESS_TOKEN not set
```

**解决方法**:
```bash
export GITHUB_TOKEN="your_token_here"

# 永久保存
echo 'export GITHUB_TOKEN="your_token_here"' >> ~/.bashrc
source ~/.bashrc
```

### 问题 3: PR Watcher 无法启动

**检查步骤**:

1. 检查依赖是否安装：
   ```bash
   which gh jq
   ```

2. 检查脚本权限：
   ```bash
   ls -l scripts/pr-watcher.sh
   # 应该显示 -rwxr-xr-x
   ```

3. 手动运行测试：
   ```bash
   ./scripts/pr-watcher.sh check
   ```

### 问题 4: Systemd Service 启动失败

**查看错误日志**:
```bash
sudo journalctl -u pr-watcher -n 50
```

**常见原因**:
- 路径配置错误
- 权限不足
- 环境变量未设置

**解决方法**:
```bash
# 检查 service 文件
sudo cat /etc/systemd/system/pr-watcher.service

# 重新加载配置
sudo systemctl daemon-reload

# 重启服务
sudo systemctl restart pr-watcher
```

### 问题 5: MCP Server 连接失败

**检查 MCP 配置**:
```bash
cat .claude/settings.json
```

**测试 GitHub MCP**:
```bash
npx -y @modelcontextprotocol/server-github
```

**确保环境变量正确**:
```bash
echo $GITHUB_TOKEN
```

## 高级配置

### 自定义检查间隔

修改检查间隔为 1 分钟：

```bash
PR_CHECK_INTERVAL=60 ./scripts/pr-watcher.sh watch
```

### 监测多个仓库

创建多个 service 文件，每个仓库一个：

```bash
# 复制 service 文件
sudo cp /etc/systemd/system/pr-watcher.service \
       /etc/systemd/system/pr-watcher-repo2.service

# 编辑新文件，修改仓库名称
sudo nano /etc/systemd/system/pr-watcher-repo2.service
```

### 自定义审查规则

编辑 `.github/workflows/claude-auto-review.yml` 来自定义审查规则和流程。

## 最佳实践

1. **定期检查日志**: 确保 PR Watcher 正常运行
2. **及时更新 Token**: GitHub Token 有过期时间
3. **监控服务状态**: 使用 systemd 或监控工具
4. **测试新配置**: 在测试仓库先验证
5. **备份配置**: 定期备份 `.claude/settings.json`

## 相关文档

- [GitHub MCP 官方文档](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [Claude Code 文档](https://docs.anthropic.com/claude/docs)
- [GitHub Actions 工作流](../.github/workflows/claude-auto-review.yml)
- [AI 工作流文档](./AI-WORKFLOW.md)

## 支持

如遇问题，请：

1. 查看本文档的故障排除部分
2. 检查 GitHub Issues
3. 查看日志文件
4. 联系维护者

---

最后更新: 2026-01-12
