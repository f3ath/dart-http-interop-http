import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:http_interop_http/src/header_folding.dart';

extension InteropHandler on http.Client {
  /// Creates an interop [Handler] function from the client.
  /// Dart HTTP client does not understand multi-value headers and just joins
  /// them into a single string with a comma. The default implementations
  /// of [join] and [split] will provide some low-effort solution for it, but
  /// in difficult cases you can provide custom join/split logic.
  Handler interopHandler(
          {HeaderJoiner join = joinHeaders,
          HeaderSplitter split = splitHeaders}) =>
      (Request request) => request
          .toHttp(join)
          .then(send)
          .then(http.Response.fromStream)
          .then((it) => it.toInterop(split));
}

extension on http.Response {
  /// Converts to interop [Response].
  Future<Response> toInterop(HeaderSplitter split) async => Response(
      statusCode, Body.binary(bodyBytes), Headers.from(split(headers)));
}

extension on Request {
  /// Converts [Request] to [http.Request].
  Future<http.Request> toHttp(HeaderJoiner join) async {
    final request = http.Request(method.toString(), uri);
    final bodyBytes = await body.bytes.expand((b) => b).toList();
    if (bodyBytes.isNotEmpty) {
      // The Request would set the content-type header if the body is assigned
      // a value (even an empty string).
      // See https://github.com/dart-lang/http/issues/841
      request.bodyBytes = bodyBytes;
    }
    request.headers.addAll(join(headers));
    return request;
  }
}
