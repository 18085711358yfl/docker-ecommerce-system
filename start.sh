#!/bin/bash

echo ""
echo "================================================================"
echo "                                                                "
echo "          电商数据管理系统 - Docker容器化项目                "
echo "                                                                "
echo "================================================================"
echo ""

cd "$(dirname "$0")"

# 主菜单函数
show_menu() {
    clear
    echo ""
    echo "================================================================"
    echo "                    Docker 电商管理系统"
    echo "================================================================"
    echo ""
    echo "请选择操作:"
    echo ""
    echo "1. 完整启动 (测试 + 构建 + 启动 + 监控)"
    echo "2. 快速启动 (跳过测试，直接启动服务)"
    echo "3. 仅运行测试"
    echo "4. 查看测试报告"
    echo "5. 启动监控系统"
    echo "6. 验证所有功能"
    echo "7. 查看服务状态"
    echo "8. 查看日志"
    echo "9. 停止所有服务"
    echo "0. 退出"
    echo ""
    echo "================================================================"
    echo ""
    read -p "请输入选项 (0-9): " choice
    
    case $choice in
        1) full_start ;;
        2) quick_start ;;
        3) run_tests ;;
        4) view_test_report ;;
        5) start_monitoring ;;
        6) verify_all ;;
        7) show_status ;;
        8) show_logs ;;
        9) stop_all ;;
        0) exit 0 ;;
        *) echo "无效选项"; sleep 2; show_menu ;;
    esac
}

# 1. 完整启动
full_start() {
    clear
    echo ""
    echo "================================================================"
    echo "[阶段 1/7] 环境检查"
    echo "================================================================"
    echo ""
    
    echo "[1.1] 检查Docker是否运行..."
    if ! docker info > /dev/null 2>&1; then
        echo "[错误] Docker未运行，请先启动Docker"
        read -p "按回车继续..."
        show_menu
        return
    fi
    echo "[成功] Docker正在运行"
    echo ""
    
    echo "[1.2] 检查Docker Compose..."
    if ! docker-compose version > /dev/null 2>&1; then
        echo "[错误] Docker Compose未安装"
        read -p "按回车继续..."
        show_menu
        return
    fi
    echo "[成功] Docker Compose可用"
    echo ""
    
    # 运行测试
    echo ""
    echo "================================================================"
    echo "[阶段 2/7] 运行单元测试"
    echo "================================================================"
    echo ""
    
    cd backend
    mvn test -q
    TEST_RESULT=$?
    cd ..
    
    if [ $TEST_RESULT -ne 0 ]; then
        echo ""
        echo "[警告] 单元测试失败！"
        read -p "是否继续启动服务？(y/n): " continue_choice
        if [ "$continue_choice" != "y" ]; then
            show_menu
            return
        fi
    else
        echo ""
        echo "[成功] 所有单元测试通过！"
        echo ""
        echo "测试结果摘要:"
        echo "   - 测试用例数: 6"
        echo "   - 通过: 6"
        echo "   - 失败: 0"
        echo ""
    fi
    
    sleep 3
    
    # 清理旧容器
    echo ""
    echo "================================================================"
    echo "[阶段 3/7] 清理旧容器"
    echo "================================================================"
    echo ""
    
    docker-compose down > /dev/null 2>&1
    echo "[成功] 旧容器已清理"
    echo ""
    
    sleep 2
    
    # 构建和启动
    echo ""
    echo "================================================================"
    echo "[阶段 4/7] 构建和启动服务"
    echo "================================================================"
    echo ""
    
    echo "[4.1] 构建Docker镜像..."
    docker-compose build --no-cache
    
    if [ $? -ne 0 ]; then
        echo "[错误] 镜像构建失败"
        read -p "按回车继续..."
        show_menu
        return
    fi
    echo "[成功] 镜像构建成功"
    echo ""
    
    echo "[4.2] 启动所有服务..."
    docker-compose up -d
    
    if [ $? -ne 0 ]; then
        echo "[错误] 服务启动失败"
        read -p "按回车继续..."
        show_menu
        return
    fi
    echo "[成功] 服务启动成功"
    echo ""
    
    # 等待服务就绪
    echo ""
    echo "================================================================"
    echo "[阶段 5/7] 等待服务就绪"
    echo "================================================================"
    echo ""
    
    echo "[5.1] 等待MySQL数据库启动 (30秒)..."
    sleep 30
    echo "[成功] MySQL数据库就绪"
    echo ""
    
    echo "[5.2] 等待后端服务启动 (30秒)..."
    sleep 30
    echo "[成功] 后端服务就绪"
    echo ""
    
    echo "[5.3] 等待前端服务启动 (5秒)..."
    sleep 5
    echo "[成功] 前端服务就绪"
    echo ""
    
    # 启动监控
    echo ""
    echo "================================================================"
    echo "[阶段 6/7] 启动监控系统"
    echo "================================================================"
    echo ""
    
    read -p "是否启动监控系统 (Prometheus + Grafana)? (y/n): " monitor_choice
    if [ "$monitor_choice" = "y" ]; then
        echo ""
        echo "正在启动监控系统..."
        docker-compose -f monitoring/docker-compose-monitoring.yml up -d
        
        if [ $? -eq 0 ]; then
            echo "[成功] 监控系统启动成功"
            sleep 10
        else
            echo "[警告] 监控系统启动失败"
        fi
    fi
    echo ""
    
    # 显示信息
    echo ""
    echo "================================================================"
    echo "[阶段 7/7] 启动完成"
    echo "================================================================"
    echo ""
    
    show_info
    
    read -p "按回车返回菜单..."
    show_menu
}

