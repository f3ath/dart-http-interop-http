import 'package:http/http.dart';
import 'package:http_interop/http_interop.dart';

/// Converts HTTP messages to and from to ones used by the `http` package.
class MessageConverter {
  /// Creates an instance of the converter.
  const MessageConverter();

  /// Converts [HttpRequest] to [Request].
  Request request(HttpRequest request) {
    final converted = Request(request.method.toString(), request.uri);
    final body = request.bodyBytes;
    if (body.isNotEmpty) {
      // The Request would set the content-type header if the body is assigned
      // a value (even an empty string).
      // See https://github.com/dart-lang/http/issues/841
      converted.bodyBytes = body;
    }
    converted.headers.addAll(request.headers);
    return converted;
  }

  /// Converts [Response] to [HttpResponse].
  HttpResponse response(Response response) =>
      HttpResponse.binary(response.statusCode, response.bodyBytes,
          headers: response.headers);
}
