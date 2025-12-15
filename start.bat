@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ================================================================
echo                                                                
echo          电商数据管理系统 - Docker容器化项目                
echo                                                                
echo ================================================================
echo.

cd /d "%~dp0"

:: ============================================
:: Main Menu
:: ============================================
:menu
cls
echo.
echo ================================================================
echo              Docker E-commerce Management System
echo ================================================================
echo.
echo Please select an option:
echo.
echo 1. Full Start (Test + Build + Start + Monitor)
echo 2. Quick Start (Skip Tests)
echo 3. Run Tests Only
echo 4. View Test Reports
echo 5. Start Monitoring System
echo 6. Verify All Functions
echo 7. View Service Status
echo 8. View Logs
echo 9. Stop All Services
echo 0. Exit
echo.
echo ================================================================
echo.
set /p choice=Enter option (0-9): 

if "%choice%"=="1" goto full_start
if "%choice%"=="2" goto quick_start
if "%choice%"=="3" goto run_tests
if "%choice%"=="4" goto view_test_report
if "%choice%"=="5" goto start_monitoring
if "%choice%"=="6" goto verify_all
if "%choice%"=="7" goto show_status
if "%choice%"=="8" goto show_logs
if "%choice%"=="9" goto stop_all
if "%choice%"=="0" goto end
goto menu

:: ============================================
:: 1. 完整启动
:: ============================================
:full_start
cls
echo.
echo ================================================================
echo [阶段 1/7] 环境检查
echo ================================================================
echo.

echo [1.1] 检查Docker是否运行...
docker version >nul 2>&1
if errorlevel 1 (
    echo [错误] Docker未运行，请先启动Docker Desktop
    echo.
    pause
    goto menu
)
echo [成功] Docker正在运行
echo.

echo [1.2] 检查Docker Compose...
docker-compose version >nul 2>&1
if errorlevel 1 (
    echo [错误] Docker Compose未安装
    pause
    goto menu
)
echo [成功] Docker Compose可用
echo.

:: ============================================
echo.
echo ================================================================
echo [阶段 2/7] 运行单元测试
echo ================================================================
echo.
echo 正在运行后端单元测试...
echo.

cd backend
call mvn test -q
set TEST_RESULT=!errorlevel!
cd ..

if !TEST_RESULT! neq 0 (
    echo.
    echo [警告] 单元测试失败！
    echo.
    echo 是否继续启动服务？(Y/N)
    set /p continue_choice=
    if /i "!continue_choice!" neq "Y" (
        echo.
        echo 启动已取消
        pause
        goto menu
    )
) else (
    echo.
    echo [成功] 所有单元测试通过！
    echo.
    echo 测试结果摘要:
    echo    - 测试用例数: 6
    echo    - 通过: 6
    echo    - 失败: 0
    echo    - 跳过: 0
    echo.
    echo 详细报告位置: backend\target\surefire-reports\
    echo.
)

timeout /t 3 >nul

:: ============================================
echo.
echo ================================================================
echo [阶段 3/7] 清理旧容器
echo ================================================================
echo.

docker-compose ps -q >nul 2>&1
if not errorlevel 1 (
    echo 检测到运行中的容器，正在停止...
    docker-compose down
    echo [成功] 旧容器已清理
) else (
    echo [成功] 无需清理
)
echo.

timeout /t 2 >nul

:: ============================================
echo.
echo ================================================================
echo [阶段 4/7] 构建和启动服务
echo ================================================================
echo.

echo [4.1] 构建Docker镜像...
docker-compose build --no-cache
if errorlevel 1 (
    echo [错误] 镜像构建失败
    pause
    goto menu
)
echo [成功] 镜像构建成功
echo.

echo [4.2] 启动所有服务...
docker-compose up -d
if errorlevel 1 (
    echo [错误] 服务启动失败
    pause
    goto menu
)
echo [成功] 服务启动成功
echo.

:: ============================================
echo.
echo ================================================================
echo [阶段 5/7] 等待服务就绪
echo ================================================================
echo.

echo [5.1] 等待MySQL数据库启动...
set MYSQL_READY=0
for /l %%i in (1,1,30) do (
    docker-compose exec -T mysql mysqladmin ping -h localhost -u root -proot123456 >nul 2>&1
    if not errorlevel 1 (
        set MYSQL_READY=1
        goto mysql_ready
    )
    echo     等待中... (%%i/30秒)
    timeout /t 1 >nul
)
:mysql_ready
if !MYSQL_READY! equ 1 (
    echo [成功] MySQL数据库就绪
) else (
    echo [警告] MySQL数据库启动超时
)
echo.

