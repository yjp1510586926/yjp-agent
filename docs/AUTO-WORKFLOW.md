# 🤖 全自动化开发工作流

> **Codex 执行 + Claude 把控**的完全自动化流程

本文档描述基于 `todo.md` 文件驱动的全自动化开发工作流。

---

## 🎯 工作流概览

```
┌─────────────────────────────────────────────────────────────────┐
│                      全自动化开发流程                              │
└─────────────────────────────────────────────────────────────────┘

1. 📝 添加任务到 todo.md
   └─> 详细描述需求、API、验收标准
   └─> 提交并 push 到 GitHub

2. 🔔 自动触发 Codex
   └─> GitHub Actions 检测 todo.md 变化
   └─> 创建通知 Issue
   └─> 触发 Codex webhook（可选）

3. 💻 Codex 自动开发
   └─> 读取 todo.md 任务
   └─> 创建开发分支
   └─> 实现代码功能
   └─> 编写测试用例
   └─> 提交 PR

4. ✅ 自动化质量检查
   └─> 代码格式检查（ESLint）
   └─> 类型检查（TypeScript）
   └─> 单元测试
   └─> 构建测试
   └─> 安全扫描

5. 🔍 Claude 自动审查
   └─> 分析代码变更
   └─> 检查代码质量
   └─> 检查安全性
   └─> 评估性能
   └─> 做出决策

6. 🔄 自动反馈循环
   ├─> ✅ 通过 → 可以合并
   └─> ❌ 不通过 → Codex 修改 → 重新提交

7. 🚀 合并部署
   └─> 人工确认后合并
   └─> 自动部署
   └─> 更新 todo.md 状态
```

---

## 📋 详细流程说明

### 阶段 1: 添加开发任务

#### 1.1 编辑 `todo.md`

在项目根目录的 `todo.md` 文件中添加新任务：

```markdown
### 任务 1: 实现用户登录功能

**优先级**: 🔴 高

**状态**:
- [x] 待开发
- [ ] 开发中
- [ ] 待审查
- [ ] 已完成

**需求描述**:
作为用户，我希望能够使用邮箱和密码登录系统...

**前端需求**:
- [ ] 创建 Login.tsx 页面
- [ ] 实现表单验证
...

**后端需求**:
- [ ] 实现 POST /api/auth/login
- [ ] JWT 认证
...

**验收标准**:
- [ ] 能够正确登录
- [ ] 测试覆盖率 > 80%
...
```

**关键点：**
- ✅ 需求要详细（越详细，Codex 实现越准确）
- ✅ 明确前后端需求
- ✅ 提供 API 接口设计
- ✅ 列出验收标准

#### 1.2 提交到 Git

```bash
git add todo.md
git commit -m "docs: 添加用户登录功能开发任务"
git push origin main
```

---

### 阶段 2: 自动触发 Codex

#### 2.1 GitHub Actions 检测变化

当 `todo.md` 被推送到 `main` 或 `develop` 分支时：

1. **Workflow 触发**
   - 文件：`.github/workflows/todo-trigger-codex.yml`
   - 触发条件：`todo.md` 有变化

2. **检测新任务**
   ```bash
   # 自动提取标记为"待开发"的任务
   # 解析任务详情
   ```

3. **创建通知 Issue**
   - 标题：`🤖 [Codex] 新的开发任务`
   - 标签：`codex-task`, `auto-generated`
   - 内容：包含任务详情和开发指南

4. **触发 Webhook（可选）**
   - 如果配置了 Codex Cloud webhook
   - 发送通知到 Codex 平台

#### 2.2 Codex 接收任务

**方式 A: 通过 GitHub Issue**
- Codex 监听 GitHub Issues
- 读取标记为 `codex-task` 的 Issue
- 提取任务信息

**方式 B: 通过 Webhook**
- Codex Cloud 接收 webhook 通知
- 自动拉取最新的 `todo.md`
- 开始任务分析

---

