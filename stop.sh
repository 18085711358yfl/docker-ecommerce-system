#!/bin/bash

echo ""
echo "================================================================"
echo "                    停止所有服务"
echo "================================================================"
echo ""

cd "$(dirname "$0")"

echo "[1/2] 停止主服务..."
docker-compose down

if [ $? -eq 0 ]; then
    echo "[成功] 主服务已停止"
else
    echo "[错误] 主服务停止失败"
fi

echo ""
echo "[2/2] 停止监控服务..."
docker-compose -f monitoring/docker-compose-monitoring.yml down 2>/dev/null

if [ $? -eq 0 ]; then
    echo "[成功] 监控服务已停止"
else
    echo "[提示] 监控服务未运行或已停止"
fi

echo ""
echo "================================================================"
echo "                  所有服务已停止"
echo "================================================================"
echo ""
echo "提示:"
echo "  - 数据已保存在Docker卷中"
echo "  - 重新启动: ./start.sh"
echo "  - 删除所有数据: docker-compose down -v"
echo ""
