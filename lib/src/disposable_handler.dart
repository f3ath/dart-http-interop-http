import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/src/handler_wrapper.dart';
import 'package:http_interop_http/src/message_converter.dart';

/// This HTTP handler creates a new instance of the client for every request
/// and closes the client after the request completes.
class DisposableHandler implements Handler {
  const DisposableHandler({this.messageConverter = const MessageConverter()});

  final MessageConverter messageConverter;

  @override
  Future<Response> handle(Request request) async {
    final client = http.Client();
    try {
      return await HandlerWrapper(client, messageConverter: messageConverter)
          .handle(request);
    } finally {
      client.close();
    }
  }
}