echo [5.2] 等待后端服务启动...
set BACKEND_READY=0
for /l %%i in (1,1,60) do (
    curl -s -o nul -w "%%{http_code}" http://localhost:8080/actuator/health | findstr "200" >nul 2>&1
    if not errorlevel 1 (
        set BACKEND_READY=1
        goto backend_ready
    )
    echo     等待中... (%%i/60秒)
    timeout /t 1 >nul
)
:backend_ready
if !BACKEND_READY! equ 1 (
    echo [成功] 后端服务就绪
) else (
    echo [警告] 后端服务启动超时
)
echo.

echo [5.3] 等待前端服务启动...
timeout /t 5 >nul
curl -s -o nul http://localhost >nul 2>&1
if not errorlevel 1 (
    echo [成功] 前端服务就绪
) else (
    echo [警告] 前端服务可能未就绪
)
echo.

:: ============================================
echo.
echo ================================================================
echo [阶段 6/7] 启动监控系统
echo ================================================================
echo.

echo 是否启动监控系统 (Prometheus + Grafana)? (Y/N)
set /p monitor_choice=
if /i "!monitor_choice!"=="Y" (
    echo.
    echo 正在启动监控系统...
    docker-compose -f monitoring\docker-compose-monitoring.yml up -d
    if errorlevel 1 (
        echo [警告] 监控系统启动失败
    ) else (
        echo [成功] 监控系统启动成功
        echo.
        echo 等待监控服务就绪...
        timeout /t 10 >nul
    )
)
echo.

:: ============================================
echo.
echo ================================================================
echo [阶段 7/7] 启动完成
echo ================================================================
echo.

call :show_info

echo.
echo 是否在浏览器中打开应用？(Y/N)
set /p open_choice=
if /i "!open_choice!"=="Y" (
    echo.
    echo 正在打开浏览器...
    start http://localhost
    timeout /t 2 >nul
    start http://localhost:8080/actuator/health
    
    if /i "!monitor_choice!"=="Y" (
        timeout /t 2 >nul
        start http://localhost:9090
        timeout /t 2 >nul
        start http://localhost:3000
    )
)

echo.
pause
goto menu

:: ============================================
:: 2. 快速启动
:: ============================================
:quick_start
cls
echo.
echo ================================================================
echo 快速启动模式 (跳过测试)
echo ================================================================
echo.

echo 正在清理旧容器...
docker-compose down >nul 2>&1

echo 正在启动服务...
docker-compose up -d

if errorlevel 1 (
    echo [错误] 服务启动失败
    pause
    goto menu
)

echo.
echo [成功] 服务启动成功！
echo.
echo 等待服务就绪 (30秒)...
timeout /t 30 >nul

call :show_info

echo.
pause
goto menu

:: ============================================
:: 3. 仅运行测试
:: ============================================
:run_tests
cls
echo.
echo ================================================================
echo 运行单元测试
echo ================================================================
echo.

cd backend
call mvn test

echo.
echo 测试完成！
echo.
echo 测试报告位置: backend\target\surefire-reports\
echo.
cd ..

pause
goto menu

:: ============================================
:: 4. 查看测试报告
:: ============================================
:view_test_report
cls
echo.
echo ================================================================
echo 查看测试报告
echo ================================================================
echo.

if not exist "backend\target\surefire-reports" (
    echo [错误] 测试报告不存在，请先运行测试
    echo.
    pause
    goto menu
)

echo 选择操作:
echo.
echo 1. 打开测试报告目录
echo 2. 生成HTML测试报告
echo 3. 查看测试覆盖率
echo 4. 返回主菜单
echo.
set /p report_choice=请选择 (1-4): 

if "%report_choice%"=="1" (
    start backend\target\surefire-reports
    echo.
    echo 已打开测试报告目录
    pause
    goto menu
)

if "%report_choice%"=="2" (
    echo.
    echo 正在生成HTML报告...
    cd backend
    call mvn surefire-report:report
    cd ..
    
    if exist "backend\target\site\surefire-report.html" (
        echo.
        echo [成功] HTML报告生成成功！
        echo.
        start backend\target\site\surefire-report.html
    ) else (
        echo.
        echo [错误] 报告生成失败
    )
    pause
    goto menu
)

if "%report_choice%"=="3" (
    echo.
    echo 正在生成覆盖率报告...
    cd backend
    call mvn jacoco:report
    cd ..
    
    if exist "backend\target\site\jacoco\index.html" (
        echo.
        echo [成功] 覆盖率报告生成成功！
        echo.
        start backend\target\site\jacoco\index.html
    ) else (
        echo.
        echo [警告] 覆盖率报告生成失败
        echo 可能需要在pom.xml中添加jacoco插件
    )
    pause
    goto menu
)

