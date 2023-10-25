import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/src/header_folding.dart';
import 'package:http_interop_http/src/standard_folding.dart';

/// A wrapper over the standard Dart HTTP client.
/// It is the developer's responsibility to instantiate the client and
/// call `close()` on it in the end of the application lifecycle.
class ClientWrapper implements Handler {
  /// Creates a new instance of the wrapper. Do not forget to call `close()` on
  /// the [_client] when it's not longer needed.
  ClientWrapper(this._client, {HeaderFolding folding = const StandardFolding()})
      : _folding = folding;

  final http.Client _client;
  final HeaderFolding _folding;

  @override
  Future<Response> handle(Request request) => _convertRequest(request)
      .then(_client.send)
      .then(http.Response.fromStream)
      .then(_convertResponse);

  /// Converts [Request] to [http.Request].
  Future<http.Request> _convertRequest(Request request) async {
    final converted = http.Request(request.method.toString(), request.uri);
    final bodyBytes = await request.body.bytes.expand((b) => b).toList();
    if (bodyBytes.isNotEmpty) {
      // The Request would set the content-type header if the body is assigned
      // a value (even an empty string).
      // See https://github.com/dart-lang/http/issues/841
      converted.bodyBytes = bodyBytes;
    }
    request.headers.forEach((key, values) {
      if (values.isEmpty) return;
      converted.headers[key] = _folding.fold(values);
    });
    return converted;
  }

  /// Converts [http.Response] to [Response].
  Future<Response> _convertResponse(http.Response response) async => Response(
      response.statusCode,
      Body.binary(response.bodyBytes),
      Headers.from(response.headers.map((key, value) =>
          MapEntry(key, _folding.split(key.toLowerCase(), value)))));
}
