# 故障排查文档

## 常见问题及解决方案

### 1. 数据库连接问题

#### 问题描述
后端服务无法连接到MySQL数据库

#### 错误信息
```
Communications link failure
The last packet sent successfully to the server was 0 milliseconds ago
```

#### 排查步骤

**1. 检查MySQL容器状态**
```bash
docker-compose ps mysql
```

**2. 查看MySQL日志**
```bash
docker-compose logs mysql
```

**3. 检查网络连接**
```bash
docker-compose exec backend ping mysql
```

**4. 验证数据库凭据**
```bash
docker-compose exec mysql mysql -u ecommerce_user -pecommerce_pass -e "SELECT 1"
```

#### 解决方案

**方案1: 等待MySQL完全启动**
```bash
# MySQL需要30-60秒启动时间
docker-compose logs -f mysql
# 等待看到 "ready for connections"
```

**方案2: 检查环境变量**
```bash
docker-compose exec backend env | grep SPRING_DATASOURCE
```

**方案3: 重启服务**
```bash
docker-compose restart backend
```

**方案4: 检查健康检查**
```bash
docker-compose exec mysql mysqladmin ping -h localhost -u root -proot123456
```

### 2. 前端无法访问后端API

#### 问题描述
前端页面显示"无法连接到后端服务"

#### 排查步骤

**1. 检查后端服务状态**
```bash
curl http://localhost:8080/actuator/health
```

**2. 检查Nginx配置**
```bash
docker-compose exec frontend cat /etc/nginx/conf.d/nginx.conf
```

**3. 查看Nginx日志**
```bash
docker-compose logs frontend
```

**4. 测试容器间通信**
```bash
docker-compose exec frontend wget -O- http://backend:8080/actuator/health
```

#### 解决方案

**方案1: 检查Nginx代理配置**
确保nginx.conf中的proxy_pass正确：
```nginx
location /api/ {
    proxy_pass http://backend:8080/api/;
}
```

**方案2: 重启Nginx**
```bash
docker-compose restart frontend
```

**方案3: 检查网络**
```bash
docker network inspect ecommerce-network
```

### 3. 容器启动失败

#### 问题描述
容器无法启动或立即退出

#### 排查步骤

**1. 查看容器状态**
```bash
docker-compose ps
```

**2. 查看详细日志**
```bash
docker-compose logs --tail=100 <service-name>
```

**3. 检查端口占用**
```bash
# Windows
netstat -ano | findstr :8080

# Linux/Mac
lsof -i :8080
```

**4. 检查资源使用**
```bash
docker stats
```

#### 解决方案

**方案1: 端口冲突**
修改docker-compose.yml中的端口映射：
```yaml
ports:
  - "8081:8080"  # 改用8081端口
```

**方案2: 内存不足**
增加Docker内存限制或清理资源：
```bash
docker system prune -a
```

**方案3: 配置错误**
检查环境变量和配置文件

**方案4: 重新构建镜像**
```bash
docker-compose build --no-cache
docker-compose up -d
```

### 4. 数据持久化问题

#### 问题描述
容器重启后数据丢失

#### 排查步骤

**1. 检查Volume配置**
```bash
docker volume ls
docker volume inspect mysql-data
```

**2. 检查挂载点**
```bash
docker-compose exec mysql df -h
```

#### 解决方案

**方案1: 确认Volume配置**
```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

**方案2: 备份和恢复数据**
```bash
# 备份
docker-compose exec mysql mysqldump -u root -proot123456 ecommerce > backup.sql

