import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';

/// Interop request support for [http.Client].
extension ClientExt on http.Client {
  /// Sends [request] and returns an interop [Response].
  ///
  /// Forwards request and response body streams without buffering the entire
  /// body in this adapter. Completes when the client's response headers are
  /// available; subsequent response body errors are emitted by [Body.bytes].
  /// Keep the client open until the response body is consumed or its
  /// subscription is canceled. This method does not close the client.
  ///
  /// Consumes the request body according to its stream's subscription rules.
  /// Retries require a fresh body unless the stream supports replay.
  ///
  /// Joins request header values with `, `, omitting empty lists while
  /// preserving empty-string values. Preserves response header values whole,
  /// except that `Set-Cookie` values are split into separate entries.
  Future<Response> sendInterop(Request request) async {
    final response = await send(_InteropRequest(request));
    return Response(
      response.statusCode,
      Body(response.stream.map(Uint8List.fromList)),
      Headers.from(
        response.headers.map(
          (name, value) => MapEntry(
            name,
            name == 'set-cookie' ? response.headersSplitValues[name]! : [value],
          ),
        ),
      ),
    );
  }
}

class _InteropRequest(Request request) extends http.BaseRequest {
  this : _body = request.body, super(request.method, request.uri) {
    headers.addEntries(
      request.headers.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => MapEntry(entry.key, entry.value.join(', '))),
    );
  }

  final Body _body;

  @override
  http.ByteStream finalize() {
    super.finalize();
    return http.ByteStream(_body.bytes);
  }
}
