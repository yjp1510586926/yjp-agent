# 🔍 AI 工作进度监控指南

> 如何实时查看 Codex 和 Claude 的工作状态

---

## 🎯 监控概览

提交 `todo.md` 后，你可以通过以下方式监控 AI 的工作：

```
git push
   ↓
1️⃣ GitHub Actions 运行状态
   ↓
2️⃣ Codex Issue 创建
   ↓
3️⃣ Codex 开发进度（PR）
   ↓
4️⃣ 自动化检查状态
   ↓
5️⃣ Claude 审查结果
```

---

## 1️⃣ GitHub Actions 监控

### 方式 1: GitHub 网页查看（推荐）

**访问地址：**
```
https://github.com/yjp1510586926/yjp-agent/actions
```

**查看步骤：**
1. 打开仓库主页
2. 点击顶部的 **"Actions"** 标签
3. 看到最新的 workflow 运行记录

**状态指示：**
- 🟡 **黄色转圈** - 正在运行
- ✅ **绿色对勾** - 运行成功
- ❌ **红色叉号** - 运行失败

**关键 Workflow：**

#### a) Todo Changed - Trigger Codex
- **触发时机**: 当你 push 包含 `todo.md` 变化的提交时
- **运行时间**: ~1-2 分钟
- **查看内容**:
  ```
  Actions → 点击 "Todo Changed - Trigger Codex" workflow
  → 点击最新的运行记录
  → 查看各个步骤的日志
  ```

**成功标志：**
- ✅ Checkout code
- ✅ Get changed tasks
- ✅ Parse new tasks
- ✅ Create Codex notification comment
- ✅ Upload todo.md as artifact

**实时日志查看：**
```
点击任意步骤 → 展开查看详细日志
可以看到：
- 检测到的变化
- 解析的任务内容
- 创建的 Issue 链接
```

### 方式 2: 命令行查看

使用 GitHub CLI（需要先安装 `gh`）：

```bash
# 查看最新的 workflow 运行
gh run list --limit 5

# 查看特定 workflow 的运行状态
gh run list --workflow=todo-trigger-codex.yml

# 实时查看 workflow 日志
gh run watch

# 查看特定运行的详细信息
gh run view <run-id>

# 查看失败的步骤
gh run view <run-id> --log-failed
```

**示例输出：**
```
STATUS  NAME                              WORKFLOW                    BRANCH  EVENT  ID
✓       Update todo.md                    Todo Changed - Trigger...   main    push   123456789
✓       feat: add user login              PR Quality Check            pr-1    pull   123456788
```

### 方式 3: 浏览器通知（可选）

启用 GitHub 通知：

```
Settings → Notifications → Actions
☑️ Send notifications for failed workflows
☑️ Send notifications on GitHub
```

---

## 2️⃣ Codex Issue 监控

### 查看 Codex 创建的任务 Issue

**访问地址：**
```
https://github.com/yjp1510586926/yjp-agent/issues
```

**筛选 Codex 任务：**
1. 点击 **"Labels"** 下拉菜单
2. 选择 **"codex-task"** 标签
3. 看到所有 Codex 任务

**Issue 内容包含：**
- 📋 任务详情摘要
- 🔗 todo.md 文件链接
- 📝 开发指南和规范
- ⏰ 创建时间和触发者

**状态判断：**
- **Issue 已创建** ✅ → Codex 已收到任务通知
- **Issue 未创建** ❌ → 检查 GitHub Actions 是否成功

**命令行查看：**
```bash
# 查看所有 Issues
gh issue list

# 查看 codex-task 标签的 Issues
gh issue list --label "codex-task"

# 查看特定 Issue 详情
gh issue view <issue-number>
```

---

## 3️⃣ Codex 开发进度监控

### Pull Request 监控

**访问地址：**
```
https://github.com/yjp1510586926/yjp-agent/pulls
```

**查看进度：**

#### 阶段 1: 等待 Codex 创建 PR
**时间**: 提交后 10-30 分钟

**检查方式：**
```
Pull requests 标签
→ 如果看到新的 PR 标题包含任务名称
→ Codex 已完成开发并提交 PR
```

**PR 标题格式：**
```
feat: 实现用户登录功能 (#1)
fix: 修复用户注册bug (#2)
```

#### 阶段 2: 查看 PR 详情

**点击 PR 可以看到：**

1. **Files changed**（代码变更）
   ```
   点击 "Files changed" 标签
   查看 Codex 编写的代码：
   - server/src/ 后端代码
   - client/src/ 前端代码
   - 测试文件
   ```

2. **Commits**（提交历史）
   ```
   点击 "Commits" 标签
   查看 Codex 的提交记录
   ```

3. **Checks**（自动化检查状态）
   ```
   在 PR 页面下方看到：
   - ✅ code-quality - 代码质量检查
   - ✅ type-check - TypeScript 检查
   - ✅ unit-tests - 单元测试
   - ✅ build-test - 构建测试
   - ✅ security-scan - 安全扫描
   ```

