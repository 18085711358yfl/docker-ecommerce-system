# API接口列表

## 基础信息

- **Base URL**: `http://localhost:8080`
- **Content-Type**: `application/json`（文件上传除外）
- **字符编码**: UTF-8
- **CORS**: 已启用，支持跨域请求

---

## 📋 快速索引

### 商品管理 API (7个接口)

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/products` | 获取所有商品 |
| GET | `/api/products/{id}` | 根据ID获取商品详情 |
| POST | `/api/products` | 创建商品 |
| PUT | `/api/products/{id}` | 更新商品 |
| DELETE | `/api/products/{id}` | 删除商品 |
| GET | `/api/products/category/{category}` | 根据分类查询商品 |
| GET | `/api/products/search?keyword={keyword}` | 搜索商品 |

### 文件上传 API (1个接口)

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/upload/image` | 上传图片文件 |

### 健康检查 API (2个接口)

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/actuator/health` | 应用健康检查 |
| GET | `/actuator/info` | 应用信息 |

---

## 📦 完整API列表

### 1. 获取所有商品

```
GET /api/products
```

**响应示例**:
```json
{
  "success": true,
  "data": [...],
  "total": 10
}
```

---

### 2. 根据ID获取商品详情

```
GET /api/products/{id}
```

**路径参数**:
- `id` (Long, 必填) - 商品ID

**响应示例**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "iPhone 15 Pro",
    "description": "...",
    "price": 7999.00,
    "stock": 50,
    "category": "手机数码",
    "imageUrl": "/uploads/images/iphone15.jpg"
  }
}
```

---

### 3. 创建商品

```
POST /api/products
Content-Type: application/json
```

**请求体**:
```json
{
  "name": "新商品",          // 必填，最大255字符
  "description": "描述",     // 可选，最大2000字符
  "price": 99.99,           // 必填，必须>0
  "stock": 100,             // 必填，不能为负数
  "category": "分类",       // 可选，最大100字符
  "imageUrl": "/uploads/..." // 可选，最大500字符
}
```

**响应示例** (201 Created):
```json
{
  "success": true,
  "data": {...},
  "message": "商品创建成功"
}
```

---

### 4. 更新商品

```
PUT /api/products/{id}
Content-Type: application/json
```

**路径参数**:
- `id` (Long, 必填) - 商品ID

**请求体**: 同创建商品

**响应示例** (200 OK):
```json
{
  "success": true,
  "data": {...},
  "message": "商品更新成功"
}
```

---

### 5. 删除商品

```
DELETE /api/products/{id}
```

**路径参数**:
- `id` (Long, 必填) - 商品ID

**响应示例**:
```json
{
  "success": true,
  "message": "商品删除成功"
}
```

---

### 6. 根据分类查询商品

```
GET /api/products/category/{category}
```

**路径参数**:
- `category` (String, 必填) - 商品分类

**响应示例**:
```json
{
  "success": true,
  "data": [...],
  "total": 3
}
```

---

### 7. 搜索商品

```
GET /api/products/search?keyword={keyword}
```

**查询参数**:
- `keyword` (String, 必填) - 搜索关键词

**响应示例**:
```json
{
  "success": true,
  "data": [...],
  "total": 2
}
```

---

### 8. 上传图片

```
POST /api/upload/image
Content-Type: multipart/form-data
```

**请求参数**:
- `file` (File, 必填) - 图片文件

**限制**:
- 文件大小: 最大5MB
- 文件类型: 仅支持图片（image/*）

**响应示例**:
```json
{
  "success": true,
  "url": "/uploads/images/uuid-filename.jpg",
  "message": "上传成功"
}
```

**访问上传的图片**:
```
http://localhost:8080/uploads/images/{文件名}
```

---

### 9. 应用健康检查

```
GET /actuator/health
```

**响应示例**:
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP"
    },
    "diskSpace": {
      "status": "UP"
    }
  }
}
```

---

### 10. 应用信息

```
GET /actuator/info
```

---

## 🔧 Apifox导入说明

### 方法1: 导入Postman Collection（推荐）

1. 打开Apifox
2. 点击左侧菜单的 **导入**
3. 选择 **Postman Collection**
4. 选择文件: `docs/apifox-collection.json`
5. 点击 **导入**

### 方法2: 手动导入OpenAPI

如果项目中有OpenAPI/Swagger文档，也可以导入。

---

## 📝 使用示例

### cURL命令示例

**获取所有商品**:
```bash
curl -X GET http://localhost:8080/api/products
```

**创建商品**:
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "测试商品",
    "price": 99.99,
    "stock": 100,
    "category": "测试分类"
  }'
```

**上传图片**:
```bash
curl -X POST http://localhost:8080/api/upload/image \
  -F "file=@image.jpg"
```

---

## ⚠️ 注意事项

1. **Base URL**: 默认是 `http://localhost:8080`，生产环境请修改
2. **字符编码**: 所有请求和响应都使用UTF-8编码
3. **文件上传**: 仅支持图片格式，最大5MB
4. **验证规则**: 
   - 商品名称不能为空
   - 商品价格必须大于0
   - 库存不能为负数
5. **错误处理**: 所有错误都会返回JSON格式的错误信息
6. **CORS**: API已启用跨域支持

---

## 📊 响应格式

### 成功响应
```json
{
  "success": true,
  "data": {...},
  "message": "操作成功",
  "total": 10  // 列表接口返回
}
```

### 错误响应
```json
{
  "success": false,
  "message": "错误信息"
}
```

---

## 🧪 测试数据

系统初始化时会自动创建10条测试商品数据，包括：
- iPhone 15 Pro
- MacBook Pro 14
- AirPods Pro 2
- iPad Air
- Apple Watch Series 9
- 小米13 Ultra
- 华为MateBook X Pro
- 索尼WH-1000XM5
- 戴尔XPS 13
- 三星Galaxy S24

---

**最后更新**: 2025-12-13

