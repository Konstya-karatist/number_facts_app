import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:number_facts_app/services/api_service.dart';

void main() {
  test('fetchNumberFact uses iseven API response to build a fact', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(
          request.url.toString(),
          'https://api.isevenapi.xyz/api/iseven/42',
        );

        return http.Response('{"ad":"ignored","iseven":true}', 200);
      }),
    );

    final fact = await service.fetchNumberFact(42);

    expect(fact.number, 42);
    expect(fact.type, 'parity');
    expect(fact.found, isTrue);
    expect(fact.text, contains('чётное'));
    expect(fact.text, isNot(contains('ignored')));
  });

  test(
    'fetchNumberFact falls back to local parity text on API error',
    () async {
      final service = ApiService(
        client: MockClient((_) async => http.Response('Unauthorized', 401)),
      );

      final fact = await service.fetchNumberFact(7);

      expect(fact.number, 7);
      expect(fact.text, contains('нечётное'));
    },
  );

  test('fetchNumberFact handles negative numbers locally', () async {
    final service = ApiService(
      client: MockClient((_) async {
        fail('Negative numbers should not be sent to iseven API.');
      }),
    );

    final fact = await service.fetchNumberFact(-8);

    expect(fact.number, -8);
    expect(fact.text, contains('чётное'));
    expect(fact.text, contains('отрицательное'));
  });
}
