@echo off
chcp 65001 >nul
cls
echo.
echo ================================================================
echo                    停止所有服务
echo ================================================================
echo.

cd /d "%~dp0"

echo [1/2] 停止主服务...
docker-compose down

if errorlevel 1 (
    echo [错误] 主服务停止失败
) else (
    echo [成功] 主服务已停止
)

echo.
echo [2/2] 停止监控服务...
docker-compose -f monitoring\docker-compose-monitoring.yml down 2>nul

if errorlevel 1 (
    echo [提示] 监控服务未运行或已停止
) else (
    echo [成功] 监控服务已停止
)

echo.
echo ================================================================
echo                  所有服务已停止
echo ================================================================
echo.
echo 提示:
echo   - 数据已保存在Docker卷中
echo   - 重新启动: start.bat
echo   - 删除所有数据: docker-compose down -v
echo.
pause