### 阶段 3: Codex 自动开发

#### 3.1 Codex 开发流程

```
1. 读取任务 (todo.md)
   └─> 分析需求
   └─> 提取关键信息

2. 创建开发分支
   └─> 分支名：feature/task-[N]-[description]
   └─> 例如：feature/task-1-user-login

3. 实现代码
   └─> 后端实现（NestJS）
      ├─> Controller
      ├─> Service
      ├─> DTO
      └─> Entity
   └─> 前端实现（React）
      ├─> 页面组件
      ├─> API 服务
      ├─> 状态管理
      └─> 样式

4. 编写测试
   └─> 后端测试
      ├─> 单元测试
      └─> 集成测试
   └─> 前端测试
      ├─> 组件测试
      └─> E2E 测试

5. 本地测试
   └─> 运行所有测试
   └─> 确保覆盖率 > 80%
   └─> 修复所有错误

6. 提交代码
   └─> Commit message: "feat: 实现用户登录功能 (#1)"
   └─> Push 到远程分支

7. 创建 PR
   └─> 标题："feat: 实现用户登录功能"
   └─> 填写 PR 模板
   └─> 关联 Issue
```

#### 3.2 Codex 提示词示例

Codex 会使用类似以下的提示词来生成代码：

**后端代码：**
```
根据 todo.md 中的任务 1：

在 server/src/modules/ 创建 auth 模块，实现用户登录功能：

1. auth.controller.ts
   - POST /api/auth/login
   - 接收参数：email, password
   - 返回：{ success, data: { token, user } }

2. auth.service.ts
   - 验证用户邮箱和密码
   - 使用 bcrypt 验证密码
   - 生成 JWT token
   - 错误处理

3. dto/login.dto.ts
   - 使用 class-validator 验证
   - email: IsEmail
   - password: MinLength(6)

4. 单元测试
   - 测试正常登录
   - 测试密码错误
   - 测试用户不存在
   - 覆盖率 > 80%

遵循 CLAUDE.md 中的规范。
```

**前端代码：**
```
根据 todo.md 中的任务 1：

在 client/src/pages/ 创建登录页面：

1. Login.tsx
   - 邮箱和密码输入框
   - 表单验证（必填、格式）
   - 提交登录请求
   - 加载状态
   - 错误提示
   - 登录成功后跳转

2. services/auth.service.ts
   - login(email, password) 方法
   - 调用 POST /api/auth/login
   - 保存 token 到 localStorage

3. 组件测试
   - 测试表单验证
   - 测试提交流程
   - 测试错误处理

使用 React Hooks，TypeScript 严格模式。
```

---

### 阶段 4: 自动化质量检查

#### 4.1 PR 创建时触发

当 Codex 创建 PR 后，自动运行检查：

**Workflow**: `.github/workflows/pr-check.yml`

**检查项目：**

1. **代码格式检查**
   ```bash
   cd server && npm run lint
   cd client && npm run lint
   ```

2. **TypeScript 类型检查**
   ```bash
   cd server && npx tsc --noEmit
   cd client && npx tsc --noEmit
   ```

3. **单元测试**
   ```bash
   cd server && npm test -- --coverage
   cd client && npm test -- --coverage --watchAll=false
   ```

4. **构建测试**
   ```bash
   npm run build:server
   npm run build:client
   ```

5. **安全扫描**
   ```bash
   npm audit --audit-level=high
   ```

#### 4.2 检查结果

- ✅ **全部通过** → 进入 Claude 审查阶段
- ❌ **有失败** → 自动评论说明问题，等待 Codex 修复

---

### 阶段 5: Claude 自动审查

#### 5.1 审查触发

**Workflow**: `.github/workflows/claude-auto-review.yml`

**触发条件：**
- PR 被创建（opened）
- PR 有新提交（synchronize）
- PR 被重新打开（reopened）

#### 5.2 审查流程

