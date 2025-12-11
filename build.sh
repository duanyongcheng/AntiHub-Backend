#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 项目名称
PROJECT_NAME="antihub-backend"

echo -e "${GREEN}🚀 AntiHub Backend 构建脚本${NC}"
echo "================================"

# 检查 .env 文件
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env 文件不存在，从 .env.example 复制...${NC}"
    cp .env.example .env
    echo -e "${RED}❗ 请编辑 .env 文件配置必要的环境变量后重新运行${NC}"
    exit 1
fi

# 解析命令
case "${1:-up}" in
    build)
        echo -e "${GREEN}📦 构建镜像...${NC}"
        docker compose build --no-cache
        ;;
    up)
        echo -e "${GREEN}🔨 构建并启动服务...${NC}"
        docker compose up -d --build
        echo -e "${GREEN}✅ 服务已启动${NC}"
        docker compose ps
        ;;
    down)
        echo -e "${YELLOW}⏹️  停止服务...${NC}"
        docker compose down
        echo -e "${GREEN}✅ 服务已停止${NC}"
        ;;
    restart)
        echo -e "${YELLOW}🔄 重启服务...${NC}"
        docker compose restart
        docker compose ps
        ;;
    logs)
        docker compose logs -f ${PROJECT_NAME}
        ;;
    ps)
        docker compose ps
        ;;
    shell)
        echo -e "${GREEN}🐚 进入容器 shell...${NC}"
        docker compose exec ${PROJECT_NAME} /bin/bash
        ;;
    migrate)
        echo -e "${GREEN}🗃️  运行数据库迁移...${NC}"
        docker compose exec ${PROJECT_NAME} uv run alembic upgrade head
        ;;
    *)
        echo "用法: ./build.sh [命令]"
        echo ""
        echo "命令:"
        echo "  build    - 仅构建镜像（不启动）"
        echo "  up       - 构建并启动服务（默认）"
        echo "  down     - 停止并移除服务"
        echo "  restart  - 重启服务"
        echo "  logs     - 查看日志"
        echo "  ps       - 查看服务状态"
        echo "  shell    - 进入容器 shell"
        echo "  migrate  - 运行数据库迁移"
        ;;
esac
