import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';

Future<void> main() async {
  final handler = DisposableHandler();
  final request = HttpRequest('get', Uri.parse('https://example.com'));
  final response = await handler.handle(request);
  print(response.statusCode);
  print(response.headers);
  print(response.body);
}
