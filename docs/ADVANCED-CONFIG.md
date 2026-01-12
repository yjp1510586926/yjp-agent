# 🔧 高级配置指南

## Subagent 配置

### 什么是 Subagent？

Subagent 是 Claude Code 的一个高级功能，允许创建专门的 AI 代理来处理特定任务。

### 参考资源

- 官方示例：https://github.com/wshobson/agents/tree/main
- Claude Agent SDK 文档

### 配置 Subagent

在 `.claude/` 目录下创建 `agents/` 文件夹：

```bash
mkdir -p .claude/agents
```

### 示例：创建代码审查 Agent

创建文件 `.claude/agents/code-review-agent.json`：

```json
{
  "name": "code-review-agent",
  "description": "专门用于代码审查的 Agent",
  "model": "claude-opus-4",
  "systemPrompt": "你是一个资深的代码审查专家，专注于发现代码质量、安全性和性能问题。",
  "tools": [
    "read",
    "grep",
    "bash"
  ],
  "configuration": {
    "maxTokens": 4096,
    "temperature": 0.3
  },
  "workflow": [
    {
      "step": "analyze",
      "description": "分析代码变更",
      "actions": [
        "读取 PR 文件列表",
        "检查代码质量",
        "查找潜在问题"
      ]
    },
    {
      "step": "report",
      "description": "生成审查报告",
      "actions": [
        "总结发现的问题",
        "提供优化建议",
        "评估风险等级"
      ]
    }
  ]
}
```

### 使用 Subagent

```bash
# 在 Claude Code CLI 中
claude

# 调用 subagent
@code-review-agent 请审查最新的 PR

# 或通过命令
/review --agent=code-review-agent
```

### 常用 Subagent 类型

#### 1. 架构设计 Agent

专注于：
- 系统架构设计
- 技术选型
- 数据库设计
- API 接口设计

#### 2. 测试 Agent

专注于：
- 生成测试用例
- 编写单元测试
- E2E 测试设计
- 测试覆盖率分析

#### 3. 性能优化 Agent

专注于：
- 性能分析
- 瓶颈识别
- 优化建议
- 负载测试

#### 4. 安全审计 Agent

专注于：
- 安全漏洞扫描
- 依赖包审计
- 代码安全检查
- 渗透测试建议

---

## Skill 配置

### 什么是 Skill？

Skill 是 Claude Code 的自定义命令，可以封装常用的工作流程。

### 参考资源

- Skill 市场：https://skillsmp.com/
- 官方文档

### 现有 Skills

本项目已配置的 Skills（位于 `.claude/commands/`）：

1. **/code-review** - 代码审查
2. **/deploy-check** - 部署前检查
3. **/test** - 运行测试
4. **/refactor** - 重构建议
5. **/explain** - 代码解释
6. **/gas** - Gas 优化建议

### 创建自定义 Skill

#### 示例：创建 API 生成 Skill

创建文件 `.claude/commands/api-gen.md`：

````markdown
---
name: api-gen
description: 根据需求生成 API 接口代码
arguments: <功能描述>
---

# API 生成助手

你是一个 API 接口代码生成专家。

## 任务

根据用户提供的功能描述，生成完整的 API 接口代码，包括：

1. **NestJS Controller**
   - RESTful 接口
   - 请求验证
   - 错误处理

2. **DTO (Data Transfer Object)**
   - 创建 DTO
   - 更新 DTO
   - 验证规则

3. **Service**
   - 业务逻辑
   - 数据库操作
   - 异常处理

4. **测试用例**
   - Controller 测试
   - Service 测试
   - E2E 测试

## 生成规范

### 代码风格
- 使用 TypeScript 严格模式
- 遵循 NestJS 最佳实践
- 添加详细的 JSDoc 注释
- 使用装饰器进行验证

### 文件组织
```
src/modules/<module-name>/
├── <module-name>.controller.ts
├── <module-name>.service.ts
├── <module-name>.module.ts
├── dto/
│   ├── create-<entity>.dto.ts
│   └── update-<entity>.dto.ts
├── entities/
│   └── <entity>.entity.ts
└── tests/
    ├── <module-name>.controller.spec.ts
    └── <module-name>.service.spec.ts
```

### 验证规则
- 使用 class-validator
- 所有必填字段标记 @IsNotEmpty()
- 字符串长度使用 @Length()
- 邮箱使用 @IsEmail()
- 枚举使用 @IsEnum()

### 错误处理
- 使用 NestJS 内置异常
- 业务异常抛出 BadRequestException
- 未找到资源抛出 NotFoundException
- 权限问题抛出 ForbiddenException

## 执行步骤

1. 分析功能需求
2. 设计 API 接口（RESTful）
3. 生成 DTO 和 Entity
4. 实现 Controller 和 Service
5. 编写测试用例
6. 生成 API 文档

## 示例输出

当用户请求：`/api-gen 用户管理`

你应该生成：

