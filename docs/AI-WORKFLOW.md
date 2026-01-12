# 🤖 AI 驱动开发工作流指南

## 工作流概览

```
PRD/设计稿 → Claude 生成计划 → Codex 开发 → 提交 PR → Claude 审查 → 合并主分支
   (输入)      (架构师)         (编码)      (提交)     (技术总监)    (发布)
```

## 角色分工

### 👔 Claude - 技术总监/架构师
- ✅ 分析 PRD 和设计稿
- ✅ 制定开发计划和技术方案
- ✅ 定义 API 接口和数据结构
- ✅ 代码审查（Code Review）
- ✅ 质量把控和架构决策
- ✅ 部署前检查

### 💻 Codex - 开发工程师
- ✅ 根据计划编写具体实现代码
- ✅ 实现组件和功能
- ✅ 编写单元测试
- ✅ 修复 bug 和完善细节
- ✅ 按照规范提交代码

---

## 📋 完整工作流程

### 阶段 1: 需求分析与规划（Claude）

#### 1.1 创建 GitHub Issue
在 GitHub 仓库中创建 Issue，填写需求：

**Issue 标题格式：** `[Feature] 功能名称` 或 `[Bug] 问题描述`

**Issue 内容模板：**
```markdown
## 📝 PRD 需求描述
（粘贴产品需求文档）

## 🎨 设计稿
（粘贴 Figma/设计图链接或截图）

## ⚡ 期望功能
- [ ] 功能点 1
- [ ] 功能点 2
- [ ] 功能点 3

## 📌 技术要求
- 技术栈：React / NestJS
- 性能要求：...
- 其他要求：...
```

#### 1.2 使用 Claude 生成开发计划

在 Claude Code CLI 中执行：

```bash
# 进入项目目录
cd /path/to/yjp-agent

# 启动 Claude Code
claude

# 在 Claude 中输入
请根据 GitHub Issue #123 的需求，生成详细的开发计划，包括：
1. 技术方案设计
2. API 接口定义
3. 数据库设计（如需要）
4. 前端组件结构
5. 开发任务分解
6. 测试计划
```

Claude 会生成：
- `docs/plans/feature-xxx-plan.md` - 开发计划
- `docs/api/feature-xxx-api.md` - API 接口定义
- `docs/tasks/feature-xxx-tasks.md` - 任务清单

---

### 阶段 2: 代码实现（Codex）

#### 2.1 创建开发分支

```bash
git checkout -b feature/issue-123-功能名称
```

#### 2.2 使用 Codex 编写代码

**推荐工具：**
- **Cursor**（推荐）: AI 驱动的 IDE，内置 Codex
- **GitHub Copilot**: VS Code 插件
- **Codeium**: 免费替代方案

**开发步骤：**

1. 打开 Claude 生成的计划文档
2. 在 Cursor/VS Code 中按照计划逐步实现
3. 使用 AI 辅助：
   ```
   Copilot: 根据 docs/plans/xxx.md 实现用户登录功能
   ```

4. 编写测试用例：
   ```
   Copilot: 为 UserService 编写单元测试
   ```

#### 2.3 本地测试

```bash
# 前端测试
cd client && npm test

# 后端测试
cd server && npm test

# 本地运行
npm run dev:server  # 启动后端
npm run dev:client  # 启动前端
```

---

### 阶段 3: 提交 PR（Codex）

#### 3.1 提交代码

```bash
# 添加修改的文件
git add .

# 提交（使用规范的 commit message）
git commit -m "feat: 实现用户登录功能 (#123)

- 添加登录 API 接口
- 实现 JWT 认证
- 添加前端登录表单
- 编写单元测试"

# 推送到远程
git push origin feature/issue-123-功能名称
```

#### 3.2 创建 Pull Request

在 GitHub 上创建 PR，会自动填充模板（见下方 PR 模板）

**关键内容：**
- ✅ 关联 Issue：`Closes #123`
- ✅ 描述修改内容
- ✅ 添加测试截图/视频
- ✅ 填写测试清单

---

### 阶段 4: 代码审查（Claude）

#### 4.1 自动化检查

PR 创建后，GitHub Actions 会自动运行：
- ✅ 代码格式检查（ESLint/Prettier）
- ✅ TypeScript 类型检查
- ✅ 单元测试
- ✅ 构建测试

#### 4.2 Claude 代码审查

在 Claude Code CLI 中执行：

```bash
# 方式 1: 使用自定义命令
/code-review

# 方式 2: 手动审查
请审查 PR #456 的代码，检查：
1. 代码质量和规范
2. 安全性问题
3. 性能优化建议
4. 架构设计是否合理
5. 测试覆盖率
```

Claude 会：
- 🔍 分析代码变更
- 📝 提供详细的审查意见
- 🐛 发现潜在问题
- 💡 给出优化建议

#### 4.3 反馈修改

如果 Claude 发现问题：
1. 在 PR 中添加 Review Comments
2. Codex 根据建议修改代码
3. 重新提交，重复审查流程

---

### 阶段 5: 合并与部署（Claude）

#### 5.1 部署前检查

```bash
# 使用 Claude 进行部署前检查
/deploy-check

# 或手动检查
请进行部署前检查：
1. 所有测试是否通过
2. 是否有安全漏洞
3. 环境变量配置
4. 数据库迁移脚本
5. 回滚方案
```

#### 5.2 合并 PR

✅ 所有检查通过后，在 GitHub 上合并 PR

#### 5.3 自动部署

GitHub Actions 会自动触发部署流程：
- 构建生产版本
- 运行集成测试
- 部署到服务器

---

## 🛠️ 工具配置

### 1. Codex 配置（Cursor 推荐）

