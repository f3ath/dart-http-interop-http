import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interop/extensions.dart';
import 'package:http_interop/http_interop.dart' as i;
import 'package:http_interop_http/http_interop_http.dart';

Future<void> main() async {
  final client = Client();
  final handler = client.interopHandler();
  final request = i.Request(
      'get',
      Uri.parse('https://example.com'),
      i.Body(),
      i.Headers.from({
        'User-Agent': ['R2-D2']
      }));
  final response = await handler(request);
  client.close(); // Don't forget to close the client.
  print(response.statusCode);
  print(response.headers);
  print(await response.body.decode(utf8));
}