### 1. Controller
```typescript
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @Get()
  findAll(@Query() query: PaginationDto) {
    return this.usersService.findAll(query);
  }

  // ... 其他接口
}
```

### 2. DTO
```typescript
export class CreateUserDto {
  @IsNotEmpty()
  @IsString()
  @Length(2, 50)
  name: string;

  @IsNotEmpty()
  @IsEmail()
  email: string;
}
```

### 3. Service
```typescript
@Injectable()
export class UsersService {
  async create(createUserDto: CreateUserDto) {
    // 实现逻辑
  }

  async findAll(query: PaginationDto) {
    // 实现逻辑
  }
}
```

### 4. 测试
```typescript
describe('UsersController', () => {
  // 测试用例
});
```

## 注意事项

- 确保所有代码都有类型定义
- 添加适当的错误处理
- 实现分页和筛选功能
- 考虑性能和安全性
- 生成后提示用户运行测试

---

开始根据 $ARGUMENTS 生成 API 接口代码。
````

### 使用自定义 Skill

```bash
# 在 Claude Code CLI 中
/api-gen 用户管理

# 或带详细描述
/api-gen 商品管理模块，包括 CRUD 操作和图片上传
```

---

## 从 Skill 市场安装 Skill

### 1. 访问 Skill 市场

https://skillsmp.com/

### 2. 浏览可用 Skills

常用分类：
- 代码生成
- 测试
- 文档
- 重构
- 部署

### 3. 安装 Skill

```bash
# 使用 Claude Code CLI
claude skill install <skill-name>

# 或手动下载到 .claude/commands/
```

### 4. 推荐 Skills

#### 开发类
- **api-scaffold**: 快速生成 API 脚手架
- **component-gen**: React 组件生成器
- **db-migration**: 数据库迁移脚本生成

#### 测试类
- **test-gen**: 智能测试用例生成
- **e2e-test**: E2E 测试脚本
- **mock-data**: Mock 数据生成

#### 文档类
- **api-doc**: API 文档生成
- **readme-gen**: README 生成器
- **changelog**: 变更日志生成

#### 优化类
- **performance-audit**: 性能审计
- **security-scan**: 安全扫描
- **code-cleanup**: 代码清理

---

## 集成到工作流

### 1. 在 Claude 阶段使用 Subagent

```bash
# 架构设计
@architecture-agent 设计用户认证模块

# API 设计
@api-design-agent 设计商品管理 API
```

### 2. 在 Codex 阶段使用 Skill

```bash
# 生成代码
/api-gen 用户认证模块

# 生成测试
/test-gen src/auth/auth.service.ts
```

### 3. 在审查阶段使用 Subagent

```bash
# 代码审查
@code-review-agent 审查 PR #123

# 安全审计
@security-agent 检查安全漏洞
```

### 4. 在部署阶段使用 Skill

```bash
# 部署检查
/deploy-check

# 生成变更日志
/changelog
```

---

## 最佳实践

### Subagent 最佳实践

1. **明确职责**
   - 每个 agent 专注单一领域
   - 避免功能重叠

2. **优化 Prompt**
   - 提供清晰的系统提示
   - 包含具体的工作流程

3. **选择合适模型**
   - 复杂任务用 Opus
   - 简单任务用 Sonnet/Haiku

4. **工具配置**
   - 只赋予必要的工具权限
   - 限制文件访问范围

### Skill 最佳实践

1. **模块化**
   - 拆分复杂流程为多个 skill
   - 支持组合使用

2. **参数化**
   - 使用 $ARGUMENTS 接收参数
   - 提供默认值

3. **文档完善**
   - 清晰的使用说明
   - 提供示例

4. **错误处理**
   - 验证输入参数
   - 提供友好的错误提示

---

## 故障排查

### Subagent 问题

**问题：Agent 无法找到**
```bash
# 检查配置文件
ls -la .claude/agents/

# 重新加载配置
claude reload
```

**问题：Agent 权限不足**
- 检查 `tools` 配置
- 确认文件访问权限

### Skill 问题

**问题：Skill 无法执行**
```bash
# 列出所有 skills
claude skills list

# 检查 skill 配置
cat .claude/commands/<skill-name>.md
```

**问题：参数传递错误**
- 检查 `arguments` 配置
- 使用引号包裹复杂参数

---

## 参考资源

### 官方文档
- Claude Code 文档: https://docs.anthropic.com/claude-code
- Claude Agent SDK: https://github.com/anthropics/anthropic-sdk-typescript

### 社区资源
- GitHub Agents: https://github.com/wshobson/agents
- Skill 市场: https://skillsmp.com/
- 社区讨论: https://github.com/anthropics/claude-code/discussions

### 示例项目
- 本项目: https://github.com/yjp1510586926/yjp-agent
- 官方示例: https://github.com/anthropics/claude-code-examples

---

**💡 提示**：合理使用 Subagent 和 Skill 可以大幅提升开发效率！

根据项目特点定制专属的 Agent 和 Skill，打造最适合你的 AI 开发工作流。
