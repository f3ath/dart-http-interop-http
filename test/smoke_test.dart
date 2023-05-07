import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:test/test.dart';

void main() {
  group('Smoke test', () {
    test('can call example.com', () async {
      final response = await DisposableHandler()
          .handle(HttpRequest('get', Uri.parse('https://example.com'), ''));
      expect(response.statusCode, equals(200));
    });
  });
}