**命令行查看：**
```bash
# 查看所有 PR
gh pr list

# 查看特定 PR 详情
gh pr view <pr-number>

# 查看 PR 的检查状态
gh pr checks <pr-number>

# 查看 PR diff
gh pr diff <pr-number>
```

---

## 4️⃣ 自动化检查监控

### 查看 PR 检查状态

**实时监控：**

#### 在 PR 页面底部：

```
All checks have passed / Some checks failed

展开可以看到：

✅ code-quality (ESLint)
   ├─ Lint server code
   └─ Lint client code

✅ type-check (TypeScript)
   ├─ Type check server
   └─ Type check client

✅ unit-tests (Jest)
   ├─ Run server tests
   └─ Run client tests

✅ build-test (Build)
   ├─ Build server
   └─ Build client

✅ security-scan
   ├─ Run npm audit
   └─ Check for secrets
```

**点击 "Details" 查看详细日志**

#### 命令行实时监控：

```bash
# 监控 PR 检查（自动刷新）
gh pr checks <pr-number> --watch

# 示例输出：
# NAME              STATUS  CONCLUSION  TITLE
# code-quality      ✓       success     Lint passed
# type-check        ✓       success     Type check passed
# unit-tests        ✓       success     All tests passed (42 tests)
# build-test        ✓       success     Build successful
# security-scan     ✓       success     No vulnerabilities found
```

---

## 5️⃣ Claude 审查监控

### 查看 Claude 的审查结果

**在 PR 的 "Conversation" 标签下：**

#### 审查评论示例：

```markdown
## 🤖 Claude Code Review Request

您的 PR 已触发 Claude 自动代码审查。

### 📊 PR 统计
- 文件变更: 8
- 新增行数: 245
- 删除行数: 12

### ✅ 自动化检查
- 所有检查通过: true

### 🔍 Claude 审查中...
...
```

**几分钟后，Claude 会发布审查结果：**

```markdown
## ✅ Claude Code Review Result

**审查状态**: 审查通过

### 审查详情
- ✅ 代码质量：遵循项目规范
- ✅ 安全性：无安全漏洞
- ✅ 性能：无明显性能问题
- ✅ 测试：覆盖率 85%
- ✅ 架构：结构合理

**可以合并** ✨
```

**或者需要修改：**

```markdown
## ❌ Claude Code Review Result

**审查状态**: 需要修改

### 🔧 需要修改的问题
1. Lint 错误 (server/src/auth/auth.service.ts:23)
2. 测试失败 (server/test/auth.service.spec.ts)
...
```

**命令行查看：**
```bash
# 查看 PR 的所有评论
gh pr view <pr-number> --comments

# 查看 PR 的审查状态
gh pr view <pr-number> --json reviews
```

---

## 📊 完整监控时间线

### 典型的完整流程：

```
00:00 - 你 git push todo.md
   ↓
00:01 - GitHub Actions 开始运行
   📍 查看: Actions 标签，看到黄色转圈

00:02 - Codex Issue 创建完成
   📍 查看: Issues 标签，label: codex-task

00:02 - 等待 Codex 开发...
   📍 此时：可以喝杯咖啡 ☕
   📍 Codex 在云端工作，无法直接监控

00:15 - Codex 创建 PR
   📍 查看: Pull requests 标签，看到新 PR

00:16 - 自动化检查开始
   📍 查看: PR 页面底部，Checks 部分
   📍 状态: 黄色转圈（运行中）

00:21 - 自动化检查完成
   📍 状态: 全部绿色对勾 ✅

00:22 - Claude 审查开始
   📍 查看: PR Conversation，Claude 发布评论

00:24 - Claude 审查完成
   📍 查看: PR Conversation，Claude 发布审查结果

00:24+ - 等待人工确认合并
   📍 你可以点击 "Merge pull request"
```

---

## 🔔 主动通知设置

### GitHub 邮件通知

**配置步骤：**
```
1. 访问 https://github.com/settings/notifications
2. 配置通知选项：
   ☑️ Email
   ☑️ Actions
   ☑️ Pull requests
   ☑️ Issues
```

**你会收到邮件：**
- ✉️ Codex Issue 创建时
- ✉️ Codex 创建 PR 时
- ✉️ 自动化检查完成时
- ✉️ Claude 审查完成时

### GitHub Mobile App

**安装 GitHub App：**
- 📱 iOS: App Store 搜索 "GitHub"
- 📱 Android: Google Play 搜索 "GitHub"

**实时推送通知：**
- 📲 PR 创建
- 📲 检查完成
- 📲 审查评论
- 📲 合并请求

### Webhook 通知（高级）

**配置到 Slack/Discord/钉钉：**

```
Settings → Webhooks → Add webhook

Payload URL: https://your-webhook-url
Events:
  ☑️ Issues
  ☑️ Pull requests
  ☑️ Workflow runs
```

---

## 🛠️ 监控脚本（可选）

### 创建自动监控脚本

