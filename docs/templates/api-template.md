# API 接口文档：[功能名称]

> 📅 创建时间：YYYY-MM-DD
> 🔗 关联 Issue: #XXX
> 📋 开发计划：[链接到计划文档]

---

## 概述

### 基本信息
- **Base URL**: `http://localhost:3000/api`
- **认证方式**: Bearer Token (JWT)
- **数据格式**: JSON
- **字符编码**: UTF-8

### 版本历史
| 版本 | 日期 | 变更说明 |
|-----|------|---------|
| v1.0 | 2024-01-01 | 初始版本 |

---

## 通用响应格式

### 成功响应
```json
{
  "success": true,
  "data": { ... },
  "message": "操作成功"
}
```

### 错误响应
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "错误描述",
    "details": { ... }
  }
}
```

### 通用错误码
| 错误码 | HTTP 状态码 | 说明 |
|-------|-----------|------|
| `UNAUTHORIZED` | 401 | 未认证 |
| `FORBIDDEN` | 403 | 无权限 |
| `NOT_FOUND` | 404 | 资源不存在 |
| `VALIDATION_ERROR` | 400 | 参数验证失败 |
| `INTERNAL_ERROR` | 500 | 服务器内部错误 |

---

## 数据类型定义

### Feature 对象
```typescript
interface Feature {
  id: number;                    // ID
  name: string;                  // 名称
  description: string;           // 描述
  status: 'active' | 'inactive'; // 状态
  createdAt: string;             // 创建时间（ISO 8601）
  updatedAt: string;             // 更新时间（ISO 8601）
}
```

### CreateFeatureDTO
```typescript
interface CreateFeatureDTO {
  name: string;        // 名称（必填，2-100字符）
  description?: string; // 描述（可选，最大1000字符）
  status?: 'active' | 'inactive'; // 状态（可选，默认 active）
}
```

### UpdateFeatureDTO
```typescript
interface UpdateFeatureDTO {
  name?: string;       // 名称（可选，2-100字符）
  description?: string; // 描述（可选，最大1000字符）
  status?: 'active' | 'inactive'; // 状态（可选）
}
```

### 分页响应
```typescript
interface PaginatedResponse<T> {
  success: true;
  data: {
    items: T[];      // 数据列表
    total: number;   // 总数
    page: number;    // 当前页
    pageSize: number; // 每页数量
    totalPages: number; // 总页数
  };
}
```

---

## API 端点

### 1. 创建 Feature

创建一个新的 Feature

**端点：** `POST /api/features`

**请求头：**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**请求体：**
```json
{
  "name": "示例功能",
  "description": "这是一个示例功能",
  "status": "active"
}
```

**请求参数验证：**
- `name`: 必填，字符串，2-100字符
- `description`: 可选，字符串，最大1000字符
- `status`: 可选，枚举值 'active' | 'inactive'

**成功响应：** `201 Created`
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "示例功能",
    "description": "这是一个示例功能",
    "status": "active",
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  },
  "message": "创建成功"
}
```

**错误响应：**

`400 Bad Request` - 参数验证失败
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "参数验证失败",
    "details": {
      "name": ["name 不能为空", "name 长度必须在 2-100 之间"]
    }
  }
}
```

`401 Unauthorized` - 未认证
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "请先登录"
  }
}
```

**示例代码：**

```typescript
// TypeScript/JavaScript
const response = await fetch('http://localhost:3000/api/features', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    name: '示例功能',
    description: '这是一个示例功能',
    status: 'active'
  })
});

const data = await response.json();
```

```bash
# cURL
curl -X POST http://localhost:3000/api/features \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "示例功能",
    "description": "这是一个示例功能",
    "status": "active"
  }'
```

---

### 2. 获取 Feature 列表

获取 Feature 列表，支持分页和筛选

**端点：** `GET /api/features`

**请求头：**
```
Authorization: Bearer <token>
```

**查询参数：**
| 参数 | 类型 | 必填 | 说明 | 默认值 |
|-----|------|------|------|-------|
| `page` | number | 否 | 页码（从1开始） | 1 |
| `pageSize` | number | 否 | 每页数量（1-100） | 10 |
| `status` | string | 否 | 状态筛选 | - |
| `search` | string | 否 | 关键词搜索（搜索名称和描述） | - |
| `sortBy` | string | 否 | 排序字段 | createdAt |
| `sortOrder` | string | 否 | 排序方向（asc/desc） | desc |

