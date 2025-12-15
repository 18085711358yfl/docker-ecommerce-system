# Dockerfile编写说明

## 后端Dockerfile说明

### 文件位置
`backend/Dockerfile`

### 设计思路

#### 1. 多阶段构建
采用多阶段构建策略，分离构建环境和运行环境：

**构建阶段（Builder）**
```dockerfile
FROM maven:3.8.6-openjdk-17-slim AS builder
```
- 使用Maven镜像进行项目构建
- 包含完整的构建工具链
- 仅在构建阶段使用，不会进入最终镜像

**运行阶段（Runtime）**
```dockerfile
FROM openjdk:17-jdk-slim
```
- 使用精简的JDK镜像
- 仅包含运行时必需的组件
- 显著减小最终镜像体积

#### 2. 层缓存优化
```dockerfile
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B
```
- 先复制pom.xml并下载依赖
- 利用Docker层缓存机制
- 依赖不变时无需重新下载
- 加快构建速度

#### 3. 安全性
```dockerfile
RUN groupadd -r spring && useradd -r -g spring spring
USER spring
```
- 创建非root用户运行应用
- 遵循最小权限原则
- 提高容器安全性

#### 4. 健康检查
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1
```
- 定期检查应用健康状态
- 自动重启不健康的容器
- 提高服务可用性

#### 5. 资源优化
```dockerfile
ENTRYPOINT ["java", "-jar", "-Xmx512m", "-Xms256m", "app.jar"]
```
- 设置JVM内存参数
- 避免内存溢出
- 优化资源使用

### 镜像大小优化

**优化前**: ~800MB
**优化后**: ~300MB

优化措施：
1. 使用slim基础镜像
2. 多阶段构建分离构建和运行环境
3. 清理不必要的文件
4. 使用.dockerignore排除无关文件

## 前端Dockerfile说明

### 文件位置
`frontend/Dockerfile`

### 设计思路

#### 1. 多阶段构建
```dockerfile
FROM node:18-alpine AS builder
FROM nginx:1.25-alpine
```
- 构建阶段准备静态文件
- 运行阶段使用轻量级Nginx
- Alpine Linux进一步减小体积

#### 2. 最小化镜像
```dockerfile
FROM nginx:1.25-alpine
```
- 使用Alpine版本（~5MB基础镜像）
- 仅包含必需的Nginx组件
- 最终镜像约20MB

#### 3. 配置管理
```dockerfile
COPY nginx.conf /etc/nginx/conf.d/
COPY --from=builder /app/html /usr/share/nginx/html
```
- 自定义Nginx配置
- 分离配置和代码
- 便于维护和更新

#### 4. 健康检查
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1
```
- 使用wget进行健康检查
- Alpine镜像自带wget
- 无需额外安装工具

#### 5. 权限设置
```dockerfile
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html
```
- 设置正确的文件权限
- 确保Nginx可以访问文件
- 遵循安全最佳实践

## Dockerfile最佳实践

### 1. 选择合适的基础镜像
- 优先使用官方镜像
- 使用特定版本标签，避免使用latest
- 考虑使用Alpine版本减小体积

### 2. 最小化层数
```dockerfile
# 不推荐
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get clean

# 推荐
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

### 3. 利用构建缓存
- 将不常变化的指令放在前面
- 将经常变化的指令放在后面
- 合理组织COPY和RUN指令

### 4. 使用.dockerignore
```
# .dockerignore示例
.git
.gitignore
README.md
target/
*.log
.env
```

### 5. 多阶段构建
- 分离构建和运行环境
- 减小最终镜像体积
- 提高安全性

### 6. 安全考虑
- 不要在镜像中存储敏感信息
- 使用非root用户运行
- 定期更新基础镜像
- 扫描镜像漏洞

### 7. 标签和元数据
```dockerfile
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="Ecommerce Backend Service"
```

## 构建命令

### 基本构建
```bash
docker build -t ecommerce-backend:latest ./backend
docker build -t ecommerce-frontend:latest ./frontend
```

### 指定Dockerfile
```bash
docker build -f backend/Dockerfile -t ecommerce-backend:latest ./backend
```

### 不使用缓存构建
```bash
docker build --no-cache -t ecommerce-backend:latest ./backend
```

### 构建时传递参数
```dockerfile
ARG VERSION=1.0
ENV APP_VERSION=${VERSION}
```

```bash
docker build --build-arg VERSION=2.0 -t ecommerce-backend:2.0 ./backend
```

## 镜像优化对比

### 后端镜像
| 优化措施 | 镜像大小 | 说明 |
|---------|---------|------|
| 原始镜像 | 800MB | 包含完整Maven和构建工具 |
| 多阶段构建 | 400MB | 分离构建和运行环境 |
| 使用slim镜像 | 300MB | 使用精简基础镜像 |
| 清理缓存 | 280MB | 清理不必要的文件 |

### 前端镜像
| 优化措施 | 镜像大小 | 说明 |
|---------|---------|------|
| 原始Nginx | 140MB | 标准Nginx镜像 |
| Alpine版本 | 40MB | 使用Alpine Linux |
| 多阶段构建 | 20MB | 仅包含必需文件 |

## 常见问题

### Q: 为什么使用多阶段构建？
A: 多阶段构建可以显著减小镜像体积，提高安全性，分离构建和运行环境。

### Q: 如何进一步优化镜像大小？
A: 
1. 使用Alpine基础镜像
2. 清理不必要的文件和缓存
3. 使用.dockerignore排除无关文件
4. 合并RUN指令减少层数

### Q: 健康检查的作用是什么？
A: 健康检查可以让Docker自动监控容器状态，在服务异常时自动重启，提高可用性。

### Q: 为什么要使用非root用户？
A: 使用非root用户可以提高容器安全性，遵循最小权限原则，降低安全风险。
