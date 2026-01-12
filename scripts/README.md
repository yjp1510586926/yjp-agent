# Scripts 目录

这个目录包含了项目的自动化脚本。

## 文件说明

### pr-watcher.sh
GitHub PR 监测脚本，用于自动检测新的 Pull Request 并触发 Claude 代码审查。

**功能**:
- 定期检查仓库中的开放 PR
- 为新 PR 自动添加 Claude 审查请求
- 支持持续监测和单次检查模式
- 记录已处理的 PR 避免重复处理

**使用方法**:
```bash
# 持续监测模式
./pr-watcher.sh watch

# 单次检查模式
./pr-watcher.sh check

# 重置状态
./pr-watcher.sh reset

# 显示帮助
./pr-watcher.sh help
```

### setup-pr-watcher.sh
PR Watcher 安装配置脚本，提供自动化的安装流程。

**功能**:
- 检查和验证依赖（gh, jq）
- 配置 GitHub CLI 认证
- 设置脚本执行权限
- 提供多种运行模式选择（Systemd/Cron/手动）

**使用方法**:
```bash
./setup-pr-watcher.sh
```

### pr-watcher.service
Systemd 服务配置文件，用于将 PR Watcher 作为系统服务运行。

**安装**:
```bash
sudo cp pr-watcher.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable pr-watcher
sudo systemctl start pr-watcher
```

## 环境变量

所有脚本支持以下环境变量：

- `GITHUB_REPOSITORY_OWNER`: GitHub 仓库所有者（默认: yjp1510586926）
- `GITHUB_REPOSITORY_NAME`: GitHub 仓库名称（默认: yjp-agent）
- `PR_CHECK_INTERVAL`: PR 检查间隔，单位秒（默认: 300）
- `GITHUB_TOKEN`: GitHub Personal Access Token（必需）

## 依赖要求

- **GitHub CLI (gh)**: GitHub 命令行工具
- **jq**: JSON 处理工具
- **bash**: Shell 脚本解释器

## 相关文档

- [GitHub MCP 配置指南](../docs/GITHUB-MCP-SETUP.md)
- [快速开始指南](../docs/QUICK-START-MCP.md)
- [Claude Auto Review 工作流](../.github/workflows/claude-auto-review.yml)

## 许可

ISC License
