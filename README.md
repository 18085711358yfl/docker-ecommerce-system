# 电商数据管理系统 - Docker容器化综合项目

[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)](https://www.docker.com/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.1.5-green)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

> 基于Docker容器化技术的电商数据管理系统，包含完整的前端、后端、数据库服务，以及CI/CD流水线、Kubernetes部署和监控系统。

---

##  目录

- [项目简介](#项目简介)
- [技术栈](#技术栈)
- [项目架构](#项目架构)
- [快速开始](#快速开始)
- [详细部署步骤](#详细部署步骤)
- [功能说明](#功能说明)
- [测试说明](#测试说明)
- [监控系统](#监控系统)
- [CI/CD流水线](#cicd流水线)
- [Kubernetes部署](#kubernetes部署)
- [GitHub集成](#github集成)
- [常见问题](#常见问题)
- [项目文档](#项目文档)
- [团队分工](#团队分工)

---

## 项目简介

本项目是一个完整的Docker容器化电商数据管理系统，实现了从开发到生产的全流程容器化实践。

###  项目目标

-  掌握Docker容器化技术
-  实现微服务架构设计
-  完整的CI/CD流水线
-  Kubernetes生产级部署
-  完善的监控和运维体系

###  项目亮点

1. **多阶段构建** - 镜像体积优化62.5% (800MB → 300MB)
2. **完整测试** - 6个单元测试，覆盖率≥80%
3. **健康检查** - 自动监控和故障恢复
4. **CI/CD** - 9个阶段的全自动化流水线
5. **K8s部署** - 支持蓝绿部署和金丝雀发布
6. **监控体系** - Prometheus + Grafana完整监控
7. **详细文档** - 11个技术文档

---

## 技术栈

### 前端
- **Nginx** 1.25-alpine - Web服务器
- **HTML/CSS/JavaScript** - 静态页面
- **响应式设计** - 支持多端访问

### 后端
- **Spring Boot** 3.1.5 - 应用框架
- **Spring Data JPA** - 数据访问层
- **MySQL Connector** - 数据库驱动
- **Spring Actuator** - 健康检查和监控
- **Lombok** - 简化代码

### 数据库
- **MySQL** 8.0 - 关系型数据库
- **UTF8MB4** - 字符集
- **InnoDB** - 存储引擎

### 容器化
- **Docker** 20.10+ - 容器引擎
- **Docker Compose** 2.0+ - 容器编排
- **多阶段构建** - 镜像优化

### CI/CD
- **Jenkins** - 持续集成/部署
- **Maven** - 构建工具
- **JUnit 5** - 单元测试
- **Mockito** - Mock框架

### 容器编排
- **Kubernetes** - 容器编排平台
- **kubectl** - K8s命令行工具
- **Ingress** - 流量入口

### 监控
- **Prometheus** - 监控数据采集
- **Grafana** - 数据可视化
- **MySQL Exporter** - MySQL监控
- **Actuator** - 应用监控

---

## 项目架构

### 系统架构图

```
┌─────────────────────────────────────────────────────────────┐
│                         用户层                               │
│                    (浏览器/移动端)                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      前端服务层                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Nginx (Alpine)                                     │   │
│  │  - 静态页面服务                                      │   │
│  │  - 反向代理                                          │   │
│  │  - Gzip压缩                                          │   │
│  │  - 健康检查                                          │   │
│  │  Port: 80                                           │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      后端服务层                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Spring Boot 3.1.5                                  │   │
│  │  ┌──────────────┐  ┌──────────────┐                │   │
│  │  │ Controller   │  │ Service      │                │   │
│  │  └──────────────┘  └──────────────┘                │   │
│  │  ┌──────────────┐  ┌──────────────┐                │   │
│  │  │ Repository   │  │ Entity       │                │   │
│  │  └──────────────┘  └──────────────┘                │   │
│  │  Port: 8080                                         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      数据库层                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  MySQL 8.0                                          │   │
│  │  - 数据持久化                                        │   │
│  │  - 自动初始化                                        │   │
│  │  - 健康检查                                          │   │
│  │  Port: 3306                                         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      监控层                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Prometheus   │  │  Grafana     │  │ MySQL        │     │
│  │ :9090        │  │  :3000       │  │ Exporter     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### 容器网络架构

```
┌─────────────────────────────────────────────────────────────┐
│              ecommerce-network (172.20.0.0/16)              │
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐ │
│  │  frontend    │───▶│   backend    │───▶│    mysql     │ │
│  │  (Nginx)     │    │ (Spring Boot)│    │  (MySQL 8)   │ │
│  └──────────────┘    └──────────────┘    └──────────────┘ │
│         │                    │                    │         │
│         │                    │                    │         │
│    ┌────▼────────────────────▼────────────────────▼─────┐  │
│    │              监控网络                              │  │
│    │  Prometheus ◀── Metrics ──▶ Grafana               │  │
│    └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 数据流向

```
用户请求 → Nginx (80) → 反向代理 → Spring Boot (8080) → MySQL (3306)
                                          ↓
                                    Prometheus (9090)
                                          ↓
                                    Grafana (3000)
```

---

## 快速开始

### 前置要求

- **Docker** 20.10+
- **Docker Compose** 2.0+
- **4GB+** 可用内存
- **10GB+** 可用磁盘空间

### ⚡ 一键启动（推荐）

**Windows 用户**:
```cmd
start.bat
```

**Linux/Mac 用户**:
```bash
chmod +x start.sh
./start.sh
```

### 启动脚本菜单

运行 `start.bat` 后会显示交互式菜单：

```
================================================================
              Docker E-commerce Management System
================================================================

Please select an option:

1. Full Start (Test + Build + Start + Monitor)
2. Quick Start (Skip Tests)
3. Run Tests Only
4. View Test Reports
5. Start Monitoring System
6. Verify All Functions
7. View Service Status
8. View Logs
9. Stop All Services
0. Exit
```

#### 功能说明

| 选项 | 功能 | 说明 |
|------|------|------|
| 1 | 完整启动 | 运行测试→构建镜像→启动服务→启动监控 |
| 2 | 快速启动 | 跳过测试，直接启动服务 |
| 3 | 仅运行测试 | 运行6个单元测试，生成测试报告 |
| 4 | 查看测试报告 | 打开测试报告目录或生成HTML报告 |
| 5 | 启动监控系统 | 启动Prometheus + Grafana |
| 6 | 验证所有功能 | 运行12项集成测试 |
| 7 | 查看服务状态 | 显示所有容器状态 |
| 8 | 查看日志 | 查看各服务日志 |
| 9 | 停止所有服务 | 停止并清理所有容器 |
| 0 | 退出 | 退出脚本 |

### 完整启动流程

选择 **选项1** 后，脚本会自动完成：

1. ✅ 环境检查（Docker、Docker Compose）
2. ✅ 运行单元测试（6个测试用例）
3. ✅ 清理旧容器
4. ✅ 构建Docker镜像
5. ✅ 启动所有服务（MySQL、Backend、Frontend）
6. ✅ 等待服务就绪（健康检查）
7. ✅ 启动监控系统（可选）
8. ✅ 显示访问地址

### 🌐 访问应用

启动成功后，访问以下地址：

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端页面 | http://localhost | 商品管理界面 |
| 后端API | http://localhost:8080/api/products | RESTful API |
| 健康检查 | http://localhost:8080/actuator/health | 服务健康状态 |
| Prometheus | http://localhost:9090 | 监控数据采集 |
| Grafana | http://localhost:3000 | 监控数据可视化 |

---

## 详细部署步骤

### 方法一：使用启动脚本（推荐）

这是最简单的方式，脚本会自动处理所有步骤。

```bash
# Windows
start.bat

# Linux/Mac
chmod +x start.sh && ./start.sh
```

### 方法二：手动部署（完整步骤）

#### 步骤1：环境准备

```bash
# 1. 检查Docker版本
docker --version
# 输出: Docker version 20.10.x 或更高

# 2. 检查Docker Compose版本
docker-compose --version
# 输出: Docker Compose version 2.x.x 或更高

# 3. 确保Docker服务运行中
docker ps
# 应该能正常显示容器列表
```

#### 步骤2：克隆项目（如果从GitHub）

```bash
# 克隆仓库
git clone https://github.com/your-username/docker-ecommerce-system.git

# 进入项目目录
cd docker-ecommerce-system
```

#### 步骤3：配置Docker镜像加速（可选但推荐）

**Windows (Docker Desktop)**:

1. 打开 Docker Desktop
2. 点击 Settings → Docker Engine
3. 添加以下配置：

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

4. 点击 "Apply & Restart"

**Linux**:

```bash
# 编辑Docker配置
sudo nano /etc/docker/daemon.json

# 添加以下内容
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com"
  ]
}

# 重启Docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```

#### 步骤4：运行单元测试（可选）

```bash
# 进入后端目录
cd backend

# 运行测试
mvn test

# 查看测试报告
# Windows: start target\surefire-reports\
# Linux: xdg-open target/surefire-reports/

# 返回项目根目录
cd ..
```

#### 步骤4.5：手动拉取Docker镜像（可选但推荐）

在构建自定义镜像之前，建议先手动拉取所需的基础镜像，这样可以：
- ✅ 提前发现网络问题
- ✅ 加快后续构建速度
- ✅ 确保使用正确的镜像版本

**拉取基础镜像**:

```bash
# 1. MySQL数据库镜像（用于数据存储）
docker pull mysql:8.0

# 2. Maven构建工具镜像（用于后端构建阶段）
docker pull maven:3.9-eclipse-temurin-17-alpine

# 3. Java运行时镜像（用于后端运行阶段）
docker pull eclipse-temurin:17-jre-alpine

# 4. Node.js镜像（用于前端构建阶段）
docker pull node:18-alpine

# 5. Nginx Web服务器镜像（用于前端运行）
docker pull nginx:1.25-alpine
```

**拉取监控系统镜像（如需使用监控功能）**:

```bash
# 6. Prometheus监控数据采集
docker pull prom/prometheus:latest

# 7. Grafana数据可视化
docker pull grafana/grafana:latest

# 8. MySQL Exporter数据库监控
docker pull prom/mysqld-exporter:latest
```

**验证镜像拉取成功**:

```bash
# 查看已拉取的镜像
docker images

# 应该能看到以下镜像：
# mysql                          8.0
# maven                          3.9-eclipse-temurin-17-alpine
# eclipse-temurin                17-jre-alpine
# node                           18-alpine
# nginx                          1.25-alpine
# prom/prometheus                latest
# grafana/grafana                latest
# prom/mysqld-exporter           latest
```

**镜像说明**:

| 镜像 | 版本 | 用途 | 大小（约） |
|------|------|------|-----------|
| `mysql` | 8.0 | 数据库服务 | 500MB |
| `maven` | 3.9-eclipse-temurin-17-alpine | 后端构建工具 | 400MB |
| `eclipse-temurin` | 17-jre-alpine | Java运行时环境 | 180MB |
| `node` | 18-alpine | 前端构建工具 | 180MB |
| `nginx` | 1.25-alpine | Web服务器 | 40MB |
| `prom/prometheus` | latest | 监控数据采集 | 250MB |
| `grafana/grafana` | latest | 监控可视化 | 350MB |
| `prom/mysqld-exporter` | latest | MySQL监控导出器 | 20MB |

**注意事项**:

1. **网络问题**: 如果拉取速度慢，请配置Docker镜像加速器（见步骤3）
2. **磁盘空间**: 确保有足够的磁盘空间（至少10GB）
3. **镜像标签**: 使用指定版本标签可以确保环境一致性
4. **离线环境**: 可以使用`docker save`和`docker load`在离线环境中传输镜像

**离线镜像导出/导入（可选）**:

```bash
# 导出所有镜像到tar文件
docker save -o docker-images.tar \
  mysql:8.0 \
  maven:3.9-eclipse-temurin-17-alpine \
  eclipse-temurin:17-jre-alpine \
  node:18-alpine \
  nginx:1.25-alpine \
  prom/prometheus:latest \
  grafana/grafana:latest \
  prom/mysqld-exporter:latest

# 在另一台机器上导入镜像
docker load -i docker-images.tar
```

#### 步骤5：构建Docker镜像

```bash
# 构建所有镜像
docker-compose build

# 或者单独构建
docker-compose build frontend
docker-compose build backend

# 查看构建的镜像
docker images | grep docker
```

#### 步骤6：启动服务

```bash
# 启动所有服务（后台运行）
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

#### 步骤7：等待服务就绪

```bash
# 等待MySQL就绪（约30秒）
docker-compose exec mysql mysqladmin ping -h localhost -u root -proot123456

# 等待后端就绪（约60秒）
curl http://localhost:8080/actuator/health

# 检查前端
curl http://localhost
```

#### 步骤8：验证服务

```bash
# 1. 检查所有容器状态
docker-compose ps
# 所有服务应该显示 "Up" 和 "healthy"

# 2. 测试前端
curl http://localhost

# 3. 测试后端API
curl http://localhost:8080/api/products

# 4. 测试健康检查
curl http://localhost:8080/actuator/health

# 5. 查看数据库
docker-compose exec mysql mysql -u root -proot123456 -e "USE ecommerce; SELECT COUNT(*) FROM products;"
```

#### 步骤9：启动监控系统（可选）

```bash
# 启动监控服务
docker-compose -f monitoring/docker-compose-monitoring.yml up -d

# 查看监控服务状态
docker-compose -f monitoring/docker-compose-monitoring.yml ps

# 访问监控界面
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000 (admin/admin123)
```

#### 步骤10：停止服务

```bash
# 停止所有服务
docker-compose down

# 停止监控服务
docker-compose -f monitoring/docker-compose-monitoring.yml down

# 停止并删除数据卷（慎用！会删除所有数据）
docker-compose down -v
```

---

## 功能说明

### 1. 前端功能

#### 页面列表
- **首页** (`index.html`) - 商品展示和搜索
- **商品列表** (`product-list.html`) - 商品管理
- **商品详情** (`product-detail.html`) - 商品详细信息
- **图片上传** (`upload-test.html`) - 图片上传测试

#### 功能特性
- ✅ 商品列表展示
- ✅ 商品搜索和筛选
- ✅ 商品详情查看
- ✅ 商品增删改查
- ✅ 图片上传和预览
- ✅ 响应式设计

### 2. 后端API

#### API端点

| 方法 | 路径 | 描述 | 示例 |
|------|------|------|------|
| GET | `/api/products` | 获取所有商品 | `curl http://localhost:8080/api/products` |
| GET | `/api/products/{id}` | 获取商品详情 | `curl http://localhost:8080/api/products/1` |
| POST | `/api/products` | 创建商品 | 见下方示例 |
| PUT | `/api/products/{id}` | 更新商品 | 见下方示例 |
| DELETE | `/api/products/{id}` | 删除商品 | `curl -X DELETE http://localhost:8080/api/products/1` |
| GET | `/api/products/search` | 搜索商品 | `curl http://localhost:8080/api/products/search?keyword=手机` |
| GET | `/api/products/category/{category}` | 分类查询 | `curl http://localhost:8080/api/products/category/电子产品` |
| POST | `/api/upload/image` | 上传图片 | 见下方示例 |

#### API使用示例
**创建商品**:
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iPhone 15 Pro",
    "description": "最新款iPhone",
    "price": 7999.00,
    "stock": 100,
    "category": "电子产品",
    "imageUrl": "/uploads/images/iphone15.jpg"
  }'
```

**更新商品**:
```bash
curl -X PUT http://localhost:8080/api/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iPhone 15 Pro Max",
    "price": 8999.00,
    "stock": 50
  }'
```

**上传图片**:
```bash
curl -X POST http://localhost:8080/api/upload/image \
  -F "file=@/path/to/image.jpg"
```

### 3. 数据库

#### 数据库配置
- **数据库名**: ecommerce
- **用户名**: ecommerce_user
- **密码**: ecommerce_pass
- **端口**: 3307 (映射到容器内3306)
- **字符集**: UTF8MB4
- **时区**: Asia/Shanghai

#### 数据表结构

**products表**:
```sql
CREATE TABLE products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category VARCHAR(100),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 连接数据库

```bash
# 方法1: 通过Docker容器
docker-compose exec mysql mysql -u root -proot123456

# 方法2: 通过本地MySQL客户端
mysql -h 127.0.0.1 -P 3307 -u ecommerce_user -pecommerce_pass ecommerce

# 常用SQL命令
USE ecommerce;
SHOW TABLES;
SELECT * FROM products;
DESCRIBE products;
```

---

## 测试说明

### 单元测试

#### 运行测试

```bash
# 方法1: 使用启动脚本（推荐）
start.bat
# 然后选择: 3. Run Tests Only

# 方法2: 使用Maven
cd backend
mvn test

# 方法3: 运行特定测试类
mvn test -Dtest=ProductServiceTest

# 方法4: 跳过测试
mvn package -DskipTests
```

#### 测试用例

项目包含 **6个单元测试用例**，覆盖所有核心功能：

1. ✅ `testGetAllProducts()` - 测试获取所有商品
2. ✅ `testGetProductById()` - 测试获取单个商品
3. ✅ `testCreateProduct()` - 测试创建商品
4. ✅ `testUpdateProduct()` - 测试更新商品
5. ✅ `testDeleteProduct()` - 测试删除商品
6. ✅ `testGetProductByIdNotFound()` - 测试异常处理

#### 测试报告

测试报告位置：
```
backend/target/surefire-reports/
├── TEST-com.ecommerce.ProductServiceTest.xml    # XML格式
├── com.ecommerce.ProductServiceTest.txt         # 文本格式
└── [时间戳].dumpstream                           # 详细日志
```

#### 生成HTML测试报告

```bash
cd backend

# 生成HTML报告
mvn surefire-report:report

# 打开报告
# Windows: start target\site\surefire-report.html
# Linux: xdg-open target/site/surefire-report.html
```

#### 测试覆盖率

```bash
# 生成覆盖率报告（需要配置jacoco插件）
mvn jacoco:report

# 查看报告
# Windows: start target\site\jacoco\index.html
# Linux: xdg-open target/site/jacoco/index.html
```

### 集成测试

```bash
# 方法1: 使用启动脚本（推荐）
start.bat
# 然后选择: 6. Verify All Functions
# 会自动运行12项集成测试，包括：
#   - 前端服务测试
#   - 后端API测试
#   - 数据库连接测试
#   - 健康检查测试
#   - 单元测试
#   - 网络和数据卷检查

# 方法2: 手动测试步骤
# 1. 测试前端
curl http://localhost

# 2. 测试后端API
curl http://localhost:8080/api/products

# 3. 测试健康检查
curl http://localhost:8080/actuator/health

# 4. 测试数据库连接
docker-compose exec mysql mysql -u root -proot123456 -e "SELECT 1"
```

### 查看测试报告

```bash
# 使用启动脚本
start.bat
# 然后选择: 4. View Test Reports
# 可以选择：
#   1. 打开测试报告目录
#   2. 生成HTML测试报告
#   3. 查看测试覆盖率
```

---

## 监控系统

### 启动监控

#### 方法1: 使用启动脚本（推荐）
```bash
start.bat
# 然后选择: 5. Start Monitoring System
```

#### 方法2: 手动启动
```bash
docker-compose -f monitoring/docker-compose-monitoring.yml up -d
```

### 监控组件

#### 1. Prometheus (数据采集)

**访问地址**: http://localhost:9090

**功能**:
- 监控指标采集
- 数据查询和分析
- 告警规则配置

**常用查询**:
```promql
# 查看服务是否在线
up

# CPU使用率
process_cpu_usage

# 内存使用
jvm_memory_used_bytes

# HTTP请求数
http_server_requests_seconds_count

# HTTP请求耗时
http_server_requests_seconds_sum
```

#### 2. Grafana (数据可视化)

**访问地址**: http://localhost:3000  
**用户名**: admin  
**密码**: admin123

**配置步骤**:

1. **添加数据源**:
   - 点击 Configuration → Data Sources
   - 点击 Add data source
   - 选择 Prometheus
   - URL填写: `http://prometheus:9090`
   - 点击 Save & Test

2. **创建仪表板**:
   - 点击 + → Dashboard
   - 点击 Add new panel
   - 选择指标创建图表
   - 保存仪表板

3. **导入仪表板**:
   - 点击 + → Import
   - 输入仪表板ID（如：12900 for Spring Boot）
   - 选择Prometheus数据源
   - 点击 Import

#### 3. MySQL Exporter (数据库监控)

**端口**: 9104

**监控指标**:
- MySQL连接数
- 查询数
- 慢查询
- 数据库大小

### 监控指标说明

#### 应用指标
| 指标 | 说明 |
|------|------|
| `jvm_memory_used_bytes` | JVM内存使用 |
| `jvm_threads_live` | 活跃线程数 |
| `process_cpu_usage` | CPU使用率 |
| `http_server_requests_seconds_count` | HTTP请求总数 |
| `http_server_requests_seconds_sum` | HTTP请求总耗时 |

#### 数据库指标
| 指标 | 说明 |
|------|------|
| `mysql_up` | MySQL是否在线 |
| `mysql_global_status_connections` | 连接数 |
| `mysql_global_status_queries` | 查询数 |
| `mysql_global_status_slow_queries` | 慢查询数 |

---

## CI/CD流水线

### Jenkins配置

#### 1. 安装Jenkins

**使用Docker运行Jenkins**:
```bash
docker run -d \
  --name jenkins \
  -p 8081:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

#### 2. 初始化Jenkins

```bash
# 获取初始密码
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# 访问Jenkins
# http://localhost:8081
```

#### 3. 安装插件

必需插件：
- Docker Pipeline  
- Git
- Maven Integration 
- JUnit
- Pipeline

#### 4. 配置Jenkins

**访问Jenkins**: 打开浏览器访问 `http://localhost:8081`

##### 4.1 配置Docker

1. 点击左侧菜单 **Manage Jenkins**（管理Jenkins）
2. 点击 **Global Tool Configuration**（全局工具配置）
3. 滚动到 **Docker** 部分
4. 点击 **Add Docker** 按钮
5. 配置如下：
   - **Name**: `Docker`（或任意名称）
   - **Docker installation root**: `/usr/local/bin`（默认值即可）
   - ✅ **Install automatically** - 勾选此选项
   - **Docker version**: 选择最新版本（如 `latest`）
6. 点击 **Save**（保存）

**说明**：如果Jenkins运行在Docker容器中，Docker命令会通过 `/var/run/docker.sock` 访问宿主机的Docker，所以这里主要是为了Jenkins能够识别Docker命令。

##### 4.2 配置Maven

1. 在 **Global Tool Configuration** 页面
2. 滚动到 **Maven** 部分
3. 点击 **Add Maven** 按钮
4. 配置如下：
   - **Name**: `Maven`（或任意名称，后续流水线中会用到）
   - ✅ **Install automatically** - 勾选此选项
   - **Maven version**: 选择 `3.9.5` 或最新版本
   - **Maven mirror**: 可以填入 `https://maven.aliyun.com/repository/public`（国内镜像加速）
5. 点击 **Save**（保存）

##### 4.3 配置凭证（Credentials）

**配置Docker Hub凭证**（如果需要推送镜像）：

1. 点击 **Manage Jenkins** → **Manage Credentials**（管理凭证）
2. 点击 **System**（系统）
3. 点击 **Global credentials (unrestricted)**（全局凭证）
4. 点击左侧 **Add Credentials**（添加凭证）
5. 配置如下：
   - **Kind**: Username with password
   - **Scope**: Global
   - **Username**: 你的Docker Hub用户名
   - **Password**: 你的Docker Hub密码或Access Token
   - **ID**: `docker-hub-credentials`（重要：必须与Jenkinsfile中的ID一致）
   - **Description**: Docker Hub Credentials
6. 点击 **Create**（创建）

**配置Git凭证**（如果仓库需要认证）：

1. 再次点击 **Add Credentials**
2. 配置如下：
   - **Kind**: SSH Username with private key（SSH）或 Username with password（HTTPS）
   - **Username**: Git用户名
   - **Private Key** 或 **Password**: 根据选择类型填写
   - **ID**: `git-credentials`（或自定义）
   - **Description**: Git Credentials
3. 点击 **Create**（创建）

**说明**：如果Git仓库是公开的（public），可以不配置Git凭证。

#### 5. 创建流水线任务

1. **创建新任务**：
   - 点击左侧菜单 **New Item**（新建任务）
   - 输入任务名称，例如：`ecommerce-pipeline`
   - 选择 **Pipeline**（流水线）
   - 点击 **OK**

2. **配置流水线**：
   - 在任务配置页面，向下滚动到 **Pipeline** 部分
   - **Definition**（定义）：选择 **Pipeline script from SCM**
   - **SCM**：选择 **Git**
   - **Repository URL**：填写你的Git仓库地址
     - 例如：`https://github.com/your-username/docker-ecommerce-system.git`
     - 或SSH地址：`git@github.com:your-username/docker-ecommerce-system.git`
   - **Credentials**（凭证）：如果仓库是私有的，选择刚才配置的Git凭证
   - **Branch Specifier**（分支）：`*/main` 或 `*/master`（默认值）
   - **Script Path**：`jenkins/Jenkinsfile`（重要：指向项目中的Jenkinsfile路径）

3. **保存配置**：
   - 点击页面底部的 **Save**（保存）

4. **运行流水线**：
   - 在任务页面，点击左侧 **Build Now**（立即构建）
   - 或者配置 **GitHub Webhook** 实现自动触发（推送代码时自动构建）

**注意事项**：
- 确保Jenkinsfile路径正确（`jenkins/Jenkinsfile`）
- 如果使用私有Git仓库，必须先配置Git凭证
- Docker Hub凭证ID必须与Jenkinsfile中的 `DOCKER_CREDENTIALS_ID` 一致
- 确保Jenkins有权限访问Docker（已通过 `-v /var/run/docker.sock:/var/run/docker.sock` 挂载）

### 流水线说明

项目包含 **10个阶段** 的完整CI/CD流水线（配置文件：`jenkins/Jenkinsfile`）：

#### 流水线阶段

```
1. 代码检出 (Checkout)
   ↓
2. 后端单元测试 (Unit Test)
   ├─ 运行Maven测试
   └─ 生成JUnit测试报告
   ↓
3. 代码质量检查 (Code Quality)
   └─ Checkstyle代码规范检查
   ↓
4. 构建后端镜像 (Build Backend Image)
   └─ 多阶段Docker构建
   ↓
5. 构建前端镜像 (Build Frontend Image)
   └─ Nginx镜像构建
   ↓
6. 镜像安全扫描 (Security Scan)
   └─ 使用Trivy扫描漏洞
   ↓
7. 集成测试 (Integration Test)
   ├─ 启动测试环境
   ├─ 健康检查验证
   └─ 自动清理
   ↓
8. 推送镜像到仓库 (Push Images)
   └─ 推送到Docker Hub（仅main分支）
   ↓
9. 部署到测试/生产环境 (Deploy)
   ├─ develop分支 → 测试环境
   └─ main分支 → 生产环境（需人工确认）
   ↓
10. 健康检查 (Health Check)
    ├─ 前端服务验证
    └─ 后端API验证
```

#### 关键特性

✅ **自动化测试** - 每次构建自动运行6个单元测试  
✅ **测试报告** - 自动生成JUnit XML测试报告  
✅ **代码质量** - Checkstyle代码规范检查  
✅ **安全扫描** - Trivy镜像漏洞扫描  
✅ **集成测试** - 自动验证服务健康状态  
✅ **分支策略** - develop→测试环境，main→生产环境  
✅ **人工审批** - 生产部署需要手动确认  
✅ **失败通知** - 构建失败自动通知

#### 流水线配置文件

查看 `jenkins/Jenkinsfile` 了解完整配置

### 手动触发流水线

```bash
# 1. 提交代码
git add .
git commit -m "feat: add new feature"
git push origin main

# 2. Jenkins自动触发构建
# 或手动点击 "Build Now"

# 3. 查看构建日志
# Jenkins → 项目 → Build History → Console Output
```

---

## Kubernetes部署

### 前置要求

```bash
# 安装kubectl
# Windows (使用Chocolatey)
choco install kubernetes-cli

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# 验证安装
kubectl version --client
```

### 部署步骤

#### 1. 创建命名空间

```bash
kubectl apply -f k8s/namespace.yaml

# 验证
kubectl get namespaces
```

#### 2. 创建Secret

```bash
# 创建MySQL密钥
kubectl create secret generic mysql-secret \
  --from-literal=username=ecommerce_user \
  --from-literal=password=ecommerce_pass \
  -n ecommerce

# 验证
kubectl get secrets -n ecommerce
```

#### 3. 部署MySQL

```bash
kubectl apply -f k8s/mysql-deployment.yaml

# 查看部署状态
kubectl get pods -n ecommerce
kubectl get svc -n ecommerce

# 查看日志
kubectl logs -f deployment/mysql -n ecommerce
```

#### 4. 部署后端

```bash
kubectl apply -f k8s/backend-deployment.yaml

# 查看部署状态
kubectl get pods -n ecommerce -l app=backend

# 查看日志
kubectl logs -f deployment/backend -n ecommerce
```

#### 5. 部署前端

```bash
kubectl apply -f k8s/frontend-deployment.yaml

# 查看部署状态
kubectl get pods -n ecommerce -l app=frontend
```

#### 6. 配置Ingress

```bash
kubectl apply -f k8s/ingress.yaml

# 查看Ingress
kubectl get ingress -n ecommerce
```

#### 7. 验证部署

```bash
# 查看所有资源
kubectl get all -n ecommerce

# 查看Pod详情
kubectl describe pod <pod-name> -n ecommerce

# 查看服务
kubectl get svc -n ecommerce

# 端口转发测试
kubectl port-forward svc/frontend 8080:80 -n ecommerce
```

### 蓝绿部署

```bash
# 1. 部署蓝色版本（当前生产版本）
kubectl apply -f k8s/blue-green-deployment.yaml

# 2. 验证蓝色版本
kubectl get pods -n ecommerce -l version=blue

# 3. 部署绿色版本（新版本）
# 修改 blue-green-deployment.yaml 中的 Service selector
# version: blue → version: green

# 4. 切换流量到绿色版本
kubectl apply -f k8s/blue-green-deployment.yaml

# 5. 验证新版本
curl http://<ingress-ip>/api/products

# 6. 如果有问题，快速回滚到蓝色版本
# 修改 Service selector: version: green → version: blue
kubectl apply -f k8s/blue-green-deployment.yaml
```

### 金丝雀部署

```bash
# 1. 部署稳定版本（90%流量）
kubectl apply -f k8s/canary-deployment.yaml

# 2. 查看Pod分布
kubectl get pods -n ecommerce -l app=backend

# 3. 验证流量分配
# 稳定版本: 9个Pod
# 金丝雀版本: 1个Pod
# 流量比例: 90% vs 10%

# 4. 监控金丝雀版本
kubectl logs -f deployment/backend-canary -n ecommerce

# 5. 如果金丝雀版本正常，逐步增加流量
# 修改副本数: stable 6, canary 4 (60% vs 40%)
kubectl scale deployment backend-stable --replicas=6 -n ecommerce
kubectl scale deployment backend-canary --replicas=4 -n ecommerce

# 6. 最终全部切换到新版本
kubectl scale deployment backend-stable --replicas=0 -n ecommerce
kubectl scale deployment backend-canary --replicas=10 -n ecommerce
```

### K8s常用命令

```bash
# 查看资源
kubectl get pods -n ecommerce
kubectl get svc -n ecommerce
kubectl get deployments -n ecommerce

# 查看详情
kubectl describe pod <pod-name> -n ecommerce
kubectl describe svc <service-name> -n ecommerce

# 查看日志
kubectl logs <pod-name> -n ecommerce
kubectl logs -f <pod-name> -n ecommerce  # 实时查看

# 进入容器
kubectl exec -it <pod-name> -n ecommerce -- /bin/sh

# 删除资源
kubectl delete pod <pod-name> -n ecommerce
kubectl delete deployment <deployment-name> -n ecommerce

# 扩缩容
kubectl scale deployment backend --replicas=5 -n ecommerce

# 更新镜像
kubectl set image deployment/backend backend=new-image:tag -n ecommerce

# 回滚
kubectl rollout undo deployment/backend -n ecommerce
kubectl rollout history deployment/backend -n ecommerce
```

---

## GitHub集成

### 1. 创建GitHub仓库

```bash
# 在GitHub上创建新仓库
# Repository name: docker-ecommerce-system
# Description: 基于Docker容器化技术的电商数据管理系统
# Public/Private: 选择Public
# 不要初始化README（因为本地已有）
```

### 2. 初始化Git仓库

```bash
# 初始化Git（如果还没有）
git init

# 配置用户信息
git config user.name "Your Name"
git config user.email "your.email@example.com"

# 查看当前状态
git status
```

### 3. 添加.gitignore

项目已包含`.gitignore`文件，确保以下内容被忽略：

```gitignore
# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup

# IDE
.idea/
*.iml
.vscode/
*.swp
*.swo

# Docker
*.log

# OS
.DS_Store
Thumbs.db

# 敏感信息
*.env
.env.local
```

### 4. 提交代码

```bash
# 添加所有文件
git add .

# 提交
git commit -m "feat: initial commit - Docker电商数据管理系统"

# 查看提交历史
git log --oneline
```

### 5. 推送到GitHub

```bash
# 添加远程仓库
git remote add origin https://github.com/your-username/docker-ecommerce-system.git

# 推送到main分支
git branch -M main
git push -u origin main

# 验证
git remote -v
```

### 6. 分支管理策略

```bash
# 创建开发分支
git checkout -b develop

# 创建功能分支
git checkout -b feature/new-feature

# 完成功能后合并到develop
git checkout develop
git merge feature/new-feature

# 发布到main
git checkout main
git merge develop
git push origin main
```

### 7. GitHub Actions (CI/CD)

创建 `.github/workflows/docker-build.yml`:

```yaml
name: Docker Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Run tests
        run: |
          cd backend
          mvn test
      
      - name: Upload test results
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: backend/target/surefire-reports/

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        run: |
          docker-compose build
          docker-compose push
```

### 8. 配置GitHub Secrets

1. 进入仓库 Settings → Secrets and variables → Actions
2. 添加以下Secrets:
   - `DOCKER_USERNAME`: Docker Hub用户名
   - `DOCKER_PASSWORD`: Docker Hub密码/Token

### 9. 创建README徽章

在README.md顶部添加：

```markdown
[![Build Status](https://github.com/your-username/docker-ecommerce-system/workflows/Docker%20Build%20and%20Test/badge.svg)](https://github.com/your-username/docker-ecommerce-system/actions)
[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)
```

### 10. 发布Release

```bash
# 创建标签
git tag -a v1.0.0 -m "Release version 1.0.0"

# 推送标签
git push origin v1.0.0

# 在GitHub上创建Release
# 进入 Releases → Create a new release
# 选择标签 v1.0.0
# 填写Release notes
# 上传构建产物（可选）
# 点击 Publish release
```

---

## 常见问题

### Q1: 服务启动失败

**问题**: 运行`docker-compose up`后服务无法启动

**解决方案**:
```bash
# 1. 查看详细日志
docker-compose logs backend
docker-compose logs mysql

# 2. 检查端口占用
netstat -ano | findstr "80"
netstat -ano | findstr "8080"
netstat -ano | findstr "3307"

# 3. 清理并重新构建
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

### Q2: 镜像构建慢

**问题**: Docker镜像构建非常慢

**解决方案**:
```bash
# 配置Docker镜像加速器（见详细部署步骤）
# 或使用国内Maven镜像（已在Dockerfile中配置）
```

### Q3: 数据库连接失败

**问题**: 后端无法连接到MySQL

**解决方案**:
```bash
# 1. 检查MySQL是否就绪
docker-compose exec mysql mysqladmin ping -h localhost -u root -proot123456

# 2. 检查网络连接
docker network inspect docker_ecommerce-network

# 3. 查看MySQL日志
docker-compose logs mysql

# 4. 手动测试连接
docker-compose exec backend sh
ping mysql
```

### Q4: 前端无法访问后端

**问题**: 前端页面无法调用后端API

**解决方案**:
```bash
# 1. 检查Nginx配置
docker-compose exec frontend cat /etc/nginx/conf.d/nginx.conf

# 2. 检查后端是否运行
curl http://localhost:8080/actuator/health

# 3. 检查容器网络
docker network inspect docker_ecommerce-network
```

### Q5: 测试失败

**问题**: 运行`mvn test`失败

**解决方案**:
```bash
# 1. 清理Maven缓存
cd backend
mvn clean

# 2. 重新下载依赖
mvn dependency:purge-local-repository

# 3. 跳过测试构建
mvn package -DskipTests

# 4. 查看详细错误
mvn test -X
```

### Q6: 监控系统无法访问

**问题**: Prometheus或Grafana无法访问

**解决方案**:
```bash
# 1. 检查监控服务状态
docker-compose -f monitoring/docker-compose-monitoring.yml ps

# 2. 检查网络
docker network ls | grep ecommerce

# 3. 重启监控服务
docker-compose -f monitoring/docker-compose-monitoring.yml restart

# 4. 查看日志
docker-compose -f monitoring/docker-compose-monitoring.yml logs
```

### Q7: K8s部署失败

**问题**: Kubernetes部署失败

**解决方案**:
```bash
# 1. 检查kubectl连接
kubectl cluster-info

# 2. 查看Pod状态
kubectl get pods -n ecommerce

# 3. 查看Pod详情
kubectl describe pod <pod-name> -n ecommerce

# 4. 查看日志
kubectl logs <pod-name> -n ecommerce

# 5. 删除并重新部署
kubectl delete -f k8s/
kubectl apply -f k8s/
```

---

## 项目文档

| 文档 | 说明 |
|------|------|
| [README.md](README.md) | 项目说明（本文档） |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | 项目总结报告 |
| [PROJECT_CHECKLIST.md](PROJECT_CHECKLIST.md) | 项目完成度检查清单 |
| [PROJECT_EVALUATION_REPORT.md](PROJECT_EVALUATION_REPORT.md) | 项目评估报告 |
| [操作指南-如何查看测试和监控.md](操作指南-如何查看测试和监控.md) | 测试和监控操作指南 |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | 系统架构文档 |
| [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) | 部署指南 |
| [docs/DOCKERFILE_GUIDE.md](docs/DOCKERFILE_GUIDE.md) | Dockerfile编写指南 |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | 故障排查文档 |
| [docs/API_DOCUMENTATION.md](docs/API_DOCUMENTATION.md) | API接口文档 |
| [docs/TEAM_CONTRIBUTION.md](docs/TEAM_CONTRIBUTION.md) | 团队分工明细 |
| [docs/VIDEO_SCRIPT.md](docs/VIDEO_SCRIPT.md) | 演示视频脚本 |

---

## 团队分工

| 成员 | 职责 | 贡献度 |
|------|------|--------|
| 成员A | 前端开发、容器编排、文档编写 | 33% |
| 成员B | 后端开发、数据库、DevOps | 33% |
| 成员C | CI/CD、K8s部署、监控系统 | 34% |

详细分工请查看: [docs/TEAM_CONTRIBUTION.md](docs/TEAM_CONTRIBUTION.md)

---

## 项目结构

```
docker-ecommerce-system/
├── frontend/                      # 前端服务
│   ├── Dockerfile                # 前端Docker配置
│   ├── nginx.conf                # Nginx配置
│   └── html/                     # 静态页面
│       ├── index.html
│       ├── product-list.html
│       ├── product-detail.html
│       └── upload-test.html
├── backend/                       # 后端服务
│   ├── Dockerfile                # 后端Docker配置
│   ├── pom.xml                   # Maven配置
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/ecommerce/
│   │   │   │       ├── controller/
│   │   │   │       ├── service/
│   │   │   │       ├── repository/
│   │   │   │       ├── entity/
│   │   │   │       ├── dto/
│   │   │   │       └── config/
│   │   │   └── resources/
│   │   │       └── application.yml
│   │   └── test/
│   │       └── java/
│   │           └── com/ecommerce/
│   │               └── ProductServiceTest.java
│   └── target/                   # 编译输出
│       └── surefire-reports/     # 测试报告
├── database/                      # 数据库
│   └── init.sql                  # 初始化脚本
├── k8s/                          # Kubernetes配置
│   ├── namespace.yaml
│   ├── mysql-deployment.yaml
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   ├── ingress.yaml
│   ├── blue-green-deployment.yaml
│   └── canary-deployment.yaml
├── jenkins/                       # Jenkins配置
│   └── Jenkinsfile               # 流水线配置
├── monitoring/                    # 监控配置
│   ├── docker-compose-monitoring.yml
│   └── prometheus.yml
├── docs/                         # 文档目录
│   ├── ARCHITECTURE.md
│   ├── DEPLOYMENT.md
│   ├── DOCKERFILE_GUIDE.md
│   ├── TROUBLESHOOTING.md
│   ├── API_DOCUMENTATION.md
│   ├── TEAM_CONTRIBUTION.md
│   └── VIDEO_SCRIPT.md
├── .github/                      # GitHub配置
│   └── workflows/
│       └── docker-build.yml
├── docker-compose.yml            # Docker Compose配置
├── .gitignore                    # Git忽略文件
├── start.bat / start.sh          # 启动脚本（集成所有功能）
├── stop.bat / stop.sh            # 停止脚本
├── README.md                     # 项目说明
├── PROJECT_SUMMARY.md            # 项目总结
├── PROJECT_CHECKLIST.md          # 完成度检查
├── PROJECT_EVALUATION_REPORT.md  # 评估报告
├── 操作指南-如何查看测试和监控.md    # 操作指南
└── LICENSE                       # 许可证
```

---

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 联系方式

- **项目地址**: https://github.com/your-username/docker-ecommerce-system
- **问题反馈**: https://github.com/your-username/docker-ecommerce-system/issues
- **邮箱**: your.email@example.com

---

## 致谢

感谢所有为本项目做出贡献的团队成员！

---

**最后更新**: 2025-12-13  
**版本**: v1.0.0
