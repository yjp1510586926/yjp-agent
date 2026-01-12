# 🤖 Codex 使用指南

## Codex 使用方式

Codex 有多种使用方式，选择最适合你的：

### 方式 1: Codex Cloud 网页版（推荐）

**优势：**
- ✅ 无需安装，浏览器直接使用
- ✅ 云端运行，不占用本地资源
- ✅ 多端同步
- ✅ 内置 AI 助手

**访问地址：**
- Codex Cloud: https://codex.ai/ （或你使用的平台）

**使用步骤：**

1. **登录 Codex Cloud**
   - 访问网页版
   - 登录你的账号

2. **导入项目**
   ```
   方式 1: GitHub 导入
   - 连接 GitHub 账号
   - 选择 yjp1510586926/yjp-agent 仓库
   - 自动 clone 到云端环境

   方式 2: 手动上传
   - 上传项目代码
   - 配置环境
   ```

3. **开始开发**
   - 打开 Claude 生成的计划文档
   - 在编辑器中输入提示词
   - Codex 辅助生成代码

---

### 方式 2: VS Code 插件

**优势：**
- ✅ 集成在 VS Code 中
- ✅ 本地开发环境
- ✅ 快捷键支持

**安装步骤：**

1. **安装 Codex 插件**
   ```bash
   # 在 VS Code 中
   Ctrl+P (Windows) / Cmd+P (Mac)

   # 搜索并安装
   ext install codex-ai
   ```

2. **配置插件**
   - 打开 VS Code 设置
   - 搜索 "Codex"
   - 配置 API Key（如需要）

3. **使用插件**
   - 打开项目文件
   - 选中代码或光标定位
   - 按快捷键唤起 Codex
   - 输入提示词生成代码

**快捷键：**
- `Ctrl+Shift+A` (Windows) / `Cmd+Shift+A` (Mac) - 唤起 Codex
- `Tab` - 接受建议
- `Esc` - 取消

---

### 方式 3: GitHub Copilot（替代方案）

**优势：**
- ✅ 直接集成在 IDE 中
- ✅ 上下文感知
- ✅ 支持多语言

**安装步骤：**

```bash
# VS Code 安装
code --install-extension GitHub.copilot

# JetBrains IDE
# 在插件市场搜索 "GitHub Copilot"
```

**订阅费用：** $10/月

---

## Codex 开发工作流

### 场景 1: 使用 Codex Cloud 网页版

#### 第 1 步：在 Claude 中获取开发计划

```bash
# 本地运行 Claude Code CLI
claude

# 生成开发计划
请分析 GitHub Issue #123 并生成开发计划
```

Claude 会生成：
- `docs/plans/feature-xxx-plan.md`
- `docs/api/feature-xxx-api.md`

#### 第 2 步：在 Codex Cloud 中实现

1. **打开 Codex Cloud 网页版**
   - 访问你的 Codex 平台
   - 打开项目

2. **导入开发计划**
   - 在 Codex 中打开 `docs/plans/feature-xxx-plan.md`
   - 阅读计划内容

3. **使用 AI 辅助开发**

   **后端开发示例：**
   ```
   AI 提示词：
   根据 docs/plans/user-login-plan.md
   实现用户登录功能：

   1. 在 server/src/modules/ 创建 auth 模块
   2. 实现 login API 接口
   3. 使用 JWT 进行认证
   4. 添加 DTO 验证
   5. 编写单元测试
   ```

   **前端开发示例：**
   ```
   AI 提示词：
   根据 docs/plans/user-login-plan.md
   实现登录页面：

   1. 在 client/src/pages/ 创建 Login.tsx
   2. 实现表单和验证
   3. 集成登录 API
   4. 添加错误处理和加载状态
   5. 编写组件测试
   ```

4. **使用任务系统**
   - Codex Cloud 通常有任务管理功能
   - 创建任务清单
   - 逐个完成并标记

#### 第 3 步：测试代码

