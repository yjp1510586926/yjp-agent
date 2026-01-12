# 🚀 快速开始：AI 驱动开发工作流

## 5 分钟快速上手

### 前置要求

- ✅ **Claude Pro 账号** ($20/月) 或 Claude API
- ✅ **Cursor** ($20/月) 或 **GitHub Copilot** ($10/月)
- ✅ Node.js 18+
- ✅ Git
- ✅ GitHub 账号

---

## Step 1: 工具安装

### 1.1 安装 Claude Code CLI

```bash
# macOS/Linux
curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh

# 或使用 npm
npm install -g claude-code

# 验证安装
claude --version
```

### 1.2 配置 Claude Code

```bash
# 登录 Claude
claude auth login

# 进入项目目录
cd /path/to/yjp-agent

# 初始化（已配置好，跳过此步）
# claude init
```

### 1.3 安装 Codex 开发工具

**方式 1: Codex Cloud 网页版（推荐）**

1. 访问你的 Codex Cloud 平台
2. 登录账号
3. 导入项目：连接 GitHub 选择 `yjp-agent` 仓库
4. 开始开发

**方式 2: VS Code + Codex 插件**

```bash
# 在 VS Code 中安装 Codex 插件
Ctrl+P / Cmd+P
ext install codex-ai

# 配置 API Key（如需要）
```

**方式 3: 其他替代方案**

```bash
# Cursor（集成 AI 的编辑器）
# 访问 https://cursor.sh/

# GitHub Copilot
code --install-extension GitHub.copilot
```

**📖 详细使用指南**: [Codex 使用指南](./CODEX-GUIDE.md)

---

## Step 2: 项目初始化

### 2.1 安装依赖

```bash
# 在项目根目录
npm run install:all
```

### 2.2 启动开发环境

```bash
# 终端 1：启动后端
npm run dev:server

# 终端 2：启动前端
npm run dev:client
```

### 2.3 验证环境

- 前端：http://localhost:3001
- 后端：http://localhost:3000

---

## Step 3: 第一个功能开发

### 场景：实现一个用户登录功能

#### 3.1 创建 GitHub Issue

1. 访问 https://github.com/yjp1510586926/yjp-agent/issues
2. 点击 "New Issue"
3. 选择 "Feature Request" 模板
4. 填写内容：

```markdown
## 📝 PRD 需求描述
实现用户登录功能，支持邮箱密码登录

## ⚡ 期望功能清单
- [ ] 用户可以输入邮箱和密码
- [ ] 登录成功后跳转到首页
- [ ] 登录失败显示错误提示
- [ ] 支持记住登录状态

## 📌 技术要求
- 前端：React + TypeScript
- 后端：NestJS + JWT
- 数据库：用户表设计
```

5. 提交 Issue，假设 Issue 编号为 #123

---

#### 3.2 使用 Claude 生成开发计划

```bash
# 启动 Claude Code
claude

# 在 Claude 中输入
请分析 GitHub Issue #123 的需求，生成详细的开发计划
包括：
1. 技术方案设计
2. API 接口定义
3. 数据库设计
4. 前端组件结构
5. 开发任务清单
```

Claude 会自动：
- 📖 读取 Issue 内容
- 🔍 分析项目结构
- 📝 生成开发计划文档

生成的文件：
- `docs/plans/user-login-plan.md`
- `docs/api/user-login-api.md`

---

#### 3.3 使用 Codex 实现代码

**方式 A: 使用 Codex Cloud 网页版**

1. **创建开发分支**
   ```bash
   # 在 Codex Cloud 终端
   git checkout -b feature/issue-123-user-login
   ```

2. **打开计划文档**
   - 在 Codex Cloud 中打开 `docs/plans/user-login-plan.md`
   - 阅读计划和任务清单

3. **使用 AI 辅助开发**

   **后端实现 - 在 Codex 输入框中输入：**
   ```
   根据 docs/plans/user-login-plan.md 和 docs/api/user-login-api.md
   实现用户登录功能：
   1. 在 server/src/modules/ 创建 auth 模块
   2. 实现 login API 接口
   3. 实现 JWT 认证
   4. 添加 DTO 验证
   5. 编写单元测试
   ```

   **前端实现 - 在 Codex 输入框中输入：**
   ```
   根据 docs/plans/user-login-plan.md
   实现登录页面：
   1. 在 client/src/pages/ 创建 Login.tsx
   2. 实现表单和验证
   3. 集成登录 API
   4. 添加错误处理和加载状态
   5. 编写组件测试
   ```

4. **测试代码**
   ```bash
   # 在 Codex Cloud 终端
   cd server && npm test
   cd client && npm test

   # 启动开发服务器验证
   npm run dev:server
   npm run dev:client
   ```

**方式 B: 使用本地 VS Code + Codex 插件**

1. **创建分支并打开项目**
   ```bash
   git checkout -b feature/issue-123-user-login
   code .
   ```

2. **使用 Codex 插件**
   - 打开文件
   - 按快捷键唤起 Codex (Ctrl+Shift+A)
   - 输入上述提示词
   - 或者写注释让 Codex 自动补全

3. **本地测试**
   ```bash
   cd server && npm test
   cd client && npm test
   ```

**📖 详细 Codex 使用方法**: 参考 [Codex 使用指南](./CODEX-GUIDE.md)

---

#### 3.4 提交 PR

```bash
# 添加所有文件
git add .

# 提交（使用规范的 commit message）
git commit -m "feat: 实现用户登录功能 (#123)

- 添加 auth module 和 login API
- 实现 JWT 认证机制
- 创建登录页面和表单验证
- 添加单元测试和集成测试"

# 推送到远程
git push origin feature/issue-123-user-login
```

