# 🚀 NestJS + React 全栈项目

这是一个基于 NestJS 和 React 构建的全栈应用示例项目，采用 **AI 驱动开发工作流**。

## 🤖 AI 驱动开发

本项目使用 **Claude（技术总监）+ Codex（开发工程师）** 的协作模式：

### 🚀 全自动化工作流（推荐）

```
todo.md → 自动触发 Codex → 自动开发 → 自动测试 → Claude 审查 → 自动合并
 (需求)      (检测)          (编码)      (检查)      (把关)       (部署)
```

**快速开始：**
1. 在 `todo.md` 中添加开发任务
2. 提交并推送到 GitHub
3. Codex 自动开始开发
4. Claude 自动审查代码
5. 通过后自动合并部署

### 📋 手动协作模式

```
PRD/设计稿 → Claude 生成计划 → Codex 开发 → PR → Claude 审查 → 合并部署
   (输入)      (架构师)         (编码)     (提交)   (技术总监)    (发布)
```

### 快速开始 AI 工作流

#### 🤖 全自动化模式
1. **📋 [todo.md](./todo.md)** - 在此文件添加开发任务，提交后自动触发 Codex
2. **🔄 [全自动化工作流](./docs/AUTO-WORKFLOW.md)** - 完整的自动化流程说明

#### 📝 手动协作模式
1. **📖 [快速开始指南](./docs/QUICK-START.md)** - 5分钟上手 AI 开发流程
2. **🤖 [Codex 使用指南](./docs/CODEX-GUIDE.md)** - Codex Cloud/插件详细使用方法
3. **📚 [完整工作流文档](./docs/AI-WORKFLOW.md)** - 详细的 AI 驱动开发指南
4. **📋 [开发计划模板](./docs/templates/plan-template.md)** - Claude 生成计划的模板
5. **🔌 [API 文档模板](./docs/templates/api-template.md)** - API 接口设计模板

### AI 工具配置

- **Claude Code CLI**: 用于架构设计、代码审查、部署检查
- **Codex**: 用于具体代码实现
  - Codex Cloud 网页版（推荐）
  - VS Code Codex 插件
  - 或其他替代方案（Cursor、GitHub Copilot）
- **GitHub Actions**: 自动化测试和部署

---

## 项目结构

```
yjp-agent/
├── server/          # NestJS 后端
│   ├── src/
│   │   ├── main.ts           # 应用入口
│   │   ├── app.module.ts     # 根模块
│   │   ├── app.controller.ts # 控制器
│   │   └── app.service.ts    # 服务
│   ├── package.json
│   └── tsconfig.json
├── client/          # React 前端
│   ├── public/
│   ├── src/
│   │   ├── App.tsx           # 主组件
│   │   ├── App.css           # 样式
│   │   └── index.tsx         # 入口文件
│   ├── package.json
│   └── tsconfig.json
└── package.json     # 根配置
```

## 技术栈

### 后端
- **NestJS** - 渐进式 Node.js 框架
- **TypeScript** - 类型安全
- **Express** - HTTP 服务器

### 前端
- **React 18** - UI 框架
- **TypeScript** - 类型安全
- **Axios** - HTTP 客户端

## 快速开始

### 1. 安装依赖

在项目根目录运行：

```bash
# 安装所有依赖（前端 + 后端）
npm run install:all
```

或者分别安装：

```bash
# 安装后端依赖
cd server && npm install

# 安装前端依赖
cd client && npm install
```

### 2. 启动开发服务器

需要开启两个终端窗口：

**终端 1 - 启动后端服务器：**
```bash
npm run dev:server
# 或
cd server && npm run start:dev
```
后端服务将运行在 `http://localhost:3001`

**终端 2 - 启动前端开发服务器：**
```bash
npm run dev:client
# 或
cd client && npm start
```
前端应用将运行在 `http://localhost:3000`

### 3. 访问应用

打开浏览器访问 `http://localhost:3000`，你将看到一个简单的用户管理界面。

## API 端点

后端提供以下 API 端点：

- `GET /api/hello` - 获取欢迎消息
- `GET /api/users` - 获取所有用户
- `POST /api/users` - 创建新用户
  - Body: `{ "name": "string", "email": "string" }`

## 功能特性

- ✅ 前后端分离架构
- ✅ TypeScript 全栈类型安全
- ✅ CORS 跨域配置
- ✅ RESTful API 设计
- ✅ 响应式 UI 设计
- ✅ 用户 CRUD 操作示例

## 开发说明

### 后端开发

```bash
cd server
npm run start:dev    # 开发模式（热重载）
npm run build        # 构建生产版本
npm run start:prod   # 运行生产版本
```

### 前端开发

```bash
cd client
npm start           # 开发模式
npm run build       # 构建生产版本
npm test            # 运行测试
```

## 生产部署

### 构建项目

```bash
# 构建后端
npm run build:server

# 构建前端
npm run build:client
```

### 运行生产版本

```bash
# 启动后端
npm run start:server

# 前端静态文件在 client/build/ 目录
# 可以使用 nginx 或其他静态服务器托管
```

## 配置说明

### 后端配置
- 端口：3001 (可在 `server/src/main.ts` 修改)
- CORS：允许来自 `http://localhost:3000` 的请求

### 前端配置
- 端口：3000 (React 默认)
- API 代理：配置在 `client/package.json` 的 `proxy` 字段

## 扩展建议

- 添加数据库（如 PostgreSQL、MongoDB）
- 实现用户认证和授权
- 添加更多的业务模块
- 集成状态管理（Redux、MobX）
- 添加单元测试和 E2E 测试

## 许可证

ISC