```bash
# 在 Codex Cloud 终端中
cd server && npm test
cd client && npm test

# 或使用 Codex Cloud 的测试功能
```

#### 第 4 步：提交代码

```bash
# 在 Codex Cloud 终端
git add .
git commit -m "feat: 实现用户登录功能 (#123)"
git push origin feature/issue-123-user-login
```

#### 第 5 步：创建 PR

- 在 GitHub 上创建 Pull Request
- 等待自动化检查
- 使用 Claude 进行代码审查

---

### 场景 2: 使用 VS Code + Codex 插件

#### 开发流程

1. **获取 Claude 生成的计划**
   ```bash
   claude
   # 生成计划文档
   ```

2. **在 VS Code 中打开项目**
   ```bash
   code /path/to/yjp-agent
   ```

3. **使用 Codex 插件开发**

   **方式 A: 自动补全**
   - 开始输入代码
   - Codex 自动提供建议
   - 按 Tab 接受

   **方式 B: 注释驱动**
   ```typescript
   // 实现用户登录 API，接收 email 和 password
   // 验证用户信息，生成 JWT token
   // 返回 token 和用户信息

   // Codex 会根据注释自动生成代码
   ```

   **方式 C: 选中代码重构**
   - 选中代码片段
   - 按快捷键唤起 Codex
   - 输入："优化这段代码" 或 "添加错误处理"

4. **本地测试**
   ```bash
   # 终端 1
   npm run dev:server

   # 终端 2
   npm run dev:client
   ```

5. **提交 PR**
   ```bash
   git add .
   git commit -m "feat: xxx"
   git push
   ```

---

## Codex 提示词技巧

### 1. 明确任务目标

**❌ 不好的提示词：**
```
写一个登录功能
```

**✅ 好的提示词：**
```
实现 NestJS 用户登录 API：
- POST /api/auth/login
- 接收参数：email, password
- 验证用户信息
- 生成 JWT token
- 返回 token 和用户信息
- 添加错误处理和验证
```

### 2. 提供上下文

**✅ 包含上下文：**
```
根据 docs/plans/user-login-plan.md 和 docs/api/user-login-api.md
实现以下功能：
[具体需求]
```

### 3. 指定技术栈

**✅ 明确技术栈：**
```
使用 NestJS + TypeScript
实现用户注册功能
- 使用 class-validator 进行验证
- 使用 bcrypt 加密密码
- 遵循项目规范（见 CLAUDE.md）
```

### 4. 分步骤执行

**✅ 拆分任务：**
```
第 1 步：创建 DTO
第 2 步：实现 Service
第 3 步：实现 Controller
第 4 步：编写测试
```

### 5. 参考现有代码

**✅ 参考现有模式：**
```
参考 server/src/app.controller.ts 的写法
创建一个新的 users.controller.ts
实现用户管理的 CRUD 接口
```

---

## Codex 常见场景

### 场景 1: 创建新的 API 模块

**提示词模板：**
```
创建一个 [模块名] 模块，实现以下功能：

1. 文件结构：
   server/src/modules/[module-name]/
   ├── [module-name].controller.ts
   ├── [module-name].service.ts
   ├── [module-name].module.ts
   ├── dto/
   │   ├── create-[entity].dto.ts
   │   └── update-[entity].dto.ts
   └── entities/
       └── [entity].entity.ts

2. API 接口：
   - POST /api/[module-name] - 创建
   - GET /api/[module-name] - 列表
   - GET /api/[module-name]/:id - 详情
   - PATCH /api/[module-name]/:id - 更新
   - DELETE /api/[module-name]/:id - 删除

3. 技术要求：
   - 使用 TypeScript
   - 使用 class-validator 验证
   - 添加错误处理
   - 编写单元测试

参考：docs/templates/plan-template.md
```

### 场景 2: 创建 React 组件

