# 📋 开发任务清单

> **项目大脑**：这是需求和任务管理的中心。
> **自动触发**：编辑并提交此文件，GitHub Actions 会自动召唤 Codex 进行开发。

---

## 🎯 当前开发任务 (Current Tasks)

<!-- 🟢 在下方添加你的新任务。AI 会自动读取状态为 [ ] 的任务。 -->

### 任务 1: [任务标题]

**优先级**: 中

**状态**:

- [ ] 待开发
- [ ] 开发中
- [ ] 待审查
- [ ] 已完成

**需求描述**:

<!-- 在这里详细描述你要实现的功能... -->

**前端需求**:

- [ ]
- [ ]

**后端需求**:

- [ ]
- [ ]

**验收标准**:

- [ ]

---

<!-- ⬇️ 在此线下方添加更多任务 -->

---

## ✅ 已完成任务 (Completed)

> 任务完成后，请将其移动到这里归档。

### ~~示例任务: 初始化项目~~

**完成时间**: 2024-01-01
**PR**: #1

---

## 📝 任务模板 (Copy Me)

复制下面的 Markdown 代码块来创建新任务：

\`\`\`markdown

### 任务 N: [简短标题]

**优先级**: 🔴 高 / 🟡 中 / 🟢 低

**状态**:

- [x] 待开发
- [ ] 开发中
- [ ] 待审查
- [ ] 已完成

**需求描述**:
详细描述...

**前端需求**:

- [ ] 组件/页面...
- [ ] 交互逻辑...

**后端需求**:

- [ ] API 接口...
- [ ] 数据库变更...

**验收标准**:

- [ ] 功能点 A
- [ ] 功能点 B
      \`\`\`

---

## 🔄 自动化工作流说明

1.  **发布任务**: 在上方添加任务，标记为 `[ ] 待开发`，提交代码 (`git push`)。
2.  **Codex 开发**: GitHub Actions 自动运行，生成代码并提交 PR。
3.  **Claude 审查**: 本地运行 `local_pr_watcher.sh` 或手动检查，Claude 进行 Code Review。
4.  **反馈循环**:
    - ✅ **通过**: 合并 PR，将任务移至[已完成]。
    - ❌ **打回**: 在任务描述中添加 `**Review Feedback**: ...`，Codex 会自动读取并修复。

---

### 任务 9: 用户资料卡片组件

**优先级**: 🟢 低

**状态**:

- [ ] 待开发
- [ ] 开发中
- [ ] 待审查
- [ ] 已完成

**需求描述**:
开发一个展示用户基本信息的卡片组件。

**前端需求**:
- [ ] 路径: `client/src/components/UserProfile.tsx`
- [ ] 展示信息: 头像 (Avatar)、用户名、职业、简介
- [ ] 样式:
    - 圆角卡片，有阴影
    - 头像居中
    - 下方有一排社交链接图标 (GitHub, Twitter)
- [ ] 响应式: 手机端占满宽度，桌面端宽度固定 300px

**验收标准**:
- [ ] 组件渲染正常
- [ ] 样式美观，符合描述

**Review Feedback** (PR #codex/solve-1768271949 - 不通过):

🔴 **严重问题需要修复**:

1. **删除了其他待开发任务** ❌
   - 你的提交删除了任务 3-8（共 6 个任务）：首页轮播图、后端健康检查、页脚、按钮组件、导航栏、字符串转换接口
   - 这些任务仍然是待开发状态，不应该被删除
   - **要求**: 恢复所有原有任务 3-8，保留它们在 todo.md 中

2. **未实际创建代码文件** ❌
   - 虽然在 response.json 中有代码内容，但没有真正创建 `client/src/components/UserProfile.tsx` 文件
   - **要求**: 必须实际创建 .tsx 文件并提交到仓库
   - **要求**: 确保组件代码符合 React + TypeScript 最佳实践

3. **提交了不应该的调试文件** ❌
   - `full_prompt.txt`, `payload.json`, `response.json` 不应该提交到版本库
   - **要求**: 从仓库中删除这些文件，并将它们添加到 .gitignore

4. **README.md 被错误修改** ❌
   - 在 README.md 末尾添加了 HTML 注释（审查员指令）
   - **要求**: 撤销对 README.md 的所有修改，它与任务 9 无关

5. **组件设计不完整** ⚠️
   - 当前设计缺少社交链接图标 (GitHub, Twitter)
   - 响应式样式没有完整实现（需要 media query）
   - **要求**: 完整实现所有前端需求中的功能点

6. **todo.md 结构被破坏** ❌
   - 删除了大量原有内容（示例任务、编写技巧、快速开始等）
   - **要求**: 恢复 todo.md 的完整结构

**正确的实现方式**:
1. 恢复 todo.md 到原始状态（包含所有任务 3-8 和原有结构）
2. 只创建 `client/src/components/UserProfile.tsx` 文件
3. 删除调试文件 (full_prompt.txt, payload.json, response.json)
4. 撤销对 README.md 的修改
5. 确保组件包含所有要求的功能（头像、用户名、职业、简介、社交图标）
6. 添加响应式样式支持（使用 CSS media query 或内联样式）

**请重新实现，修复以上所有问题。Codex 会在下次运行时读取此反馈并进行修复。**

---

**Review Feedback #2** (PR #codex/solve-1768272648 - 仍然不通过):

🔴 **核心问题依然存在**:

1. **仍然提交了调试文件** ❌
   - 第二次 PR 依然包含 `full_prompt.txt`, `payload.json`, `response.json`
   - 这些文件**绝对不能**提交到仓库
   - **关键问题**: 你的 workflow 配置有问题，需要在 git add 之前删除这些文件

2. **仍然没有创建实际代码文件** ❌ **CRITICAL**
   - response.json 中有代码内容，但没有实际的 `client/src/components/UserProfile.tsx` 文件
   - response.json 中有 CSS 内容，但没有实际的 `client/src/components/UserProfile.css` 文件
   - **根本原因**: GitHub Actions workflow 的 "Apply Codex Solutions" 步骤没有正确执行
   - **检查点**:
     - 文件路径格式是否正确？必须是 `### FILE: client/src/components/UserProfile.tsx`
     - 文件结束标记是否正确？必须是 `### END_FILE`
     - JavaScript 脚本是否正确解析了 response.json？

