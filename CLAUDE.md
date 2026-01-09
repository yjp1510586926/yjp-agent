# CLAUDE.md - 项目说明文件
# ================================
# 这个文件会被 Claude Code 自动读取，用于了解项目背景
# 可以包含：项目介绍、技术栈、编码规范、常用命令等

## 项目介绍
这是一个 Web3 Agent 项目，用于...（在此描述你的项目）

## 技术栈
- Node.js / TypeScript
- Web3.js / Ethers.js
- ...

## 编码规范
- 使用 TypeScript 严格模式
- 函数需要添加 JSDoc 注释
- 变量命名使用 camelCase
- 常量使用 UPPER_SNAKE_CASE

## 常用命令
```bash
# 安装依赖
npm install

# 开发模式
npm run dev

# 构建
npm run build

# 测试
npm test
```

## 目录结构
```
src/
  ├── agents/      # Agent 逻辑
  ├── contracts/   # 合约交互
  ├── utils/       # 工具函数
  └── index.ts     # 入口文件
```

## 注意事项
- 不要提交 .env 文件
- 私钥相关代码需要特别注意安全性