```
1. 获取 PR 信息
   └─> PR 编号、标题、作者
   └─> 变更文件列表
   └─> 代码差异

2. 分析代码变更
   └─> 统计新增/删除行数
   └─> 识别变更的文件类型
   └─> 检查是否是大型 PR

3. 检查自动化测试结果
   └─> Lint 是否通过
   └─> 类型检查是否通过
   └─> 测试是否通过
   └─> 构建是否成功

4. 代码质量审查
   └─> 代码规范性
   └─> 安全性检查
   └─> 性能评估
   └─> 测试覆盖率

5. 做出决策
   ├─> ✅ APPROVE: 通过
   ├─> 💬 COMMENT: 有建议
   └─> ❌ REQUEST_CHANGES: 需要修改
```

#### 5.3 审查标准

**自动拒绝（REQUEST_CHANGES）条件：**
- ❌ 自动化检查未通过
- ❌ 测试覆盖率 < 80%
- ❌ 存在明显的安全漏洞
- ❌ 代码质量严重不达标

**需要建议（COMMENT）条件：**
- ⚠️ PR 规模过大（>50 文件或 >1000 行）
- ⚠️ 有性能优化空间
- ⚠️ 代码可读性可改进
- ⚠️ 缺少部分注释

**自动通过（APPROVE）条件：**
- ✅ 所有自动化检查通过
- ✅ 代码质量良好
- ✅ 测试覆盖率 >= 80%
- ✅ 无安全问题
- ✅ 符合项目规范

#### 5.4 审查反馈

Claude 会在 PR 中添加评论：

**示例 - 通过：**
```markdown
## ✅ Claude Code Review Result

**审查状态**: 审查通过

**原因**: 代码质量良好，所有检查通过

### 审查详情

- ✅ 代码规范：遵循项目规范
- ✅ 安全性：无安全漏洞
- ✅ 性能：无明显性能问题
- ✅ 测试：覆盖率 85%
- ✅ 架构：结构合理

**可以合并** ✨
```

**示例 - 需要修改：**
```markdown
## ❌ Claude Code Review Result

**审查状态**: 需要修改

**原因**: 自动化检查未通过

### 🔧 需要修改的问题

1. **Lint 错误** (server/src/auth/auth.service.ts:23)
   - 未使用的变量 `unusedVar`
   - 修复：删除未使用的变量

2. **测试失败** (server/test/auth.service.spec.ts)
   - `login with invalid password` 测试失败
   - 修复：检查密码验证逻辑

3. **类型错误** (client/src/pages/Login.tsx:45)
   - `loginData` 类型不匹配
   - 修复：添加正确的类型定义

### 📝 修复步骤

1. 本地修复上述问题
2. 运行 `npm run lint:fix`
3. 运行 `npm test` 确保所有测试通过
4. 重新提交并推送
```

---

### 阶段 6: 自动反馈循环

#### 6.1 如果审查不通过

```
1. Claude 在 PR 中评论具体问题
2. 给 PR 添加 `needs-changes` 标签
3. Codex 检测到反馈
4. Codex 分析问题
5. Codex 修改代码
6. Codex 重新提交
7. 重新触发自动化检查和 Claude 审查
```

#### 6.2 Codex 修复流程

Codex 会根据 Claude 的反馈自动修复：

```
1. 读取 PR 评论中的问题列表
2. 分析每个问题
3. 修改相应的代码
4. 重新运行测试
5. 确保所有问题都已修复
6. 提交修复：
   git commit -m "fix: 修复 Claude 审查反馈的问题"
   git push
```

#### 6.3 循环终止条件

- ✅ **成功**：Claude 审查通过
- ❌ **失败**：超过 3 次循环仍未通过，转人工处理

---

### 阶段 7: 合并与部署

#### 7.1 合并决策

**自动合并条件（可选配置）：**
- ✅ 所有自动化检查通过
- ✅ Claude 审查通过（APPROVE）
- ✅ PR 规模合理（< 500 行）
- ✅ 无冲突

