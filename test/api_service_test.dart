import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:number_facts_app/services/api_service.dart';

void main() {
  test('fetchNumberFact maps backend response to NumberFact', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(
          request.url.toString(),
          'https://number-facts-api-yk2u.onrender.com/api/number/42',
        );

        return http.Response(
          '{"number":42,"fact":"42 is a test fact.","source":"render-api"}',
          200,
        );
      }),
    );

    final fact = await service.fetchNumberFact(42);

    expect(fact.number, 42);
    expect(fact.type, 'render-api');
    expect(fact.found, isTrue);
    expect(fact.text, '42 is a test fact.');
  });

  test('fetchNumberFact throws readable error on backend error', () async {
    final service = ApiService(
      client: MockClient((_) async => http.Response('Unauthorized', 500)),
    );

    expect(
      () => service.fetchNumberFact(7),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('Код ответа: 500'),
        ),
      ),
    );
  });
}
