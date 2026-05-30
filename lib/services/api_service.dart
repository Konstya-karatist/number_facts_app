import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/number_fact.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.isevenapi.xyz/api/iseven';

  final http.Client _client;

  Future<NumberFact> fetchNumberFact(int number) async {
    if (number < 0) {
      return _buildParityFact(number, number.isEven);
    }

    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/$number'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return _buildParityFact(number, number.isEven);
      }

      final data = jsonDecode(response.body);

      if (data is! Map<String, dynamic>) {
        return _buildParityFact(number, number.isEven);
      }

      final isEven = data['iseven'];

      if (isEven is! bool) {
        return _buildParityFact(number, number.isEven);
      }

      return _buildParityFact(number, isEven);
    } on TimeoutException {
      return _buildParityFact(number, number.isEven);
    } on http.ClientException {
      return _buildParityFact(number, number.isEven);
    } on FormatException {
      return _buildParityFact(number, number.isEven);
    }
  }

  NumberFact _buildParityFact(int number, bool isEven) {
    final parity = isEven ? 'чётное' : 'нечётное';
    final division = isEven
        ? 'Оно делится на 2 без остатка.'
        : 'Оно не делится на 2 без остатка.';

    if (number == 0) {
      return NumberFact(
        number: number,
        text: '0 — чётное число. Ноль делится на 2 без остатка.',
        type: 'parity',
        found: true,
      );
    }

    final sign = number > 0 ? 'положительное' : 'отрицательное';

    return NumberFact(
      number: number,
      text: '$number — $parity $sign число. $division',
      type: 'parity',
      found: true,
    );
  }
}