**在 GitHub 上创建 PR：**

1. 访问仓库页面
2. 点击 "Compare & pull request"
3. 填写 PR 模板（自动填充）
4. 提交 PR

**自动化检查启动：**
- ✅ 代码格式检查
- ✅ TypeScript 类型检查
- ✅ 单元测试
- ✅ 构建测试
- ✅ 安全扫描

---

#### 3.5 使用 Claude 进行代码审查

```bash
# 在 Claude Code CLI 中
claude

# 方式 1: 使用自定义命令
/code-review

# 方式 2: 手动审查
请审查 PR #XX 的代码，重点检查：
1. 代码质量和规范
2. 安全性（SQL注入、XSS等）
3. 性能优化建议
4. 测试覆盖率
```

Claude 会：
- 🔍 分析所有代码变更
- 📝 生成详细的审查报告
- 🐛 指出潜在问题
- 💡 提供优化建议

**如果有问题：**
1. Claude 在 PR 中添加评论
2. 返回 Cursor 修改代码
3. 重新提交并通过审查

---

#### 3.6 合并与部署

**部署前检查：**
```bash
# 在 Claude Code CLI 中
/deploy-check
```

**合并 PR：**
1. 所有检查通过 ✅
2. Claude 审查通过 ✅
3. 在 GitHub 上点击 "Merge pull request"
4. 自动部署（GitHub Actions）

**验证：**
- 访问生产环境
- 测试登录功能
- 检查日志和监控

---

## 常用命令速查

### Claude Code 命令

```bash
# 启动 Claude
claude

# 代码审查
/code-review

# 部署前检查
/deploy-check

# 运行测试
/test

# 代码重构建议
/refactor

# 代码解释
/explain
```

### Git 命令

```bash
# 创建分支
git checkout -b feature/issue-123-功能名

# 查看状态
git status

# 提交代码
git add .
git commit -m "feat: 功能描述 (#123)"

# 推送代码
git push origin feature/issue-123-功能名

# 同步主分支
git checkout main
git pull origin main
```

### 项目命令

```bash
# 安装依赖
npm run install:all

# 开发模式
npm run dev:server  # 后端
npm run dev:client  # 前端

# 运行测试
cd server && npm test
cd client && npm test

# 构建
npm run build:server
npm run build:client
```

---

## 工作流总结

```
┌─────────────────────────────────────────────────────────┐
│                     AI 驱动开发循环                        │
└─────────────────────────────────────────────────────────┘

1️⃣ 需求阶段 (Claude)
   └─> 创建 GitHub Issue
   └─> Claude 分析需求
   └─> 生成开发计划和 API 文档

2️⃣ 开发阶段 (Codex)
   └─> 创建开发分支
   └─> Cursor/Copilot 辅助编码
   └─> 编写测试用例
   └─> 本地测试验证

3️⃣ 审查阶段 (Claude)
   └─> 提交 PR
   └─> 自动化检查运行
   └─> Claude 代码审查
   └─> 修复问题

4️⃣ 部署阶段 (Claude)
   └─> Claude 部署前检查
   └─> 合并 PR
   └─> 自动部署
   └─> 监控验证

♻️ 循环往复，持续迭代
```

---

## 最佳实践

### ✅ DO（推荐做法）

1. **每个功能都从 Issue 开始**
   - Issue 描述要清晰
   - 包含 PRD 和设计稿

2. **让 Claude 先生成计划**
   - 技术方案要明确
   - API 接口要详细定义

3. **Codex 严格按计划实现**
   - 参考计划文档
   - 不要偏离设计

4. **小步提交，频繁审查**
   - PR 不要太大（<500 行）
   - 每个 PR 只做一件事

5. **测试驱动开发**
   - 先写测试用例
   - 测试覆盖率 >80%

### ❌ DON'T（避免做法）

1. **不要跳过 Claude 计划阶段**
   - 直接让 Codex 写代码容易偏离需求

2. **不要忽略代码审查**
   - Claude 审查能发现很多问题

3. **不要提交大型 PR**
   - 难以审查，容易出错

4. **不要跳过测试**
   - 没有测试的代码不可靠

5. **不要硬编码配置**
   - 使用环境变量

---

## 故障排查

### Claude Code 无法启动

```bash
# 检查版本
claude --version

# 重新登录
claude auth logout
claude auth login

# 清除缓存
rm -rf ~/.claude
claude auth login
```

### Codex 不工作

**Codex Cloud 网页版：**
1. 检查网络连接
2. 刷新页面
3. 重新登录账号
4. 检查订阅状态

**Codex 插件：**
1. 检查插件是否启用
2. 重新加载 VS Code 窗口
3. 检查 API Key 配置
4. 查看插件日志排查问题

### GitHub Actions 失败

1. 查看错误日志
2. 本地复现问题
3. 修复后重新提交

### PR 检查不通过

```bash
# 本地运行检查
cd server
npm run lint
npm test

cd ../client
npm run lint
npm test
```

---

## 下一步学习

- 📖 [完整工作流文档](./AI-WORKFLOW.md)
- 📖 [开发计划模板](./templates/plan-template.md)
- 📖 [API 文档模板](./templates/api-template.md)
- 📖 [项目规范](../CLAUDE.md)

---

## 获取帮助

- 💬 GitHub Issues: https://github.com/yjp1510586926/yjp-agent/issues
- 📚 Claude Code 文档: https://docs.anthropic.com/claude-code
- 📚 Cursor 文档: https://cursor.sh/docs

---

**🎉 恭喜！你已经掌握了 AI 驱动开发工作流的基础！**

现在开始你的第一个功能开发吧！ 🚀