**默认行为（推荐）：**
- 需要人工最终确认
- 点击 "Merge pull request" 按钮

#### 7.2 部署流程

PR 合并后自动触发部署：

```
1. 合并到 main 分支
2. GitHub Actions 触发部署 workflow
3. 构建生产版本
4. 运行集成测试
5. 部署到服务器
6. 验证部署成功
```

#### 7.3 更新 todo.md

合并后自动或手动更新任务状态：

```markdown
### ~~任务 1: 实现用户登录功能~~

**优先级**: 🔴 高

**状态**:
- [ ] 待开发
- [ ] 开发中
- [ ] 待审查
- [x] 已完成  ✅

**完成时间**: 2024-01-12
**PR**: #123
```

---

## 🔧 配置说明

### 必需配置

#### 1. GitHub Repository Settings

**Secrets（如需要）：**
```
Settings → Secrets and variables → Actions

- CODEX_TOKEN: Codex API token（如果使用 webhook）
- CLAUDE_API_KEY: Claude API key（如果使用 API）
```

**Branch Protection Rules：**
```
Settings → Branches → Add rule

Branch name pattern: main

保护规则：
☑️ Require pull request before merging
☑️ Require status checks to pass before merging
   - code-quality
   - type-check
   - unit-tests
   - build-test
☑️ Require branches to be up to date before merging
```

#### 2. GitHub Actions Workflows

已配置的 workflows：

1. **`todo-trigger-codex.yml`**
   - 监听 `todo.md` 变化
   - 创建 Codex 任务通知

2. **`pr-check.yml`**
   - 运行自动化质量检查
   - Lint、测试、构建

3. **`claude-auto-review.yml`**
   - Claude 自动代码审查
   - 做出合并决策

#### 3. Codex 配置

**Codex Cloud：**
```
1. 登录 Codex Cloud
2. 连接 GitHub 仓库
3. 配置 webhook（可选）
4. 设置监听 Issues 标签：codex-task
```

**Codex 监听设置：**
```json
{
  "repository": "yjp1510586926/yjp-agent",
  "watch": {
    "issues": {
      "labels": ["codex-task"]
    },
    "files": ["todo.md"]
  },
  "actions": {
    "on_new_task": "develop",
    "on_review_feedback": "fix_and_resubmit"
  }
}
```

---

## 📊 工作流监控

### 查看任务状态

```bash
# 查看 todo.md 中的任务
cat todo.md | grep "任务"

# 查看进行中的任务
cat todo.md | grep -A 10 "开发中"

# 查看已完成的任务
cat todo.md | grep -A 10 "已完成"
```

### 查看 GitHub Actions

```
仓库 → Actions 标签

可以看到：
- Todo trigger workflows
- PR check workflows
- Claude review workflows
```

### 查看 PR 状态

```
仓库 → Pull requests

筛选：
- Label: codex-task（Codex 创建的 PR）
- Label: needs-changes（需要修改的 PR）
- Label: approved（已通过审查的 PR）
```

---

## 💡 使用技巧

### 1. 任务描述要详细

**❌ 不好：**
```markdown
### 任务 1: 做个登录
**需求描述**: 做登录功能
```

**✅ 好：**
```markdown
### 任务 1: 实现用户登录功能

**需求描述**:
作为用户，我希望能够使用邮箱和密码登录...

**前端需求**:
- 创建 Login.tsx 页面
- 邮箱输入框（验证格式）
- 密码输入框（最小长度 6）
...

**后端需求**:
- POST /api/auth/login
- 验证用户密码（bcrypt）
- 生成 JWT token
...

**API 接口设计**:
POST /api/auth/login
请求：{ "email": "...", "password": "..." }
响应：{ "success": true, "data": { "token": "...", "user": {...} } }

**验收标准**:
- [ ] 能够正确登录
- [ ] 密码错误显示提示
- [ ] 测试覆盖率 > 80%
```

### 2. 一次添加一个任务

