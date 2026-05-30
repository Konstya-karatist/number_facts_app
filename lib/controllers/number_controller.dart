import '../models/number_fact.dart';
import '../services/api_service.dart';

class NumberController {
  final ApiService _apiService;

  NumberController({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<NumberFact> getNumberFact(String input) {
    final text = input.trim();

    if (text.isEmpty) {
      throw Exception('Введите число.');
    }

    final number = int.tryParse(text);

    if (number == null) {
      throw Exception('Введите корректное целое число.');
    }

    return _apiService.fetchNumberFact(number);
  }
}