**提示词模板：**
```
创建一个 [组件名] 组件：

1. 文件位置：client/src/components/[ComponentName].tsx

2. 功能需求：
   - [功能 1]
   - [功能 2]
   - [功能 3]

3. Props 定义：
   interface [ComponentName]Props {
     // 定义 props
   }

4. 使用 React Hooks：
   - useState 管理状态
   - useEffect 处理副作用
   - 自定义 hooks（如需要）

5. 样式：
   - 使用 CSS Modules
   - 响应式设计

6. 测试：
   - 使用 React Testing Library
   - 测试主要交互场景
```

### 场景 3: 编写测试用例

**提示词模板：**
```
为 [文件路径] 编写完整的测试用例：

1. 测试文件：[文件路径].spec.ts

2. 测试覆盖：
   - 正常场景
   - 异常场景
   - 边界条件

3. Mock 依赖：
   - 数据库操作
   - 外部 API 调用

4. 断言：
   - 返回值正确
   - 错误处理正确
   - 副作用符合预期

5. 测试覆盖率：> 80%
```

### 场景 4: 代码重构

**提示词模板：**
```
重构以下代码，要求：

1. 优化目标：
   - 提高可读性
   - 改善性能
   - 增强可维护性

2. 保持功能不变

3. 遵循最佳实践：
   - 单一职责原则
   - DRY（Don't Repeat Yourself）
   - 命名清晰

[粘贴要重构的代码]
```

---

## 最佳实践

### 1. 工作流程

```
Claude 生成计划 → Codex 实现代码 → 本地测试 → 提交 PR → Claude 审查
```

### 2. 提示词策略

- 🎯 **明确具体** - 说清楚要做什么
- 📋 **提供上下文** - 参考计划文档
- 🔧 **指定技术** - 明确技术栈
- 📝 **遵循规范** - 参考项目规范

### 3. 代码质量

- ✅ 每次生成代码后都要审查
- ✅ 运行测试确保功能正确
- ✅ 检查类型安全
- ✅ 遵循代码规范

### 4. 版本控制

- ✅ 小步提交
- ✅ 清晰的 commit message
- ✅ 及时推送到远程

---

## Codex Cloud 特定功能

### 任务管理

大多数 Codex Cloud 平台提供任务管理功能：

1. **创建任务清单**
   - 导入 Claude 生成的任务
   - 设置优先级

2. **跟踪进度**
   - 标记完成状态
   - 查看整体进度

3. **协作功能**
   - 分享任务给团队
   - 评论和讨论

### 代码审查

在提交前使用 Codex Cloud 的审查功能：

1. **自动检查**
   - 语法错误
   - 类型错误
   - 代码风格

2. **AI 建议**
   - 性能优化
   - 安全问题
   - 最佳实践

### 云端终端

使用云端终端运行命令：

```bash
# 安装依赖
npm install

# 运行测试
npm test

# 启动开发服务器
npm run dev:server
```

---

## 常见问题

### Q: Codex Cloud 和本地开发如何切换？

**A:**
1. Codex Cloud 开发完成后
2. Push 到 GitHub
3. 本地 pull 最新代码
4. 继续本地开发

### Q: Codex 生成的代码不符合预期怎么办？

**A:**
1. 优化提示词，提供更多上下文
2. 参考 Claude 生成的计划文档
3. 分步骤生成，每步都检查
4. 手动调整生成的代码

### Q: 如何确保代码质量？

**A:**
1. 使用 Claude 生成的详细计划
2. 遵循项目规范（CLAUDE.md）
3. 编写测试用例
4. 提交前本地测试
5. Claude 代码审查

---

## 相关文档

- [快速开始](./QUICK-START.md)
- [完整工作流](./AI-WORKFLOW.md)
- [开发计划模板](./templates/plan-template.md)
- [API 文档模板](./templates/api-template.md)

---

**💡 提示**: 无论使用哪种方式，核心都是让 **Claude 做架构设计，Codex 做代码实现**！
