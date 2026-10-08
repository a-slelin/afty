# Affinity

Учебное веб-приложение для знакомств на микросервисной архитектуре.

Пользователи заполняют анкету, проходят короткий тест на совместимость и ставят лайки.
При взаимной симпатии появляется мэтч и открывается чат. Сервис только для пользователей 18+.

## Стек

- **Backend:** Python, FastAPI, 4 микросервиса
- **База данных:** PostgreSQL (своя схема на каждый сервис), миграции Alembic
- **Кэш:** Redis
- **Шлюз:** nginx
- **Фронтенд:** HTML / CSS / JavaScript
- **Запуск:** Docker, docker-compose

## Сервисы

| Сервис             | За что отвечает                               |
|--------------------|-----------------------------------------------|
| `auth-service`     | Регистрация, вход, JWT-токены, роли           |
| `profile-service`  | Анкеты, фото, тест на совместимость           |
| `matching-service` | Лента анкет, лайки, мэтчи, дневные лимиты     |
| `chat-service`     | Чат, WebSocket, жалобы                        |

## Запуск

Нужен установленный и запущенный [Docker Desktop](https://www.docker.com/products/docker-desktop/).

```bash
git clone https://github.com/a-slelin/affinity.git
cd affinity
cp .env.example .env     # на Windows: copy .env.example .env
docker compose up --build
```

После запуска откройте:

- приложение — http://localhost:8080
- документация API (Swagger) — `http://localhost:8080/api/<сервис>/docs`,
  где `<сервис>` — `auth`, `profiles`, `matching` или `chat`

Остановить: `Ctrl+C`, затем `docker compose down`.

## Документация

Техническое задание — в папке [`TechSpec`](TechSpec/).

## Команда

| Участник          | Роль |
|-------------------|------|
| a-slelin          |      |
| Konsulot          |      |
| Dominus-Exitio    |      |
| AdskiySotona666   |      |
