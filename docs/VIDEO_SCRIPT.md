# 项目演示视频脚本

## 视频信息
- **时长**: 5-8分钟
- **格式**: MP4 (1080p)
- **内容**: 项目介绍、功能演示、技术展示

---

## 第一部分：项目介绍 (1分钟)

### 画面：项目架构图
**旁白**：
"大家好，这是我们的Docker期末综合项目——电商数据管理系统。本项目采用微服务架构，基于Docker容器化技术实现，包含前端Nginx服务、后端Spring Boot服务和MySQL数据库服务。"

### 画面：技术栈展示
**旁白**：
"我们使用的技术栈包括：
- 前端：Nginx + HTML/CSS/JavaScript
- 后端：Spring Boot 3.1.5 + Spring Data JPA
- 数据库：MySQL 8.0
- 容器化：Docker + Docker Compose
- CI/CD：Jenkins
- 容器编排：Kubernetes
- 监控：Prometheus + Grafana"

---

## 第二部分：Docker容器化展示 (2分钟)

### 场景1：Dockerfile展示 (30秒)
**画面**：打开backend/Dockerfile
**旁白**：
"首先看我们的Dockerfile。后端采用多阶段构建，第一阶段使用Maven镜像构建项目，第二阶段使用精简的JDK镜像运行应用。这样可以将镜像从800MB优化到300MB。"

**操作**：
```bash
# 展示Dockerfile内容
cat backend/Dockerfile
```

### 场景2：前端Dockerfile (30秒)
**画面**：打开frontend/Dockerfile
**旁白**：
"前端使用Nginx Alpine镜像，最终镜像只有20MB。我们配置了健康检查、Gzip压缩和反向代理。"

**操作**：
```bash
cat frontend/Dockerfile
cat frontend/nginx.conf
```

### 场景3：启动服务 (1分钟)
**画面**：终端执行命令
**旁白**：
"现在我们使用Docker Compose启动所有服务。"

**操作**：
```bash
# 启动服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

**旁白**：
"可以看到三个服务都已成功启动，MySQL、后端和前端服务都处于健康状态。"

---

## 第三部分：功能演示 (2分钟)

### 场景1：前端页面展示 (1分30秒)
**画面**：浏览器打开 http://localhost:80
**旁白**：
"这是我们的前端页面，展示了商品列表。页面采用响应式设计，支持搜索和分类筛选。"

**操作**：
1. 展示首页商品列表
2. 点击搜索功能
3. 点击商品查看详情
4. 展示商品管理页面
5. **演示图片上传功能**：
   - 点击"新增商品"按钮
   - 选择商品图片
   - 查看图片预览
   - 填写商品信息
   - 点击保存（自动上传图片）
   - 查看新增的带图片商品

### 场景2：API接口测试 (1分钟)
**画面**：终端或Postman
**旁白**：
"后端提供完整的RESTful API，支持商品的增删改查操作，以及图片上传功能。"

**操作**：
```bash
# 获取所有商品
curl http://localhost:8080/api/products

# 获取商品详情
curl http://localhost:8080/api/products/1

# 创建商品
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"测试商品","price":99.99,"stock":100,"imageUrl":"/uploads/images/xxx.png"}'

# 搜索商品
curl http://localhost:8080/api/products/search?keyword=手机

# 健康检查
curl http://localhost:8080/actuator/health
```

**旁白**：
"我们还实现了文件上传API，支持商品图片上传，包含文件类型验证和大小限制。"

---

## 第四部分：Docker Compose编排 (1分钟)

### 场景：展示docker-compose.yml
**画面**：打开docker-compose.yml
**旁白**：
"我们的Docker Compose配置包含了服务依赖、健康检查、自定义网络和资源限制。"

**操作**：
```bash
# 展示配置文件
cat docker-compose.yml

# 展示网络配置
docker network inspect ecommerce-network

