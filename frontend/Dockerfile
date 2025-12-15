# 多阶段构建 - 构建阶段（如果需要构建前端资源）
FROM node:18-alpine AS builder

WORKDIR /app

# 复制静态文件
COPY html ./html

# 多阶段构建 - 运行阶段
FROM nginx:1.25-alpine

# 删除默认配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义nginx配置
COPY nginx.conf /etc/nginx/conf.d/

# 从构建阶段复制静态文件
COPY --from=builder /app/html /usr/share/nginx/html

# 创建健康检查页面
RUN echo '{"status":"healthy"}' > /usr/share/nginx/html/health

# 设置权限
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]