3. **组件仍然缺少社交链接图标** ⚠️
   - response.json 中的代码没有包含 GitHub 和 Twitter 图标
   - 需求明确要求：「下方有一排社交链接图标 (GitHub, Twitter)」
   - **要求**: 添加社交链接图标功能

4. **响应式设计不完整** ⚠️
   - CSS 中缺少 media query
   - 需求要求：手机端占满宽度，桌面端宽度固定 300px
   - 当前 `max-width: 520px` 不符合要求

**🔧 关键修复步骤**:

**步骤 1: 修复 workflow（最重要）**
检查 `.github/workflows/codex-worker.yml` 的 "Apply Codex Solutions" 步骤：
- 确保 fileRegex 正确匹配文件块
- 确保 fs.writeFileSync 被正确调用
- 添加日志输出以调试

**步骤 2: 添加 .gitignore**
创建或修改 `.gitignore` 文件，添加：
```
full_prompt.txt
payload.json
response.json
```

**步骤 3: 完善组件代码**
在生成代码时包含：
- 社交链接图标（使用 SVG 或 icon library）
- 响应式 media query
- 完整的 TypeScript 类型定义

**步骤 4: 正确的提交流程**
```bash
# 1. 删除调试文件
rm -f full_prompt.txt payload.json response.json

# 2. 只添加代码文件
git add client/src/components/UserProfile.tsx
git add client/src/components/UserProfile.css

# 3. 提交
git commit -m "feat: add UserProfile component with social links"
```

**❗ 如果这次还是没有创建实际文件，说明 workflow 脚本有 BUG，需要修复 JavaScript 文件解析逻辑！**

---

### 任务 10: 简单计数器组件

**优先级**: 🟢 低

**状态**:

- [ ] 待开发
- [ ] 开发中
- [ ] 待审查
- [ ] 已完成

**需求描述**:
开发一个简单的计数器组件用于测试。

**前端需求**:
- [ ] 路径: `client/src/components/Counter.tsx`
- [ ] 功能:
    - 显示当前计数值 (默认 0)
    - [+] 按钮: 点击加 1
    - [-] 按钮: 点击减 1
    - [Reset] 按钮: 重置为 0
- [ ] 样式: 简单的 Flex 布局，按钮要有明显的间距

**验收标准**:
- [ ] 必须生成 `.tsx` 文件
- [ ] 交互功能正常