```bash
#!/bin/bash
# monitor-ai-workflow.sh

echo "🔍 监控 AI 工作流..."

# 1. 检查最新的 todo trigger workflow
echo "\n📋 1. 检查 todo.md 触发器..."
gh run list --workflow=todo-trigger-codex.yml --limit 1

# 2. 检查 Codex Issues
echo "\n📌 2. 检查 Codex 任务..."
gh issue list --label "codex-task" --limit 3

# 3. 检查最新的 PR
echo "\n🔄 3. 检查 Pull Requests..."
gh pr list --limit 5

# 4. 如果有 PR，检查其状态
PR_NUMBER=$(gh pr list --limit 1 --json number --jq '.[0].number')
if [ -n "$PR_NUMBER" ]; then
  echo "\n✅ 4. 检查 PR #$PR_NUMBER 的检查状态..."
  gh pr checks $PR_NUMBER
fi

echo "\n✨ 监控完成！"
```

**使用方法：**
```bash
# 赋予执行权限
chmod +x monitor-ai-workflow.sh

# 运行监控
./monitor-ai-workflow.sh

# 或设置定时监控（每 5 分钟）
watch -n 300 ./monitor-ai-workflow.sh
```

---

## 📱 快速检查清单

提交 `todo.md` 后，按顺序检查：

### ☑️ 1 分钟后：
```bash
□ GitHub Actions 运行了吗？
  → https://github.com/yjp1510586926/yjp-agent/actions
  → 看到 "Todo Changed - Trigger Codex" ✅

□ Codex Issue 创建了吗？
  → https://github.com/yjp1510586926/yjp-agent/issues
  → 看到 label: codex-task ✅
```

### ☑️ 15-30 分钟后：
```bash
□ Codex 创建 PR 了吗？
  → https://github.com/yjp1510586926/yjp-agent/pulls
  → 看到新的 PR ✅
```

### ☑️ 20-35 分钟后：
```bash
□ 自动化检查完成了吗？
  → 打开 PR 页面
  → 底部 Checks 全部 ✅

□ Claude 审查完成了吗？
  → PR Conversation 标签
  → 看到 Claude 的审查评论 ✅
```

### ☑️ 随时：
```bash
□ 有失败吗？
  → Actions 有 ❌
  → PR Checks 有 ❌
  → Claude 评论说 "需要修改"

  → 查看日志找原因
  → Codex 会自动修复（如果配置了）
```

---

## 🚨 常见状态和含义

### GitHub Actions 状态

| 图标 | 状态 | 含义 |
|------|------|------|
| 🟡 | In progress | 正在运行 |
| ✅ | Success | 运行成功 |
| ❌ | Failure | 运行失败 |
| ⚪ | Skipped | 跳过执行 |
| 🔵 | Queued | 等待执行 |

### PR Checks 状态

| 状态 | 含义 | 行动 |
|------|------|------|
| ✅ All checks passed | 所有检查通过 | 可以继续审查 |
| ⏳ Checks in progress | 检查进行中 | 等待完成 |
| ❌ Some checks failed | 有检查失败 | 查看失败原因 |
| ⚠️ Required checks missing | 缺少必需检查 | 等待触发 |

### Claude 审查状态

| 决策 | 含义 | 下一步 |
|------|------|--------|
| ✅ APPROVE | 审查通过 | 可以合并 |
| 💬 COMMENT | 有建议 | 考虑改进 |
| ❌ REQUEST_CHANGES | 需要修改 | 等待 Codex 修改 |

---

## 💡 监控最佳实践

### 1. 第一次提交时
- ✅ 保持 GitHub Actions 页面打开
- ✅ 观察每个步骤的执行
- ✅ 熟悉整个流程

### 2. 日常使用时
- ✅ 提交后等待邮件通知
- ✅ 收到通知后再查看详情
- ✅ 使用 GitHub Mobile App 接收推送

### 3. 出现问题时
- ✅ 立即查看 Actions 日志
- ✅ 查看失败的步骤详情
- ✅ 根据错误信息修复

### 4. 性能优化
- ✅ 使用 GitHub CLI 快速查询
- ✅ 设置监控脚本定时运行
- ✅ 关注关键指标，忽略细节

---

## 🎯 总结

**你可以通过以下方式实时监控 AI 工作：**

1. **GitHub Actions** - 看 workflow 运行状态
2. **Issues** - 看 Codex 任务创建
3. **Pull Requests** - 看 Codex 开发进度
4. **PR Checks** - 看自动化检查状态
5. **PR Comments** - 看 Claude 审查结果

**推荐监控方式：**
- 🌟 **新手**：GitHub 网页 + 邮件通知
- 🌟 **日常**：GitHub Mobile App 推送
- 🌟 **高级**：GitHub CLI + 监控脚本

**关键链接（收藏）：**
```
Actions:  https://github.com/yjp1510586926/yjp-agent/actions
Issues:   https://github.com/yjp1510586926/yjp-agent/issues?q=label:codex-task
PRs:      https://github.com/yjp1510586926/yjp-agent/pulls
```

---

**🔍 现在你可以实时掌握 AI 的工作进度了！**
