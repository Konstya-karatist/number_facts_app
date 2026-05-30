import 'package:flutter_test/flutter_test.dart';

import 'package:number_facts_app/main.dart';

void main() {
  testWidgets('Home page shows number fact form', (WidgetTester tester) async {
    await tester.pumpWidget(const NumberFactsApp());

    expect(find.text('Факты о числах'), findsOneWidget);
    expect(find.text('Получить факт'), findsOneWidget);
    expect(find.text('Число'), findsOneWidget);
  });
}