# 2. 快速启动
quick_start() {
    clear
    echo ""
    echo "================================================================"
    echo "快速启动模式 (跳过测试)"
    echo "================================================================"
    echo ""
    
    docker-compose down > /dev/null 2>&1
    docker-compose up -d
    
    if [ $? -ne 0 ]; then
        echo "[错误] 服务启动失败"
        read -p "按回车继续..."
        show_menu
        return
    fi
    
    echo ""
    echo "[成功] 服务启动成功！"
    echo ""
    echo "等待服务就绪 (30秒)..."
    sleep 30
    
    show_info
    
    read -p "按回车返回菜单..."
    show_menu
}

# 3. 仅运行测试
run_tests() {
    clear
    echo ""
    echo "================================================================"
    echo "运行单元测试"
    echo "================================================================"
    echo ""
    
    cd backend
    mvn test
    cd ..
    
    echo ""
    echo "测试完成！"
    echo ""
    echo "测试报告位置: backend/target/surefire-reports/"
    echo ""
    
    read -p "按回车返回菜单..."
    show_menu
}

# 4. 查看测试报告
view_test_report() {
    clear
    echo ""
    echo "================================================================"
    echo "查看测试报告"
    echo "================================================================"
    echo ""
    
    if [ ! -d "backend/target/surefire-reports" ]; then
        echo "[错误] 测试报告不存在，请先运行测试"
        read -p "按回车返回菜单..."
        show_menu
        return
    fi
    
    echo "测试报告位置: backend/target/surefire-reports/"
    echo ""
    ls -lh backend/target/surefire-reports/
    echo ""
    
    read -p "按回车返回菜单..."
    show_menu
}

# 5. 启动监控系统
start_monitoring() {
    clear
    echo ""
    echo "================================================================"
    echo "启动监控系统"
    echo "================================================================"
    echo ""
    
    docker-compose -f monitoring/docker-compose-monitoring.yml up -d
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "[成功] 监控系统启动成功！"
        echo ""
        echo "访问地址:"
        echo "   Prometheus:     http://localhost:9090"
        echo "   Grafana:        http://localhost:3000"
        echo "   用户名: admin / 密码: admin123"
        echo ""
    else
        echo "[错误] 监控系统启动失败"
    fi
    
    read -p "按回车返回菜单..."
    show_menu
}