- 避免同时添加多个复杂任务
- 让 Codex 专注完成一个任务
- 任务完成后再添加下一个

### 3. 及时更新任务状态

```markdown
**状态**:
- [ ] 待开发
- [x] 开发中  ← Codex 开始工作时更新
- [ ] 待审查
- [ ] 已完成
```

### 4. 利用标签管理

在 GitHub Issues/PR 中使用标签：
- `codex-task` - Codex 的任务
- `needs-changes` - 需要修改
- `approved` - 已通过审查
- `urgent` - 紧急任务

### 5. 监控反馈循环

如果 Codex 多次修改仍未通过：
- 检查任务描述是否清晰
- 检查反馈是否准确
- 必要时人工介入

---

## 🔍 故障排查

### Codex 没有开始开发

**检查：**
1. `todo.md` 是否正确提交到 main/develop 分支
2. GitHub Actions 是否成功运行（查看 Actions 标签）
3. Codex Issue 是否创建（查看 Issues 标签）
4. Codex webhook 是否配置正确

**解决：**
```bash
# 重新推送 todo.md
git add todo.md
git commit --amend --no-edit
git push --force-with-lease

# 手动创建 Codex Issue
# 在 GitHub 创建 Issue，添加 codex-task 标签
```

### Claude 审查一直是 COMMENT 状态

**原因：**
- 可能需要人工审查
- 配置为不自动 APPROVE

**解决：**
```bash
# 在本地运行 Claude 审查
claude

# 输入
/code-review

# 或详细审查
请审查 PR #X 的代码，重点检查：
1. 代码质量
2. 安全性
3. 性能
```

### PR 检查失败

**检查日志：**
```
仓库 → Actions → 点击失败的 workflow → 查看日志
```

**常见问题：**
1. **Lint 失败**
   ```bash
   npm run lint:fix
   ```

2. **测试失败**
   ```bash
   npm test
   # 修复失败的测试
   ```

3. **类型错误**
   ```bash
   npx tsc --noEmit
   # 修复类型错误
   ```

### 自动化流程卡住

**重启流程：**
```bash
# 1. 关闭相关 PR
# 2. 删除相关分支
git push origin --delete feature/task-X-xxx

# 3. 修改 todo.md 任务描述
# 4. 重新提交触发流程
```

---

## 📈 工作流优化

### 性能优化

1. **并行运行检查**
   - Lint、测试、构建并行运行
   - 减少等待时间

2. **缓存依赖**
   - 使用 actions/cache 缓存 node_modules
   - 加快 workflow 运行速度

3. **增量检查**
   - 只检查变更的文件
   - 避免全量检查

### 成本优化

1. **使用 GitHub hosted runners**
   - 免费额度：2000 分钟/月
   - 监控使用量

2. **减少 workflow 触发频率**
   - 只在必要分支触发
   - 避免重复运行

3. **优化 Codex 调用**
   - 批量处理任务
   - 合理使用 API quota

---

## 📚 相关文档

- [todo.md 任务文件](../todo.md)
- [快速开始](./QUICK-START.md)
- [Codex 使用指南](./CODEX-GUIDE.md)
- [完整工作流](./AI-WORKFLOW.md)

---

## 🎉 总结

**全自动化工作流优势：**

1. ✅ **效率提升**
   - 自动化任务分配
   - 自动化代码实现
   - 自动化质量检查
   - 自动化代码审查

2. ✅ **质量保证**
   - 多重检查机制
   - Claude 把控质量
   - 反馈循环优化

3. ✅ **可追溯性**
   - todo.md 记录所有任务
   - GitHub 记录所有变更
   - 完整的审查历史

4. ✅ **灵活性**
   - 支持人工干预
   - 支持配置调整
   - 支持流程优化

**开始使用：**
1. 在 `todo.md` 中添加第一个任务
2. 提交并推送
3. 观察自动化流程运行
4. 享受 AI 驱动的开发体验！

---

*全自动化工作流配置完成！让 AI 为你工作吧！* 🚀
