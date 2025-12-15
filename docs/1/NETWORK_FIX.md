# Docker 网络连接问题解决方案

## 问题描述
无法连接到 Docker Hub (registry-1.docker.io)，导致无法拉取镜像。

## 解决方案

### 方案一：配置 Docker 镜像加速器（推荐）

#### 1. 使用国内镜像源

在 Docker Desktop 中配置镜像加速器：

**Windows Docker Desktop**:
1. 右键点击系统托盘的 Docker 图标
2. 选择 "Settings" (设置)
3. 选择 "Docker Engine"
4. 在 JSON 配置中添加：

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

5. 点击 "Apply & Restart"

#### 2. 验证配置

```cmd
docker info
```

查看输出中是否有 "Registry Mirrors" 部分。

### 方案二：使用代理

如果你有 VPN 或代理：

**Windows Docker Desktop**:
1. Settings → Resources → Proxies
2. 启用 "Manual proxy configuration"
3. 输入代理地址，例如：
   - HTTP Proxy: http://127.0.0.1:7890
   - HTTPS Proxy: http://127.0.0.1:7890
4. Apply & Restart

### 方案三：使用本地镜像（临时方案）

如果网络问题无法立即解决，可以使用已下载的镜像或修改为国内可用的镜像。

#### 修改 Dockerfile 使用国内基础镜像

**后端 Dockerfile**:
```dockerfile
# 使用阿里云镜像
FROM registry.cn-hangzhou.aliyuncs.com/library/maven:3.8.6-openjdk-17-slim AS builder
# ...
FROM registry.cn-hangzhou.aliyuncs.com/library/openjdk:17-jdk-slim
```

**前端 Dockerfile**:
```dockerfile
FROM registry.cn-hangzhou.aliyuncs.com/library/node:18-alpine AS builder
# ...
FROM registry.cn-hangzhou.aliyuncs.com/library/nginx:1.25-alpine
```

### 方案四：手动下载镜像

如果以上方案都不行，可以尝试手动拉取镜像：

```cmd
# 拉取 MySQL
docker pull mysql:8.0

# 拉取 Maven
docker pull maven:3.8.6-openjdk-17-slim

# 拉取 OpenJDK
docker pull openjdk:17-jdk-slim

# 拉取 Node
docker pull node:18-alpine

# 拉取 Nginx
docker pull nginx:1.25-alpine
```

### 方案五：检查网络和防火墙

1. **检查网络连接**:
```cmd
ping registry-1.docker.io
```

2. **检查 DNS**:
```cmd
nslookup registry-1.docker.io
```

3. **临时关闭防火墙测试**:
```cmd
# Windows (管理员权限)
netsh advfirewall set allprofiles state off
```

4. **检查 Docker 服务**:
```cmd
docker version
docker info
```

## 推荐步骤

### 第一步：配置镜像加速器

1. 打开 Docker Desktop Settings
2. 进入 Docker Engine
3. 添加以下配置：

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

4. 点击 "Apply & Restart"

### 第二步：重启 Docker

```cmd
# 重启 Docker Desktop
# 或在 PowerShell 中执行：
Restart-Service docker
```

### 第三步：验证

```cmd
# 测试拉取镜像
docker pull hello-world

# 如果成功，继续启动项目
cd E:\code\docker
scripts\start.bat
```

## 常见错误

### 错误 1: connectex: A connection attempt failed
**原因**: 网络连接超时
**解决**: 配置镜像加速器或使用代理

### 错误 2: dial tcp: lookup registry-1.docker.io
**原因**: DNS 解析失败
**解决**: 修改 DNS 为 8.8.8.8 或 114.114.114.114

### 错误 3: TLS handshake timeout
**原因**: HTTPS 连接问题
**解决**: 检查防火墙和代理设置

## 验证配置是否生效

```cmd
# 1. 查看 Docker 配置
docker info | findstr "Registry"

# 2. 测试拉取镜像
docker pull mysql:8.0

# 3. 如果成功，启动项目
docker-compose up -d
```

## 如果问题仍然存在

1. 检查是否在公司网络（可能有防火墙限制）
2. 尝试使用手机热点
3. 联系网络管理员
4. 使用离线镜像包

## 快速修复命令

```cmd
# 停止 Docker
net stop docker

# 启动 Docker
net start docker

# 或重启 Docker Desktop
taskkill /F /IM "Docker Desktop.exe"
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```
