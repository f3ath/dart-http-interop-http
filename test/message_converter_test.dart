import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:test/test.dart';

void main() {
  group('MessageConverter', () {
    test('body gets set', () {
      final r =
          MessageConverter().request(HttpRequest('POST', Uri(), body: 'foo'));
      expect(r.body, equals('foo'));
    });
    test('default charset it used', () {
      final r = MessageConverter().response(http.Response('foo', 200));
      expect(r.body, equals('foo'));
    });
  });
}
