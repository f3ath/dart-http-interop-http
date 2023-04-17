# http_interop_http

[Interop]-compatible wrapper over the standard Dart http package.

```dart
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';

Future<void> main() async {
  final handler = DisposableHandler();
  final request = Request('get', Uri.parse('https://example.com'));
  final response = await handler.handle(request);
  print(response.statusCode);
  print(response.headers);
  print(response.body);
}
```


[Interop]: https://pub.dev/packages/http_interop