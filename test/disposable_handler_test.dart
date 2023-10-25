import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:test/test.dart';

void main() {
  test('One-off handler', () async {
    final handler = OneOffHandler();
    final response = await handler.handle(
        Request('get', Uri.parse('https://example.com'), Body(), Headers()));
    expect(response.statusCode, equals(200));
  });
}
