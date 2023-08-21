import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/src/convert.dart' as c;

/// A wrapper over the standard Dart HTTP client.
/// It is the developer's responsibility to instantiate the client and
/// call `close()` on it in the end of the application lifecycle.
class ClientWrapper implements Handler {
  /// Creates a new instance of the wrapper. Do not forget to call `close()` on
  /// the [client] when it's not longer needed.
  ClientWrapper(this.client,
      {this.convertRequest = c.convertRequest,
      this.convertResponse = c.convertResponse});

  final http.Client client;
  final RequestConverter convertRequest;
  final ResponseConverter convertResponse;

  @override
  Future<Response> handle(Request request) => convertRequest(request)
      .then(client.send)
      .then(http.Response.fromStream)
      .then(convertResponse);
}

typedef RequestConverter = Future<http.Request> Function(Request);
typedef ResponseConverter = Future<Response> Function(http.Response);
