class NumberFact {
  final int number;
  final String text;
  final String type;
  final bool found;

  const NumberFact({
    required this.number,
    required this.text,
    required this.type,
    required this.found,
  });

  factory NumberFact.fromJson(Map<String, dynamic> json) {
    final numberValue = json['number'];

    return NumberFact(
      number: numberValue is num ? numberValue.toInt() : 0,
      text: json['text']?.toString() ?? 'Факт не найден.',
      type: json['type']?.toString() ?? 'trivia',
      found: json['found'] == true,
    );
  }
}
