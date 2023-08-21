import 'dart:convert';

import 'package:http_interop/extensions.dart';
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';

Future<void> main() async {
  final handler = OneOffHandler();
  final request = Request(
      Method('get'), Uri.parse('https://example.com'), Body.empty, Headers({}));
  final response = await handler.handle(request);
  print(response.statusCode);
  print(response.headers);
  print(await response.body.decode(utf8));
}
