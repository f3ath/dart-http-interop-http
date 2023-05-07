import 'package:http/http.dart';
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/src/client_wrapper.dart';
import 'package:http_interop_http/src/message_converter.dart';

/// This HTTP handler creates a new instance of the client for every request
/// and closes the client after the request completes.
class DisposableHandler implements HttpHandler {
  const DisposableHandler({this.messageConverter = const MessageConverter()});

  final MessageConverter messageConverter;

  @override
  Future<HttpResponse> handle(HttpRequest request) async {
    final client = Client();
    try {
      return await ClientWrapper(client, messageConverter: messageConverter)
          .handle(request);
    } finally {
      client.close();
    }
  }
}
