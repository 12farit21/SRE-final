#!/bin/bash
# Скрипт для проверки состояния сервисов

echo "🔍 Проверка состояния контейнеров..."
docker-compose ps

echo -e "\n🗄️  Проверка состояния базы данных..."
docker-compose exec -T db pg_isready -U user -d todo_db

echo -e "\n📊 Проверка доступности Prometheus..."
curl -s -f http://localhost:9090/api/v1/status/config > /dev/null && echo "✅ Prometheus доступен" || echo "❌ Prometheus недоступен"

echo -e "\n📈 Проверка доступности Grafana..."
curl -s -f http://localhost:3000 > /dev/null && echo "✅ Grafana доступен" || echo "❌ Grafana недоступен"

echo -e "\n🚨 Проверка доступности AlertManager..."
curl -s -f http://localhost:9093 > /dev/null && echo "✅ AlertManager доступен" || echo "❌ AlertManager недоступен"

echo -e "\n🌐 Проверка доступности веб-приложения..."
curl -s -f http://localhost > /dev/null && echo "✅ Веб-приложение доступно" || echo "❌ Веб-приложение недоступно"

echo -e "\n📋 Последние логи базы данных:"
docker-compose logs --tail=10 db 