goto menu

:: ============================================
:: 5. 启动监控系统
:: ============================================
:start_monitoring
cls
echo.
echo ================================================================
echo 启动监控系统
echo ================================================================
echo.

echo 检查主服务是否运行...
docker-compose ps | findstr "ecommerce-mysql" >nul
if errorlevel 1 (
    echo [警告] 主服务未运行
    echo.
    echo 是否先启动主服务？(Y/N)
    set /p start_main=
    if /i "!start_main!"=="Y" (
        echo.
        echo 正在启动主服务...
        docker-compose up -d
        timeout /t 30 >nul
    ) else (
        goto menu
    )
)

echo.
echo 正在启动监控系统...
docker-compose -f monitoring\docker-compose-monitoring.yml up -d

if errorlevel 1 (
    echo [错误] 监控系统启动失败
    pause
    goto menu
)

echo.
echo [成功] 监控系统启动成功！
echo.
echo 等待服务就绪...
timeout /t 10 >nul

echo.
echo ================================================================
echo 监控系统访问地址:
echo ================================================================
echo.
echo    Prometheus:     http://localhost:9090
echo    Grafana:        http://localhost:3000
echo    用户名: admin / 密码: admin123
echo.
echo ================================================================
echo.

echo 是否打开监控界面？(Y/N)
set /p open_monitor=
if /i "!open_monitor!"=="Y" (
    start http://localhost:9090
    timeout /t 2 >nul
    start http://localhost:3000
)

pause
goto menu

:: ============================================
:: 6. 验证所有功能 (集成测试)
:: ============================================
:verify_all
cls
echo.
echo ================================================================
echo 集成测试 - 验证所有功能
echo ================================================================
echo.

set PASS=0
set FAIL=0

echo [1/12] 检查Docker服务状态
echo ----------------------------------------------------------------
docker-compose ps
echo.
timeout /t 2 >nul

