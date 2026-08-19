#!/bin/bash
set -e

# 0) Создаём папки RS2 и steam, если их нет
mkdir -p RS2 steam

# 1) Собираем docker image, если его ещё нет
if ! docker image inspect rs2server:latest &>/dev/null; then
    docker build -t rs2server .
fi

# 2) Убираем лишние контейнеры
docker compose down

# 3) Поднимаем сервис
docker compose up -d