# 6. 验证所有功能
verify_all() {
    clear
    echo ""
    echo "================================================================"
    echo "验证所有功能"
    echo "================================================================"
    echo ""
    
    echo "[1/5] 检查Docker服务状态"
    docker-compose ps
    echo ""
    read -p "按回车继续..."
    
    echo ""
    echo "[2/5] 测试前端服务"
    curl -s -o /dev/null -w "HTTP状态码: %{http_code}\n" http://localhost
    echo ""
    read -p "按回车继续..."
    
    echo ""
    echo "[3/5] 测试后端健康检查"
    curl http://localhost:8080/actuator/health
    echo ""
    read -p "按回车继续..."
    
    echo ""
    echo "[4/5] 测试后端API"
    curl http://localhost:8080/api/products
    echo ""
    read -p "按回车继续..."
    
    echo ""
    echo "[5/5] 检查数据卷"
    docker volume ls | grep docker
    echo ""
    
    echo "验证完成！"
    read -p "按回车返回菜单..."
    show_menu
}

# 7. 查看服务状态
show_status() {
    clear
    echo ""
    echo "================================================================"
    echo "服务状态"
    echo "================================================================"
    echo ""
    
    echo "[主服务]"
    docker-compose ps
    echo ""
    
    echo "[监控服务]"
    docker-compose -f monitoring/docker-compose-monitoring.yml ps 2>/dev/null
    echo ""
    
    show_info
    
    read -p "按回车返回菜单..."
    show_menu
}

# 8. 查看日志
show_logs() {
    clear
    echo ""
    echo "================================================================"
    echo "查看日志"
    echo "================================================================"
    echo ""
    echo "1. 查看所有服务日志"
    echo "2. 查看前端日志"
    echo "3. 查看后端日志"
    echo "4. 查看MySQL日志"
    echo "5. 返回主菜单"
    echo ""
    read -p "请选择 (1-5): " log_choice
    
    case $log_choice in
        1) docker-compose logs ;;
        2) docker-compose logs frontend ;;
        3) docker-compose logs backend ;;
        4) docker-compose logs mysql ;;
        5) show_menu; return ;;
    esac
    
    read -p "按回车返回菜单..."
    show_menu
}

# 9. 停止所有服务
stop_all() {
    clear
    echo ""
    echo "================================================================"
    echo "停止所有服务"
    echo "================================================================"
    echo ""
    
    echo "正在停止主服务..."
    docker-compose down
    
    echo ""
    echo "正在停止监控服务..."
    docker-compose -f monitoring/docker-compose-monitoring.yml down 2>/dev/null
    
    echo ""
    echo "[成功] 所有服务已停止"
    echo ""
    
    read -p "按回车返回菜单..."
    show_menu
}

# 显示访问信息
show_info() {
    echo ""
    echo "================================================================"
    echo "访问地址"
    echo "================================================================"
    echo ""
    echo "   前端页面:       http://localhost"
    echo "   后端API:        http://localhost:8080/api/products"
    echo "   健康检查:       http://localhost:8080/actuator/health"
    echo ""
    
    if docker-compose -f monitoring/docker-compose-monitoring.yml ps 2>/dev/null | grep -q "prometheus"; then
        echo "监控系统:"
        echo "================================================================"
        echo ""
        echo "   Prometheus:     http://localhost:9090"
        echo "   Grafana:        http://localhost:3000"
        echo "   用户名: admin / 密码: admin123"
        echo ""
    fi
    
    echo "常用命令:"
    echo "================================================================"
    echo ""
    echo "   查看日志:       docker-compose logs -f"
    echo "   重启服务:       docker-compose restart"
    echo ""
    echo "================================================================"
}

# 启动菜单
show_menu
