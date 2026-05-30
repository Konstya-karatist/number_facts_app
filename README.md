# Number Facts App

Flutter-приложение "Факты о числах". Пользователь вводит число, приложение
получает факт из backend API и показывает результат на экране.

## Стек

- Flutter
- Dart
- Node.js
- Express
- Render

## Архитектура

Flutter-часть проекта построена по MVC:

- `models` - модели данных;
- `services` - работа с API;
- `controllers` - проверка ввода и связь между view и service;
- `views` - пользовательский интерфейс.

## Структура проекта

```text
lib/
├── models/
├── services/
├── controllers/
├── views/
└── main.dart

server/
├── index.js
├── package.json
└── package-lock.json
```

## Запуск Flutter

```bash
flutter pub get
flutter run -d chrome
```

## Render API

```text
https://number-facts-api-yk2u.onrender.com/api/number/:number
```

Пример:

```text
https://number-facts-api-yk2u.onrender.com/api/number/42
```

## Запуск backend локально

```bash
cd server
npm install
npm start
```

Локальный endpoint:

```text
http://localhost:3000/api/number/:number
```
