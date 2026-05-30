import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/number_fact.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _webApiBaseUrl = String.fromEnvironment(
    'NUMBER_FACTS_API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/number',
  );
  static const String _localApiBaseUrl = 'http://localhost:3000/api/number';

  final http.Client _client;

  Future<NumberFact> fetchNumberFact(int number) async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/$number'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Не удалось получить факт. Код ответа: ${response.statusCode}.',
        );
      }

      final data = jsonDecode(response.body);

      if (data is! Map<String, dynamic>) {
        throw Exception('Сервер вернул неожиданный формат данных.');
      }

      final responseNumber = data['number'];
      final fact = data['fact']?.toString().trim();

      if (responseNumber is! num || fact == null || fact.isEmpty) {
        throw Exception('В ответе сервера нет данных о факте.');
      }

      return NumberFact(
        number: responseNumber.toInt(),
        text: fact,
        type: data['source']?.toString() ?? 'render-api',
        found: true,
      );
    } on http.ClientException {
      throw Exception('Ошибка сети. Проверьте, что локальный server запущен.');
    } on TimeoutException {
      throw Exception('Сервер не ответил вовремя.');
    } on FormatException {
      throw Exception('Не удалось обработать ответ сервера.');
    }
  }

  String get _baseUrl => kIsWeb ? _webApiBaseUrl : _localApiBaseUrl;
}
