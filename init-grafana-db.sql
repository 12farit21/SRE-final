-- Инициализация базы данных для Grafana
-- Создание базы данных grafana_db если она не существует
SELECT 'CREATE DATABASE grafana_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'grafana_db')\gexec

-- Предоставление всех привилегий пользователю user на базу grafana_db
GRANT ALL PRIVILEGES ON DATABASE grafana_db TO "user";

-- Подключение к базе grafana_db для дополнительных настроек
\c grafana_db;

-- Предоставление прав на схему public
GRANT ALL ON SCHEMA public TO "user";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "user";
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "user";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "user";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO "user"; 