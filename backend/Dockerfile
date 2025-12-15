# 多阶段构建 - 构建阶段
FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /app

# 配置 Maven 使用阿里云镜像
RUN mkdir -p /root/.m2 && \
    echo '<?xml version="1.0" encoding="UTF-8"?>' > /root/.m2/settings.xml && \
    echo '<settings>' >> /root/.m2/settings.xml && \
    echo '  <mirrors>' >> /root/.m2/settings.xml && \
    echo '    <mirror>' >> /root/.m2/settings.xml && \
    echo '      <id>aliyun</id>' >> /root/.m2/settings.xml && \
    echo '      <mirrorOf>central</mirrorOf>' >> /root/.m2/settings.xml && \
    echo '      <name>Aliyun Maven</name>' >> /root/.m2/settings.xml && \
    echo '      <url>https://maven.aliyun.com/repository/public</url>' >> /root/.m2/settings.xml && \
    echo '    </mirror>' >> /root/.m2/settings.xml && \
    echo '  </mirrors>' >> /root/.m2/settings.xml && \
    echo '</settings>' >> /root/.m2/settings.xml

# 复制pom.xml并下载依赖（利用Docker层缓存）
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并构建
COPY src ./src
RUN mvn clean package -DskipTests -B

# 多阶段构建 - 运行阶段
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# 安装curl用于健康检查
RUN apk add --no-cache curl

# 创建非root用户
RUN addgroup -S spring && adduser -S spring -G spring

# 从构建阶段复制jar包
COPY --from=builder /app/target/*.jar app.jar

# 修改文件所有者
RUN chown -R spring:spring /app

# 切换到非root用户
USER spring

# 创建上传目录（使用VOLUME挂载点，在容器启动时创建）
RUN mkdir -p /app/uploads/images

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# 启动应用
ENTRYPOINT ["java", "-Dfile.encoding=UTF-8", "-Dsun.jnu.encoding=UTF-8", "-jar", "-Xmx512m", "-Xms256m", "app.jar"]
