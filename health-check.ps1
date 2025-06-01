# PowerShell скрипт для проверки состояния сервисов

Write-Host "🔍 Проверка состояния контейнеров..." -ForegroundColor Cyan
docker-compose ps

Write-Host "`n🗄️  Проверка состояния базы данных..." -ForegroundColor Cyan
docker-compose exec -T db pg_isready -U user -d todo_db

Write-Host "`n📊 Проверка доступности Prometheus..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9090/api/v1/status/config" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Prometheus доступен" -ForegroundColor Green
} catch {
    Write-Host "❌ Prometheus недоступен" -ForegroundColor Red
}

Write-Host "`n📈 Проверка доступности Grafana..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Grafana доступен" -ForegroundColor Green
} catch {
    Write-Host "❌ Grafana недоступен" -ForegroundColor Red
}

Write-Host "`n🚨 Проверка доступности AlertManager..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9093" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ AlertManager доступен" -ForegroundColor Green
} catch {
    Write-Host "❌ AlertManager недоступен" -ForegroundColor Red
}

Write-Host "`n🌐 Проверка доступности веб-приложения..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Веб-приложение доступно" -ForegroundColor Green
} catch {
    Write-Host "❌ Веб-приложение недоступно" -ForegroundColor Red
}

Write-Host "`n📋 Последние логи базы данных:" -ForegroundColor Cyan
docker-compose logs --tail=10 db 