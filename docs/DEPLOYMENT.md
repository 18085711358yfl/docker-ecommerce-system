# 部署和运行指南

## 前置要求

### 软件要求
- Docker 20.10 或更高版本
- Docker Compose 2.0 或更高版本
- Git
- 至少 4GB 可用内存
- 至少 10GB 可用磁盘空间

### 检查环境
```bash
# 检查Docker版本
docker --version

# 检查Docker Compose版本
docker-compose --version

# 检查Docker服务状态
docker ps
```

## 快速开始

### 1. 克隆项目
```bash
git clone <repository-url>
cd docker-ecommerce-system
```

### 2. 启动所有服务
```bash
# 构建并启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 3. 验证部署
```bash
# 检查前端服务
curl http://localhost:80

# 检查后端服务
curl http://localhost:8080/actuator/health

# 检查数据库连接
docker-compose exec mysql mysql -u ecommerce_user -pecommerce_pass -e "USE ecommerce; SELECT COUNT(*) FROM products;"
```

### 4. 访问应用
- 前端页面: http://localhost:80
- 后端API: http://localhost:8080/api/products
- 健康检查: http://localhost:8080/actuator/health

## 详细部署步骤

### 开发环境部署

#### 1. 构建镜像
```bash
# 构建后端镜像
cd backend
docker build -t ecommerce-backend:latest .

# 构建前端镜像
cd ../frontend
docker build -t ecommerce-frontend:latest .
```

#### 2. 创建网络
```bash
docker network create ecommerce-network
```

#### 3. 启动MySQL
```bash
docker-compose up -d mysql

# 等待MySQL就绪
docker-compose logs -f mysql
```

#### 4. 启动后端
```bash
docker-compose up -d backend

# 查看后端日志
docker-compose logs -f backend
```

#### 5. 启动前端
```bash
docker-compose up -d frontend

# 查看前端日志
docker-compose logs -f frontend
```

### 生产环境部署

#### 1. 配置环境变量
```bash
# 创建.env文件
cat > .env << EOF
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_PASSWORD=your_secure_password
EOF
```

#### 2. 使用生产配置启动
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

#### 3. 配置防火墙
```bash
# 仅开放必要端口
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### Kubernetes部署

#### 1. 创建命名空间
```bash
kubectl apply -f k8s/namespace.yaml
```

#### 2. 部署MySQL
```bash
kubectl apply -f k8s/mysql-deployment.yaml
```

#### 3. 部署后端
```bash
kubectl apply -f k8s/backend-deployment.yaml
```

#### 4. 部署前端
```bash
kubectl apply -f k8s/frontend-deployment.yaml
```

#### 5. 配置Ingress
```bash
kubectl apply -f k8s/ingress.yaml
```

#### 6. 查看部署状态
```bash
kubectl get pods -n ecommerce
kubectl get services -n ecommerce
kubectl get ingress -n ecommerce
```

## 服务管理

### 启动服务
```bash
docker-compose start
```

### 停止服务
```bash
docker-compose stop
```

### 重启服务
```bash
docker-compose restart
```

### 停止并删除服务
```bash
docker-compose down
```

### 停止并删除所有数据
```bash
docker-compose down -v
```

## 日志管理

### 查看所有日志
```bash
docker-compose logs
```

### 查看特定服务日志
```bash
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mysql
```

### 实时跟踪日志
```bash
docker-compose logs -f backend
```

### 查看最近N行日志
```bash
docker-compose logs --tail=100 backend
```

## 数据管理

### 数据备份
```bash
# 备份MySQL数据
docker-compose exec mysql mysqldump -u root -proot123456 ecommerce > backup.sql

# 备份Docker Volume
docker run --rm -v mysql-data:/data -v $(pwd):/backup alpine tar czf /backup/mysql-backup.tar.gz /data
```

### 数据恢复
```bash
# 恢复MySQL数据
docker-compose exec -T mysql mysql -u root -proot123456 ecommerce < backup.sql

# 恢复Docker Volume
docker run --rm -v mysql-data:/data -v $(pwd):/backup alpine tar xzf /backup/mysql-backup.tar.gz -C /
```

## 更新和升级

### 更新镜像
```bash
# 拉取最新镜像
docker-compose pull

# 重新构建镜像
docker-compose build --no-cache

# 重启服务
docker-compose up -d
```

### 滚动更新
```bash
# 逐个更新服务
docker-compose up -d --no-deps --build backend
docker-compose up -d --no-deps --build frontend
```

## 监控部署

### 启动监控服务
```bash
cd monitoring
docker-compose -f docker-compose-monitoring.yml up -d
```

### 访问监控界面
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin123)

## 性能调优

### 调整资源限制
编辑 `docker-compose.yml`:
```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
```

### 调整副本数量
```bash
docker-compose up -d --scale backend=3
```

## 安全加固

### 1. 修改默认密码
```bash
# 修改MySQL密码
docker-compose exec mysql mysql -u root -proot123456 -e "ALTER USER 'root'@'%' IDENTIFIED BY 'new_password';"
```

### 2. 启用HTTPS
配置Nginx SSL证书

### 3. 限制网络访问
```bash
# 仅允许特定IP访问
sudo ufw allow from 192.168.1.0/24 to any port 3306
```

## 故障排查

### 服务无法启动
```bash
# 查看详细日志
docker-compose logs backend

# 检查容器状态
docker-compose ps

# 进入容器调试
docker-compose exec backend sh
```

### 网络连接问题
```bash
# 检查网络
docker network inspect ecommerce-network

# 测试容器间连通性
docker-compose exec frontend ping backend
```

### 数据库连接失败
```bash
# 检查MySQL状态
docker-compose exec mysql mysqladmin ping -h localhost

# 检查数据库日志
docker-compose logs mysql
```

## 清理和维护

### 清理未使用的资源
```bash
# 清理停止的容器
docker container prune

# 清理未使用的镜像
docker image prune

# 清理未使用的卷
docker volume prune

# 清理所有未使用的资源
docker system prune -a
```

### 定期维护
- 定期备份数据
- 更新镜像和依赖
- 检查日志和监控
- 清理旧的镜像和容器