**安装 Cursor：**
```bash
# 下载：https://cursor.sh/
# 配置 AI 模型为 GPT-4 或 Claude
```

**Cursor 配置文件（`.cursorrules`）：**
```
# 项目规范
- 使用 TypeScript 严格模式
- 遵循 Airbnb 代码规范
- 函数必须添加 JSDoc 注释
- 优先使用函数式编程
- 组件使用 React Hooks

# 提交规范
- 使用 Conventional Commits
- feat: 新功能
- fix: 修复
- docs: 文档
- style: 格式
- refactor: 重构
- test: 测试
- chore: 构建/工具
```

### 2. Claude Code 配置

已配置的自定义命令（在 `.claude/commands/` 目录）：
- `/code-review` - 代码审查
- `/deploy-check` - 部署前检查
- `/test` - 运行测试
- `/refactor` - 重构建议
- `/explain` - 代码解释

### 3. GitHub 配置

**Branch Protection Rules（分支保护）：**
在 GitHub 仓库设置中配置：
1. Settings → Branches → Add rule
2. Branch name pattern: `main`
3. 启用规则：
   - ✅ Require pull request before merging
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date
   - ✅ Require linear history

---

## 📊 工作流示例

### 实际案例：实现用户登录功能

#### 第 1 天：需求分析（Claude）
```bash
# 1. 用户在 GitHub 创建 Issue #123
# 2. Claude 分析需求生成计划

claude> 请分析 Issue #123 并生成开发计划

# 输出：
# - docs/plans/user-login-plan.md
# - docs/api/user-login-api.md
# - docs/tasks/user-login-tasks.md
```

#### 第 2-3 天：代码实现（Codex）
```bash
# 1. 创建分支
git checkout -b feature/issue-123-user-login

# 2. 在 Cursor 中实现
# - server/src/auth/auth.controller.ts
# - server/src/auth/auth.service.ts
# - client/src/pages/Login.tsx
# - client/src/services/auth.service.ts

# 3. 编写测试
# - server/test/auth.service.spec.ts
# - client/src/pages/__tests__/Login.test.tsx

# 4. 本地测试通过
npm run dev:server
npm run dev:client
npm test
```

#### 第 4 天：提交审查（Codex → Claude）
```bash
# 1. 提交代码
git commit -m "feat: 实现用户登录功能 (#123)"
git push origin feature/issue-123-user-login

# 2. 创建 PR
# 3. 自动化测试运行
# 4. Claude 进行代码审查

claude> /code-review

# Claude 反馈：
# ✅ 代码结构清晰
# ⚠️ 建议添加登录失败次数限制
# ⚠️ 建议添加 CSRF 保护
```

#### 第 5 天：修改完善（Codex）
```bash
# 1. 根据 Claude 建议修改代码
# 2. 重新提交
git commit -m "fix: 添加登录失败限制和 CSRF 保护"
git push

# 3. Claude 再次审查
claude> /code-review
# ✅ 审查通过
```

#### 第 6 天：部署上线（Claude）
```bash
# 1. 部署前检查
claude> /deploy-check
# ✅ 所有检查通过

# 2. 合并 PR
# 3. 自动部署到生产环境
# 4. 监控日志和性能指标
```

---

## 🎯 最佳实践

### Claude 最佳实践
1. **明确角色：** 让 Claude 专注于架构、设计、审查
2. **提供上下文：** 给 Claude 完整的 PRD 和设计稿
3. **分步执行：** 复杂任务拆分成多个步骤
4. **保存计划：** 将 Claude 的输出保存为文档供 Codex 参考

### Codex 最佳实践
1. **参考计划：** 严格按照 Claude 生成的计划实现
2. **小步提交：** 频繁提交代码，避免大改动
3. **编写测试：** 每个功能都要有对应测试
4. **遵循规范：** 使用项目定义的代码规范

### 协作最佳实践
1. **Issue 驱动：** 所有开发从 Issue 开始
2. **文档先行：** Claude 先生成文档，Codex 再编码
3. **频繁审查：** 小功能也要经过代码审查
4. **自动化优先：** 能自动化的检查都用 CI/CD

---

## 🔧 常见问题

### Q1: Codex 不理解 Claude 的计划怎么办？
**A:** 在 Claude 计划中添加更详细的代码示例和伪代码

### Q2: Claude 审查太严格，开发效率低？
**A:** 调整审查粒度，简单功能可以跳过人工审查，只用自动化检查

### Q3: 如何确保 Codex 生成的代码质量？
**A:**
- 配置完善的 ESLint/Prettier 规则
- 设置高测试覆盖率要求（>80%）
- Claude 定期做代码质量审计

### Q4: 两个 AI 的成本如何控制？
**A:**
- Codex: 使用 Cursor 订阅（$20/月）或 GitHub Copilot（$10/月）
- Claude: 使用 Claude Pro（$20/月）或 API（按需付费）
- 总成本约 $40-50/月

---

## 📚 相关文档

- [项目规范](../CLAUDE.md)
- [API 接口规范](./API-STANDARDS.md)
- [测试规范](./TESTING-GUIDE.md)
- [部署流程](./DEPLOYMENT.md)

---

## 🚀 快速开始

```bash
# 1. Clone 项目
git clone https://github.com/yjp1510586926/yjp-agent.git
cd yjp-agent

# 2. 安装依赖
npm run install:all

# 3. 启动开发环境
npm run dev:server  # 终端 1
npm run dev:client  # 终端 2

# 4. 开始第一个功能开发
# - 创建 GitHub Issue
# - 使用 Claude 生成计划
# - 使用 Codex 实现代码
# - 提交 PR 等待审查
```

---

**🎉 现在你拥有了一个完整的 AI 驱动开发工作流！**
