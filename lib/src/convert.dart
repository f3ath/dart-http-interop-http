import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';

/// Converts [Request] to [http.Request].
Future<http.Request> convertRequest(Request request) async {
  final converted = http.Request(request.method.toString(), request.uri);
  final body = await request.body.bytes.expand((b) => b).toList();
  if (body.isNotEmpty) {
    // The Request would set the content-type header if the body is assigned
    // a value (even an empty string).
    // See https://github.com/dart-lang/http/issues/841
    converted.bodyBytes = body;
  }
  converted.headers.addAll(request.headers);
  return converted;
}

/// Converts [http.Response] to [Response].
Future<Response> convertResponse(http.Response response) async => Response(
    response.statusCode,
    Body.binary(response.bodyBytes),
    Headers(response.headers));
