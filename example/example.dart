import 'dart:convert';

import 'package:http_interop/extensions.dart';
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';

Future<void> main() async {
  final handler = OneOffHandler();
  final request = Request(
      'get',
      Uri.parse('https://example.com'),
      Body(),
      Headers.from({
        'User-Agent': ['R2-D2']
      }));
  final response = await handler.handle(request);
  print(response.statusCode);
  print(response.headers);
  print(await response.body.decode(utf8));
}
