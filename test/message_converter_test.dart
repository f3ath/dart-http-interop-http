import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:test/test.dart';

void main() {
  group('MessageConverter', () {
    final converter = MessageConverter();
    final uri = Uri.parse('https://example.com');

    test('body gets set', () {
      final r = converter.request(HttpRequest('POST', uri,  'foo'));
      expect(r.body, equals('foo'));
    });
    test('default charset it used', () {
      final r = converter.response(http.Response('foo', 200));
      expect(r.body, equals('foo'));
    });

    test('No headers are set for GET requests', () {
      final r = converter.request(HttpRequest('GET', uri, ''));
      expect(r.headers, isEmpty);
    });

    test('No headers are set for OPTIONS requests', () {
      final r = converter.request(HttpRequest('OPTIONS', uri, ''));
      expect(r.headers, isEmpty);
    });

    test('No headers are set for DELETE requests', () {
      final r = converter.request(HttpRequest('DELETE', uri, ''));
      expect(r.headers, isEmpty);
    });
  });
}
