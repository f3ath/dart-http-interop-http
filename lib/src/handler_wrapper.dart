import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/src/message_converter.dart';

/// A wrapper over the standard Dart HTTP client.
/// It is the developer's responsibility to instantiate the client and
/// call `close()` on it in the end of the application lifecycle.
class HandlerWrapper implements Handler {
  /// Creates a new instance of the wrapper. Do not forget to call `close()` on
  /// the [client] when it's not longer needed.
  ///
  /// Use [messageConverter] to fine tune the HTTP request/response conversion.
  HandlerWrapper(this.client,
      {this.messageConverter = const MessageConverter()});

  final http.Client client;
  final MessageConverter messageConverter;

  @override
  Future<Response> handle(Request request) async {
    final convertedRequest = messageConverter.request(request);
    final streamedResponse = await client.send(convertedRequest);
    final response = await http.Response.fromStream(streamedResponse);
    return messageConverter.response(response);
  }
}