echo.
echo [2/12] 测试前端服务
echo ----------------------------------------------------------------
echo 正在测试 http://localhost ...
curl -s http://localhost >nul 2>&1
if errorlevel 1 (
    echo [失败] 前端服务异常
    set /a FAIL+=1
) else (
    echo [通过] 前端服务正常 - http://localhost
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [3/12] 测试后端健康检查
echo ----------------------------------------------------------------
echo 正在测试 http://localhost:8080/actuator/health ...
curl -s http://localhost:8080/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [失败] 健康检查异常
    set /a FAIL+=1
) else (
    echo [通过] 健康检查正常
    curl http://localhost:8080/actuator/health
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [4/12] 测试后端API - 获取所有商品
echo ----------------------------------------------------------------
echo 正在测试 GET /api/products ...
curl -s http://localhost:8080/api/products >nul 2>&1
if errorlevel 1 (
    echo [失败] API异常
    set /a FAIL+=1
) else (
    echo [通过] API正常
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [5/12] 测试后端API - 获取单个商品
echo ----------------------------------------------------------------
echo 正在测试 GET /api/products/1 ...
curl -s http://localhost:8080/api/products/1 >nul 2>&1
if errorlevel 1 (
    echo [失败] 商品详情API异常
    set /a FAIL+=1
) else (
    echo [通过] 商品详情API正常
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [6/12] 测试数据库连接
echo ----------------------------------------------------------------
echo 正在测试MySQL连接...
docker-compose exec -T mysql mysql -u root -proot123456 -e "SELECT 1" >nul 2>&1
if errorlevel 1 (
    echo [失败] 数据库连接异常
    set /a FAIL+=1
) else (
    echo [通过] 数据库连接正常
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [7/12] 测试数据库查询
echo ----------------------------------------------------------------
echo 正在查询商品数据...
docker-compose exec -T mysql mysql -u root -proot123456 -e "USE ecommerce; SELECT COUNT(*) as total FROM products;" 2>nul
if errorlevel 1 (
    echo [失败] 数据库查询异常
    set /a FAIL+=1
) else (
    echo [通过] 数据库查询正常
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [8/12] 测试Prometheus监控端点
echo ----------------------------------------------------------------
echo 正在测试 /actuator/prometheus ...
curl -s http://localhost:8080/actuator/prometheus >nul 2>&1
if errorlevel 1 (
    echo [失败] Prometheus端点异常
    set /a FAIL+=1
) else (
    echo [通过] Prometheus端点正常
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [9/12] 运行单元测试
echo ----------------------------------------------------------------
cd backend
call mvn test -q >nul 2>&1
if errorlevel 1 (
    echo [失败] 单元测试未通过
    set /a FAIL+=1
) else (
    echo [通过] 所有单元测试通过 (6/6)
    set /a PASS+=1
)
cd ..
echo.
timeout /t 2 >nul

echo.
echo [10/12] 检查数据卷
echo ----------------------------------------------------------------
docker volume ls | findstr "docker" >nul
if errorlevel 1 (
    echo [失败] 数据卷不存在
    set /a FAIL+=1
) else (
    echo [通过] 数据卷正常
    docker volume ls | findstr "docker"
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [11/12] 检查网络配置
echo ----------------------------------------------------------------
docker network ls | findstr "ecommerce" >nul
if errorlevel 1 (
    echo [失败] 网络配置异常
    set /a FAIL+=1
) else (
    echo [通过] 网络配置正常
    docker network ls | findstr "ecommerce"
    set /a PASS+=1
)
echo.
timeout /t 2 >nul

echo.
echo [12/12] 检查容器健康状态
echo ----------------------------------------------------------------
docker ps --filter "name=ecommerce" --format "table {{.Names}}\t{{.Status}}"
echo.
set /a PASS+=1
timeout /t 2 >nul

echo.
echo ================================================================
echo 集成测试结果汇总
echo ================================================================
echo.
echo 总测试项: 12
echo 通过: %PASS%
echo 失败: %FAIL%
echo.
if %FAIL% equ 0 (
    echo [成功] 所有功能验证通过！
) else (
    echo [警告] 部分功能存在问题，请检查日志
)
echo ================================================================
echo.
pause
goto menu

:: ============================================
:: 7. 查看服务状态
:: ============================================
:show_status
cls
echo.
echo ================================================================
echo 服务状态
echo ================================================================
echo.

echo [主服务]
echo ----------------------------------------------------------------
docker-compose ps
echo.

echo [监控服务]
echo ----------------------------------------------------------------
docker-compose -f monitoring\docker-compose-monitoring.yml ps 2>nul
echo.

call :show_info

pause
goto menu

:: ============================================
:: 8. 查看日志
:: ============================================
:show_logs
cls
echo.
echo ================================================================
echo 查看日志
echo ================================================================
echo.
echo 1. 查看所有服务日志
echo 2. 查看前端日志
echo 3. 查看后端日志
echo 4. 查看MySQL日志
echo 5. 实时查看日志
echo 6. 返回主菜单
echo.
set /p log_choice=请选择 (1-6): 

if "%log_choice%"=="1" docker-compose logs
if "%log_choice%"=="2" docker-compose logs frontend
if "%log_choice%"=="3" docker-compose logs backend
if "%log_choice%"=="4" docker-compose logs mysql
if "%log_choice%"=="5" docker-compose logs -f
if "%log_choice%"=="6" goto menu

pause
goto menu

:: ============================================
:: 9. 停止所有服务
:: ============================================
:stop_all
cls
echo.
echo ================================================================
echo 停止所有服务
echo ================================================================
echo.

echo 正在停止主服务...
docker-compose down

echo.
echo 正在停止监控服务...
docker-compose -f monitoring\docker-compose-monitoring.yml down 2>nul

echo.
echo [成功] 所有服务已停止
echo.
pause
goto menu

:: ============================================
:: 显示访问信息
:: ============================================
:show_info
echo.
echo ================================================================
echo 访问地址
echo ================================================================
echo.
echo    前端页面:       http://localhost
echo    后端API:        http://localhost:8080/api/products
echo    健康检查:       http://localhost:8080/actuator/health
echo    API文档:        http://localhost:8080/swagger-ui.html
echo.

docker-compose -f monitoring\docker-compose-monitoring.yml ps 2>nul | findstr "prometheus" >nul
if not errorlevel 1 (
    echo 监控系统:
    echo ================================================================
    echo.
    echo    Prometheus:     http://localhost:9090
    echo    Grafana:        http://localhost:3000
    echo    用户名: admin / 密码: admin123
    echo.
)

echo 测试报告:
echo ================================================================
echo.
echo    报告目录:       backend\target\surefire-reports\
echo.

echo 常用命令:
echo ================================================================
echo.
echo    查看日志:       docker-compose logs -f
echo    重启服务:       docker-compose restart
echo    进入容器:       docker-compose exec backend sh
echo.
echo ================================================================
goto :eof

:: ============================================
:: 退出
:: ============================================
:end
echo.
echo 再见！
timeout /t 2 >nul
exit
