import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';

extension InteropHandler on http.Client {
  /// Handle interop [Request].
  Future<Response> handleInterop(Request request) => request
      .toHttp()
      .then(send)
      .then(http.Response.fromStream)
      .then((r) => Response(r.statusCode, Body.binary(r.bodyBytes),
          Headers.from(r.headersSplitValues)));
}

extension on Request {
  Future<http.Request> toHttp() async => http.Request(method.toString(), uri)
    ..bodyBytes = await body.bytes.expand((b) => b).toList()
    ..headers.addAll(headers.map((k, v) => MapEntry(k, v.join(', '))));
}
