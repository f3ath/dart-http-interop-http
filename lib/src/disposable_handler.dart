import 'package:http/http.dart' as http;
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/src/client_wrapper.dart';

/// This HTTP handler creates a new instance of the [http.Client] for every request
/// and closes the client after the request completes.
class OneOffHandler implements Handler {
  const OneOffHandler();

  @override
  Future<Response> handle(Request request) async {
    final client = http.Client();
    try {
      return await ClientWrapper(client).handle(request);
    } finally {
      client.close();
    }
  }
}