# 恢复
docker-compose exec -T mysql mysql -u root -proot123456 ecommerce < backup.sql
```

### 5. 镜像构建失败

#### 问题描述
Docker镜像构建过程中出错

#### 排查步骤

**1. 查看构建日志**
```bash
docker-compose build backend 2>&1 | tee build.log
```

**2. 检查Dockerfile语法**
```bash
docker build --no-cache -t test ./backend
```

#### 解决方案

**方案1: Maven依赖下载失败**
```bash
# 使用国内Maven镜像
# 在pom.xml中添加阿里云镜像
```

**方案2: 网络问题**
```bash
# 配置Docker代理
# 或使用VPN
```

**方案3: 磁盘空间不足**
```bash
docker system prune -a
df -h
```

### 6. 性能问题

#### 问题描述
应用响应缓慢或超时

#### 排查步骤

**1. 检查资源使用**
```bash
docker stats
```

**2. 查看应用日志**
```bash
docker-compose logs backend | grep -i "slow\|timeout\|error"
```

**3. 检查数据库性能**
```bash
docker-compose exec mysql mysql -u root -proot123456 -e "SHOW PROCESSLIST;"
```

#### 解决方案

**方案1: 增加资源限制**
```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 2G
```

**方案2: 优化数据库查询**
- 添加索引
- 优化SQL语句
- 使用连接池

**方案3: 启用缓存**
- 配置Redis缓存
- 启用HTTP缓存

### 7. 网络问题

#### 问题描述
容器间无法通信

#### 排查步骤

**1. 检查网络配置**
```bash
docker network ls
docker network inspect ecommerce-network
```

**2. 测试DNS解析**
```bash
docker-compose exec backend nslookup mysql
```

**3. 测试连通性**
```bash
docker-compose exec backend ping mysql
docker-compose exec frontend ping backend
```

#### 解决方案

**方案1: 重建网络**
```bash
docker-compose down
docker network rm ecommerce-network
docker-compose up -d
```

**方案2: 检查防火墙**
```bash
# 临时关闭防火墙测试
sudo ufw disable
```

**方案3: 使用IP地址**
```bash
# 获取容器IP
docker inspect <container-id> | grep IPAddress
```

### 8. 日志问题

#### 问题描述
无法查看或日志过大

#### 排查步骤

**1. 检查日志大小**
```bash
docker-compose logs --tail=10 backend
```

**2. 检查日志驱动**
```bash
docker inspect <container-id> | grep LogConfig
```

#### 解决方案

**方案1: 限制日志大小**
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

**方案2: 清理日志**
```bash
docker-compose down
docker system prune -a
```

## 调试技巧

### 1. 进入容器调试
```bash
# 进入后端容器
docker-compose exec backend sh

# 进入MySQL容器
docker-compose exec mysql bash

# 进入前端容器
docker-compose exec frontend sh
```

### 2. 查看容器详细信息
```bash
docker inspect <container-id>
```

### 3. 实时监控
```bash
# 监控资源使用
docker stats

# 实时查看日志
docker-compose logs -f
```

### 4. 网络调试
```bash
# 安装网络工具
docker-compose exec backend apt-get update && apt-get install -y curl telnet

# 测试端口
telnet mysql 3306
```

### 5. 数据库调试
```bash
# 连接数据库
docker-compose exec mysql mysql -u root -proot123456

# 查看表结构
SHOW TABLES;
DESCRIBE products;

# 查看慢查询
SHOW VARIABLES LIKE 'slow_query%';
```

## 预防措施

### 1. 定期备份
```bash
# 每天备份数据库
0 2 * * * docker-compose exec mysql mysqldump -u root -proot123456 ecommerce > /backup/db_$(date +\%Y\%m\%d).sql
```

### 2. 监控告警
- 配置Prometheus监控
- 设置告警规则
- 定期检查日志

### 3. 健康检查
- 配置健康检查端点
- 自动重启不健康的容器
- 监控健康状态

### 4. 资源限制
- 设置合理的资源限制
- 避免资源耗尽
- 监控资源使用

### 5. 日志管理
- 限制日志大小
- 定期清理旧日志
- 使用日志聚合工具

## 获取帮助

### 查看文档
- Docker官方文档: https://docs.docker.com
- Spring Boot文档: https://spring.io/projects/spring-boot
- MySQL文档: https://dev.mysql.com/doc

### 社区支持
- Stack Overflow
- Docker论坛
- GitHub Issues

### 联系方式
- 项目维护者: [email]
- 技术支持: [support-email]
