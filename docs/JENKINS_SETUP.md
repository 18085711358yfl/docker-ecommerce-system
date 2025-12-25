# Jenkins CI/CD 配置指南

## 📋 目录
- [代码提交触发机制配置](#代码提交触发机制配置)
- [测试报告自动生成配置](#测试报告自动生成配置)
- [Jenkins 插件安装](#jenkins-插件安装)
- [Webhook 配置](#webhook-配置)

---

## 🚀 代码提交触发机制配置

### 1. 触发方式

项目支持两种代码提交触发方式：

#### 方式一：GitHub/GitLab Webhook（推荐）
- **优点**：实时触发，响应快速
- **配置位置**：Jenkinsfile 中的 `triggers` 块
```groovy
triggers {
    githubPush()  // GitHub Webhook 触发
}
```

#### 方式二：SCM 轮询（备用方案）
- **优点**：无需配置 Webhook，适合内网环境
- **配置位置**：Jenkinsfile 中的 `triggers` 块
```groovy
triggers {
    pollSCM('H/5 * * * *')  // 每5分钟检查一次代码变更
}
```

### 2. GitHub Webhook 配置步骤

#### 步骤 1：在 Jenkins 中配置
1. 进入 Jenkins 项目配置页面
2. 找到 "构建触发器" 部分
3. 勾选 "GitHub hook trigger for GITScm polling"

#### 步骤 2：在 GitHub 中配置 Webhook
1. 进入 GitHub 仓库设置页面
2. 点击 "Settings" → "Webhooks" → "Add webhook"
3. 配置 Webhook：
   - **Payload URL**: `http://your-jenkins-url/github-webhook/`
   - **Content type**: `application/json`
   - **Secret**: （可选）配置密钥
   - **触发事件**: 选择 "Just the push event"
4. 点击 "Add webhook" 保存

#### 步骤 3：验证配置
1. 提交代码到 GitHub
2. 查看 GitHub Webhook 页面的 "Recent Deliveries"
3. 确认 Jenkins 自动触发构建

### 3. GitLab Webhook 配置步骤

#### 步骤 1：在 Jenkins 中安装插件
- 安装 "GitLab Plugin"

#### 步骤 2：在 GitLab 中配置 Webhook
1. 进入 GitLab 项目设置页面
2. 点击 "Settings" → "Webhooks"
3. 配置 Webhook：
   - **URL**: `http://your-jenkins-url/project/your-job-name`
   - **Secret Token**: （可选）配置密钥
   - **触发事件**: 勾选 "Push events"
4. 点击 "Add webhook" 保存

---

## 📊 测试报告自动生成配置

### 1. 测试报告类型

项目自动生成以下测试报告：

#### ✅ JUnit 测试报告
- **位置**：`backend/target/surefire-reports/*.xml`
- **展示**：Jenkins 构建页面 → "Test Result"
- **功能**：
  - 测试用例通过/失败统计
  - 测试趋势图表
  - 失败用例详情

#### 📈 代码覆盖率报告（JaCoCo）
- **位置**：`backend/target/site/jacoco/index.html`
- **展示**：Jenkins 构建页面 → "代码覆盖率报告"
- **功能**：
  - 行覆盖率
  - 分支覆盖率
  - 方法覆盖率
  - 类覆盖率

#### 📄 HTML 测试报告
- **位置**：`backend/target/surefire-reports/*.html`
- **展示**：Jenkins 构建页面 → "单元测试报告"
- **功能**：
  - 详细的测试执行结果
  - 测试用例执行时间
  - 错误堆栈信息

### 2. 查看测试报告

#### 方法一：通过 Jenkins Web 界面
1. 进入 Jenkins 项目页面
2. 点击具体的构建编号（如 #123）
3. 在左侧菜单中查看：
   - "Test Result" - JUnit 测试结果
   - "单元测试报告" - HTML 详细报告
   - "代码覆盖率报告" - JaCoCo 覆盖率报告

#### 方法二：通过邮件通知
- 构建成功/失败后会自动发送邮件
- 邮件中包含测试报告链接

### 3. 测试报告配置说明

#### Maven 配置（pom.xml）
```xml
<!-- Surefire Plugin - 单元测试 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.0.0-M9</version>
    <configuration>
        <reportFormat>html</reportFormat>
    </configuration>
</plugin>

<!-- JaCoCo Plugin - 代码覆盖率 -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.10</version>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

#### Jenkinsfile 配置
```groovy
post {
    always {
        // 收集 JUnit 测试结果
        junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
        
        // 发布 HTML 测试报告
        publishHTML([
            allowMissing: true,
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportDir: 'backend/target/surefire-reports',
            reportFiles: '*.html',
            reportName: '单元测试报告'
        ])
        
        // 发布代码覆盖率报告
        publishHTML([
            allowMissing: true,
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportDir: 'backend/target/site/jacoco',
            reportFiles: 'index.html',
            reportName: '代码覆盖率报告'
        ])
    }
}
```

---

## 🔌 Jenkins 插件安装

### 必需插件

1. **JUnit Plugin**
   - 用途：解析和展示 JUnit 测试结果
   - 安装：Jenkins → Manage Jenkins → Manage Plugins → Available → 搜索 "JUnit"

2. **HTML Publisher Plugin**
   - 用途：发布 HTML 格式的测试报告
   - 安装：Jenkins → Manage Jenkins → Manage Plugins → Available → 搜索 "HTML Publisher"

3. **GitHub Plugin** 或 **GitLab Plugin**
   - 用途：支持 GitHub/GitLab Webhook 触发
   - 安装：Jenkins → Manage Jenkins → Manage Plugins → Available → 搜索 "GitHub" 或 "GitLab"

4. **Email Extension Plugin**
   - 用途：发送构建结果邮件通知
   - 安装：Jenkins → Manage Jenkins → Manage Plugins → Available → 搜索 "Email Extension"

### 可选插件

1. **JaCoCo Plugin**
   - 用途：更好地展示代码覆盖率报告
   - 安装：Jenkins → Manage Jenkins → Manage Plugins → Available → 搜索 "JaCoCo"

2. **Blue Ocean**
   - 用途：现代化的 Jenkins UI
   - 安装：Jenkins → Manage Jenkins → Manage Plugins → Available → 搜索 "Blue Ocean"

---

## 📧 邮件通知配置

### 1. 配置 SMTP 服务器

1. 进入 Jenkins → Manage Jenkins → Configure System
2. 找到 "Extended E-mail Notification" 部分
3. 配置 SMTP 服务器：
   - **SMTP server**: `smtp.gmail.com`（以 Gmail 为例）
   - **SMTP port**: `465`
   - **Use SSL**: 勾选
   - **Credentials**: 添加邮箱账号和密码

### 2. 配置默认收件人

在 Jenkinsfile 中配置：
```groovy
environment {
    DEFAULT_RECIPIENTS = 'team@example.com'
}
```

---

## 🧪 测试配置

### 运行测试命令

```bash
# 运行单元测试
cd backend
mvn clean test

# 查看测试报告
# JUnit XML 报告：backend/target/surefire-reports/*.xml
# HTML 报告：backend/target/surefire-reports/*.html
# JaCoCo 报告：backend/target/site/jacoco/index.html
```

### 测试覆盖率要求

- **最低行覆盖率**：50%
- **配置位置**：pom.xml 中的 JaCoCo 插件配置

---

## 📝 验证清单

### ✅ 代码提交触发机制（2分）
- [ ] Jenkinsfile 中配置了 `triggers` 块
- [ ] GitHub/GitLab Webhook 配置完成
- [ ] 提交代码后 Jenkins 自动触发构建
- [ ] 构建日志显示触发来源

### ✅ 测试报告自动生成展示（3分）
- [ ] pom.xml 中配置了测试插件（Surefire、JaCoCo）
- [ ] Jenkinsfile 中配置了测试报告收集
- [ ] Jenkins 构建页面可以查看 "Test Result"
- [ ] Jenkins 构建页面可以查看 "单元测试报告"
- [ ] Jenkins 构建页面可以查看 "代码覆盖率报告"
- [ ] 邮件通知包含测试报告链接

---

## 🔍 故障排查

### 问题 1：Webhook 未触发构建
**解决方案**：
1. 检查 GitHub/GitLab Webhook 配置是否正确
2. 检查 Jenkins URL 是否可以从外网访问
3. 查看 GitHub/GitLab Webhook 的 "Recent Deliveries" 日志
4. 检查 Jenkins 防火墙设置

### 问题 2：测试报告未生成
**解决方案**：
1. 检查 Maven 测试是否执行成功：`mvn clean test`
2. 检查测试报告文件是否存在：`backend/target/surefire-reports/`
3. 检查 Jenkins 插件是否安装：JUnit Plugin、HTML Publisher Plugin
4. 查看 Jenkins 构建日志中的错误信息

### 问题 3：代码覆盖率报告未显示
**解决方案**：
1. 检查 JaCoCo 插件是否配置正确
2. 运行 `mvn clean test` 后检查 `backend/target/site/jacoco/` 目录
3. 确认 Jenkinsfile 中配置了 `publishHTML` 步骤

---

## 📚 参考资料

- [Jenkins 官方文档](https://www.jenkins.io/doc/)
- [GitHub Webhook 文档](https://docs.github.com/en/developers/webhooks-and-events/webhooks)
- [GitLab Webhook 文档](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html)
- [JaCoCo 文档](https://www.jacoco.org/jacoco/trunk/doc/)
- [Maven Surefire Plugin 文档](https://maven.apache.org/surefire/maven-surefire-plugin/)
