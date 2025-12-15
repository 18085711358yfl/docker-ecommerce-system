# API接口文档

## 基础信息

- **Base URL**: `http://localhost:8080/api`
- **Content-Type**: `application/json`
- **字符编码**: UTF-8

## 接口列表

### 1. 获取所有商品

#### 请求
```
GET /api/products
```

#### 响应示例
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "description": "Apple最新旗舰手机，搭载A17 Pro芯片",
      "price": 7999.00,
      "stock": 50,
      "category": "手机数码",
      "imageUrl": "https://example.com/iphone15.jpg"
    }
  ],
  "total": 10
}
```

#### cURL示例
```bash
curl -X GET http://localhost:8080/api/products
```

---

### 2. 根据ID获取商品详情

#### 请求
```
GET /api/products/{id}
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 商品ID |

#### 响应示例
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "iPhone 15 Pro",
    "description": "Apple最新旗舰手机，搭载A17 Pro芯片",
    "price": 7999.00,
    "stock": 50,
    "category": "手机数码",
    "imageUrl": "https://example.com/iphone15.jpg"
  }
}
```

#### 错误响应
```json
{
  "success": false,
  "message": "商品不存在: 999"
}
```

#### cURL示例
```bash
curl -X GET http://localhost:8080/api/products/1
```

---

### 3. 创建商品

#### 请求
```
POST /api/products
Content-Type: application/json
```

#### 请求体
```json
{
  "name": "新商品",
  "description": "商品描述",
  "price": 99.99,
  "stock": 100,
  "category": "分类名称",
  "imageUrl": "https://example.com/image.jpg"
}
```

#### 字段说明
| 字段 | 类型 | 必填 | 说明 | 验证规则 |
|------|------|------|------|----------|
| name | String | 是 | 商品名称 | 不能为空，最大255字符 |
| description | String | 否 | 商品描述 | 最大2000字符 |
| price | BigDecimal | 是 | 商品价格 | 必须大于0 |
| stock | Integer | 是 | 库存数量 | 不能为负数 |
| category | String | 否 | 商品分类 | 最大100字符 |
| imageUrl | String | 否 | 图片URL | 最大500字符 |

#### 响应示例
```json
{
  "success": true,
  "data": {
    "id": 11,
    "name": "新商品",
    "description": "商品描述",
    "price": 99.99,
    "stock": 100,
    "category": "分类名称",
    "imageUrl": "https://example.com/image.jpg"
  },
  "message": "商品创建成功"
}
```

#### 验证错误响应
```json
{
  "success": false,
  "message": "商品名称不能为空"
}
```

#### cURL示例
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "新商品",
    "description": "商品描述",
    "price": 99.99,
    "stock": 100,
    "category": "测试分类"
  }'
```

---

### 4. 更新商品

#### 请求
```
PUT /api/products/{id}
Content-Type: application/json
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 商品ID |

#### 请求体
```json
{
  "name": "更新后的商品名称",
  "description": "更新后的描述",
  "price": 199.99,
  "stock": 200,
  "category": "新分类",
  "imageUrl": "https://example.com/new-image.jpg"
}
```

#### 响应示例
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "更新后的商品名称",
    "description": "更新后的描述",
    "price": 199.99,
    "stock": 200,
    "category": "新分类",
    "imageUrl": "https://example.com/new-image.jpg"
  },
  "message": "商品更新成功"
}
```

#### cURL示例
```bash
curl -X PUT http://localhost:8080/api/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "更新后的商品",
    "price": 199.99,
    "stock": 200
  }'
```

---

### 5. 删除商品

#### 请求
```
DELETE /api/products/{id}
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 商品ID |

#### 响应示例
```json
{
  "success": true,
  "message": "商品删除成功"
}
```

#### 错误响应
```json
{
  "success": false,
  "message": "商品不存在: 999"
}
```

#### cURL示例
```bash
curl -X DELETE http://localhost:8080/api/products/1
```

---

### 6. 根据分类查询商品

#### 请求
```
GET /api/products/category/{category}
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| category | String | 是 | 商品分类 |

