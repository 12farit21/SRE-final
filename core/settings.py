import os
from pathlib import Path
from django_prometheus.middleware import PrometheusAfterMiddleware, PrometheusBeforeMiddleware
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(os.path.join(BASE_DIR, '.env'))

SECRET_KEY = os.getenv('SECRET_KEY', 'ybuasdvybadlsvl23892309-124njzvxvxkjl34!@12r')

DEBUG = False

ALLOWED_HOSTS = [
    'localhost',
    '127.0.0.1',
    'web',           # Для обратной совместимости с docker-compose.yml
    'django-app-0',  # Имя контейнера из Terraform
    'django-app-1',  # Имя контейнера из Terraform
    'django-app-0:8000',  # Заголовок Host с портом
    'django-app-1:8001',  # Заголовок Host с портом
]

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'tasks',
    'django_prometheus',
]

MIDDLEWARE = [
    'django_prometheus.middleware.PrometheusBeforeMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django_prometheus.middleware.PrometheusAfterMiddleware',
]

ROOT_URLCONF = 'core.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'tasks/templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'core.wsgi.application'

# Динамическая настройка базы данных
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://user:password@db:5432/todo_db')
if 'GITHUB_ACTIONS' in os.environ:
    DATABASE_URL = 'postgresql://user:password@localhost:5432/todo_db'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'todo_db',
        'USER': 'user',
        'PASSWORD': os.getenv('POSTGRES_PASSWORD', 'password'),
        'HOST': 'localhost' if 'GITHUB_ACTIONS' in os.environ else 'db',
        'PORT': '5432',
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True

STATIC_URL = '/static/'

PROMETHEUS_EXPORT_METRICS = True

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'