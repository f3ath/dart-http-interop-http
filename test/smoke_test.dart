import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:test/test.dart';

void main() {
  group('Smoke test', () {
    test('can call example.com', () async {
      final response = await OneOffHandler().handle(Request(Method('get'),
          Uri.parse('https://example.com'), Body.empty(), Headers({})));
      expect(response.statusCode, equals(200));
    });
  });
}