#### 响应示例
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "category": "手机数码",
      "price": 7999.00,
      "stock": 50
    }
  ],
  "total": 3
}
```

#### cURL示例
```bash
curl -X GET http://localhost:8080/api/products/category/手机数码
```

---

### 7. 搜索商品

#### 请求
```
GET /api/products/search?keyword={keyword}
```

#### 查询参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| keyword | String | 是 | 搜索关键词 |

#### 响应示例
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "description": "Apple最新旗舰手机",
      "price": 7999.00,
      "stock": 50
    }
  ],
  "total": 2
}
```

#### cURL示例
```bash
curl -X GET "http://localhost:8080/api/products/search?keyword=iPhone"
```

---

### 8. 上传图片

#### 请求
```
POST /api/upload/image
Content-Type: multipart/form-data
```

#### 请求参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| file | File | 是 | 图片文件 |

#### 限制说明
- **文件大小**: 最大5MB
- **文件类型**: 仅支持图片格式（image/*），如 jpg, png, gif, bmp 等
- **文件命名**: 系统自动生成UUID文件名，保留原始扩展名
- **存储路径**: `/app/uploads/images/`

#### 响应示例（成功）
```json
{
  "success": true,
  "url": "/uploads/images/550e8400-e29b-41d4-a716-446655440000.jpg",
  "message": "上传成功"
}
```

#### 错误响应
```json
{
  "success": false,
  "message": "文件不能为空"
}
```

```json
{
  "success": false,
  "message": "文件大小不能超过5MB"
}
```

```json
{
  "success": false,
  "message": "只能上传图片文件"
}
```

#### cURL示例
```bash
# Windows (PowerShell)
curl -X POST http://localhost:8080/api/upload/image -F "file=@C:\path\to\image.jpg"

# Linux/Mac
curl -X POST http://localhost:8080/api/upload/image -F "file=@/path/to/image.jpg"
```

#### 访问上传的图片
上传成功后，可以通过以下URL访问图片：
```
http://localhost:8080/uploads/images/{文件名}
```

---

## 状态码说明

| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 201 | 创建成功 |
| 400 | 请求参数错误 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 错误码说明

| 错误码 | 说明 |
|--------|------|
| PRODUCT_NOT_FOUND | 商品不存在 |
| INVALID_PARAMETER | 参数验证失败 |
| DATABASE_ERROR | 数据库错误 |

## 测试数据

系统初始化时会自动创建以下测试数据：

1. iPhone 15 Pro - ¥7999.00
2. MacBook Pro 14 - ¥14999.00
3. AirPods Pro 2 - ¥1899.00
4. iPad Air - ¥4799.00
5. Apple Watch Series 9 - ¥3199.00
6. 小米13 Ultra - ¥5999.00
7. 华为MateBook X Pro - ¥8999.00
8. 索尼WH-1000XM5 - ¥2499.00
9. 戴尔XPS 13 - ¥9999.00
10. 三星Galaxy S24 - ¥6999.00

## Postman集合

可以导入以下Postman集合进行测试：

```json
{
  "info": {
    "name": "电商API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "获取所有商品",
      "request": {
        "method": "GET",
        "url": "http://localhost:8080/api/products"
      }
    },
    {
      "name": "获取商品详情",
      "request": {
        "method": "GET",
        "url": "http://localhost:8080/api/products/1"
      }
    },
    {
      "name": "创建商品",
      "request": {
        "method": "POST",
        "url": "http://localhost:8080/api/products",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"name\": \"测试商品\",\n  \"price\": 99.99,\n  \"stock\": 100\n}"
        }
      }
    }
  ]
}
```

## 健康检查

### 应用健康检查
```
GET /actuator/health
```

响应示例：
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

### 应用信息
```
GET /actuator/info
```

## 注意事项

1. 所有价格使用BigDecimal类型，保留两位小数
2. 所有时间使用ISO 8601格式
3. 字符编码统一使用UTF-8
4. 建议使用HTTPS进行生产环境通信
5. API支持CORS跨域请求
