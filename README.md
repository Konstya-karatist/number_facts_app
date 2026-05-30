# Факты о числах

Учебное Flutter-приложение для зачета. Пользователь вводит число, нажимает
`Получить факт`, а приложение получает факт из собственного backend API.

## Backend

Backend находится в папке `server` и использует Node.js, Express и CORS.

Основной endpoint:

```text
GET /api/number/:number
```

Пример ответа:

```json
{
  "number": 42,
  "fact": "42 известно как ответ на главный вопрос жизни, Вселенной и всего такого в книге Дугласа Адамса.",
  "source": "render-api"
}
```

В `server/index.js` есть локальная база из 50+ фактов, включая числа `7`, `13`,
`42`, `100`, `360`, `666`, `777`, `1000`, `1729` и `2024`. Если числа нет в
базе, server возвращает простой fallback-факт.

## Запуск server локально

```bash
cd server
npm install
npm start
```

По умолчанию server запускается на:

```text
http://localhost:3000
```

Проверка endpoint:

```bash
curl http://localhost:3000/api/number/42
```

## Запуск Flutter

Сначала запустите server локально, затем в корне проекта выполните:

```bash
flutter pub get
flutter run -d chrome
```

Flutter web сейчас использует временный локальный URL:

```text
http://localhost:3000/api/number/$number
```

Позже его можно заменить на Render URL через `--dart-define`:

```bash
flutter run -d chrome --dart-define=NUMBER_FACTS_API_BASE_URL=https://your-render-service.onrender.com/api/number
```

## Деплой server на Render

1. Загрузите проект в GitHub.
2. На Render создайте новый `Web Service`.
3. Выберите репозиторий с проектом.
4. В поле `Root Directory` укажите `server`.
5. Укажите `Build Command`:

```bash
npm install
```

6. Укажите `Start Command`:

```bash
npm start
```

7. После деплоя Render выдаст URL сервиса. Для Flutter используйте адрес вида:

```text
https://your-render-service.onrender.com/api/number
```

## MVC-архитектура Flutter

- `lib/models/number_fact.dart` - модель данных одного факта о числе;
- `lib/services/api_service.dart` - HTTP-запрос к backend API;
- `lib/controllers/number_controller.dart` - проверка ввода и связь между view и service;
- `lib/views/home_page.dart` - экран приложения и пользовательский интерфейс;
- `lib/main.dart` - точка входа и настройка Material Design.

Проверка Flutter-проекта:

```bash
dart analyze
flutter test
flutter build web
```
