import 'dart:convert';

import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:test/test.dart';

void main() {
  group('MessageConverter', () {
    final uri = Uri.parse('https://example.com');

    test('body gets set', () async {
      final r = await convertRequest(
          Request(Method('POST'), uri, Body('foo', utf8), Headers({})));
      expect(r.body, equals('foo'));
    });

    test('no body, no headers', () async {
      final r = await convertRequest(
          Request(Method('POST'), uri, Body.empty, Headers({})));
      expect(r.headers, isEmpty);
    });
  });
}