**成功响应：** `200 OK`
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "name": "示例功能",
        "description": "这是一个示例功能",
        "status": "active",
        "createdAt": "2024-01-01T00:00:00.000Z",
        "updatedAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

**示例代码：**

```typescript
// TypeScript/JavaScript
const params = new URLSearchParams({
  page: '1',
  pageSize: '10',
  status: 'active',
  search: '关键词'
});

const response = await fetch(`http://localhost:3000/api/features?${params}`, {
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const data = await response.json();
```

---

### 3. 获取单个 Feature

根据 ID 获取 Feature 详情

**端点：** `GET /api/features/:id`

**请求头：**
```
Authorization: Bearer <token>
```

**路径参数：**
- `id`: Feature ID（整数）

**成功响应：** `200 OK`
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "示例功能",
    "description": "这是一个示例功能",
    "status": "active",
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

**错误响应：**

`404 Not Found` - Feature 不存在
```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Feature 不存在"
  }
}
```

**示例代码：**

```typescript
// TypeScript/JavaScript
const response = await fetch(`http://localhost:3000/api/features/1`, {
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const data = await response.json();
```

---

### 4. 更新 Feature

更新一个已存在的 Feature

**端点：** `PATCH /api/features/:id`

**请求头：**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**路径参数：**
- `id`: Feature ID（整数）

**请求体：**
```json
{
  "name": "更新后的名称",
  "description": "更新后的描述",
  "status": "inactive"
}
```

**请求参数验证：**
- `name`: 可选，字符串，2-100字符
- `description`: 可选，字符串，最大1000字符
- `status`: 可选，枚举值 'active' | 'inactive'

**成功响应：** `200 OK`
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "更新后的名称",
    "description": "更新后的描述",
    "status": "inactive",
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T01:00:00.000Z"
  },
  "message": "更新成功"
}
```

**错误响应：**

`404 Not Found` - Feature 不存在
`400 Bad Request` - 参数验证失败

**示例代码：**

```typescript
// TypeScript/JavaScript
const response = await fetch('http://localhost:3000/api/features/1', {
  method: 'PATCH',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    name: '更新后的名称',
    status: 'inactive'
  })
});

const data = await response.json();
```

---

### 5. 删除 Feature

删除一个 Feature

**端点：** `DELETE /api/features/:id`

**请求头：**
```
Authorization: Bearer <token>
```

**路径参数：**
- `id`: Feature ID（整数）

**成功响应：** `200 OK`
```json
{
  "success": true,
  "message": "删除成功"
}
```

**错误响应：**

`404 Not Found` - Feature 不存在
`403 Forbidden` - 无权限删除

**示例代码：**

```typescript
// TypeScript/JavaScript
const response = await fetch('http://localhost:3000/api/features/1', {
  method: 'DELETE',
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const data = await response.json();
```

---

## 认证说明

### 获取 Token

**端点：** `POST /api/auth/login`

**请求体：**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**成功响应：**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600
  }
}
```

### 使用 Token

在所有需要认证的请求中，添加以下请求头：
```
Authorization: Bearer <accessToken>
```

---

## 速率限制

为防止滥用，API 实施了速率限制：

- **全局限制**: 每个 IP 每分钟最多 100 个请求
- **认证用户**: 每个用户每分钟最多 1000 个请求

超过限制时，响应：
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "请求过于频繁，请稍后再试",
    "retryAfter": 60
  }
}
```

响应头：
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1609459200
```

---

## 测试环境

### 测试服务器
- **URL**: `https://api-test.example.com`
- **认证**: 使用测试账号

### 测试账号
```
Email: test@example.com
Password: test123456
```

### Mock 数据
测试环境提供了预置的 Mock 数据，可用于前端开发和测试。

---

## 变更日志

### v1.0 (2024-01-01)
- ✨ 初始版本
- ✨ 实现基础 CRUD 接口
- ✨ 添加认证和权限控制

---

## 附录

### Postman Collection
导入以下 JSON 到 Postman 进行测试：
[下载链接]

### API Client SDK
```bash
# 安装 SDK
npm install @your-project/api-client

# 使用 SDK
import { FeatureAPI } from '@your-project/api-client';

const api = new FeatureAPI({ baseURL: 'http://localhost:3000/api' });
const feature = await api.create({ name: '示例功能' });
```

---

*本文档由 Claude AI 生成，供 Codex 开发参考*