# 展示数据卷
docker volume ls
```

**旁白**：
"服务间通过自定义网络通信，数据库数据持久化到Docker Volume，确保数据不会丢失。"

---

## 第五部分：CI/CD流水线 (1分钟)

### 场景：Jenkins流水线展示
**画面**：打开jenkins/Jenkinsfile
**旁白**：
"我们配置了完整的CI/CD流水线，包括代码检出、单元测试、镜像构建、集成测试和自动部署。"

**操作**：
```bash
# 展示Jenkinsfile
cat jenkins/Jenkinsfile
```

**旁白**：
"流水线会自动执行单元测试，构建Docker镜像，推送到镜像仓库，并部署到目标环境。"

---

## 第六部分：Kubernetes部署 (1分钟)

### 场景1：K8s配置展示 (30秒)
**画面**：展示k8s目录
**旁白**：
"我们还实现了Kubernetes生产级部署，包括Deployment、Service、Ingress等配置。"

**操作**：
```bash
# 展示K8s配置
ls k8s/
cat k8s/backend-deployment.yaml
```

### 场景2：蓝绿/金丝雀部署 (30秒)
**画面**：展示部署策略配置
**旁白**：
"我们实现了蓝绿部署和金丝雀发布两种部署策略，支持零停机更新和灰度发布。"

**操作**：
```bash
cat k8s/blue-green-deployment.yaml
cat k8s/canary-deployment.yaml
```

---

## 第七部分：监控系统 (30秒)

### 场景：监控展示
**画面**：Prometheus和Grafana界面
**旁白**：
"我们配置了Prometheus监控和Grafana可视化，可以实时监控系统的运行状态。"

**操作**：
1. 打开 http://localhost:9090 (Prometheus)
2. 打开 http://localhost:3000 (Grafana)
3. 展示监控指标

---

## 第八部分：项目总结 (30秒)

### 画面：项目结构和文档
**旁白**：
"本项目完整实现了Docker容器化的电商数据管理系统，包括：
- 完整的容器化服务架构（前端、后端、数据库）
- 完善的功能实现（商品管理、图片上传、搜索筛选）
- Docker Compose编排（服务依赖、健康检查、数据持久化）
- CI/CD自动化流水线（9个阶段全自动化）
- Kubernetes生产级部署（7个配置文件）
- 蓝绿和金丝雀部署策略（零停机更新）
- 完善的监控体系（Prometheus + Grafana）
- 详细的技术文档（10个文档）"

### 画面：团队分工
**旁白**：
"我们团队三人分工明确，前端开发、后端开发和DevOps各司其职，通过Git协作完成了这个项目。"

### 画面：项目亮点
**旁白**：
"项目的主要亮点包括：
1. 多阶段构建优化镜像体积（62.5%优化，从800MB到300MB）
2. 完整的健康检查机制（自动监控和故障恢复）
3. 自动化CI/CD流水线（9个阶段，包含测试和安全扫描）
4. 生产级Kubernetes部署（支持蓝绿和金丝雀发布）
5. 完善的文档体系（10个技术文档）
6. 数据持久化（数据库和上传文件双重持久化）
7. 图片上传功能（完整的文件管理系统）
8. 完整的监控体系（Prometheus + Grafana）"

**结束语**：
"感谢观看，这就是我们的Docker期末项目。谢谢！"

---

## 录制建议

### 准备工作
1. 清理Docker环境
2. 准备好所有命令
3. 测试所有功能
4. 准备演示数据

### 录制技巧
1. 使用屏幕录制软件（OBS Studio）
2. 调整合适的分辨率（1920x1080）
3. 清晰的旁白解说
4. 适当的字幕说明
5. 流畅的操作演示

### 后期处理
1. 剪辑多余部分
2. 添加背景音乐
3. 添加字幕
4. 添加转场效果
5. 导出高质量视频

### 时间分配
| 部分 | 时间 | 内容 |
|------|------|------|
| 项目介绍 | 1分钟 | 架构和技术栈 |
| Docker容器化 | 2分钟 | Dockerfile和启动 |
| 功能演示 | 2分30秒 | 前端、API和图片上传 |
| Docker Compose | 1分钟 | 编排配置和数据持久化 |
| CI/CD | 1分钟 | Jenkins流水线 |
| Kubernetes | 1分钟 | K8s部署和蓝绿/金丝雀 |
| 监控系统 | 30秒 | Prometheus/Grafana |
| 项目总结 | 30秒 | 总结和亮点 |
| **总计** | **8分30秒** | |

## 演示命令清单

```bash
# 1. 启动服务
docker-compose up -d
docker-compose ps
docker-compose logs -f

# 2. 测试API
curl http://localhost:8080/api/products
curl http://localhost:8080/actuator/health

# 3. 查看网络
docker network inspect ecommerce-network

# 4. 查看数据卷
docker volume ls

# 5. 进入容器
docker-compose exec backend sh
docker-compose exec mysql mysql -u root -proot123456

# 6. 查看资源使用
docker stats

# 7. K8s部署（如果演示）
kubectl apply -f k8s/
kubectl get pods -n ecommerce
kubectl get services -n ecommerce

# 8. 停止服务
docker-compose down
```

## 注意事项

1. 确保所有服务正常运行
2. 提前测试所有演示内容
3. 准备备用方案
4. 控制好时间
5. 保持流畅的讲解
6. 突出项目亮点
7. 展示技术深度
