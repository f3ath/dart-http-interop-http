# http_interop_http

[Interop]-compatible wrapper over the standard Dart http package.

Use `sendInterop` on an existing `http.Client` to send an interop `Request`
and receive an interop `Response`.

```dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interop/extensions.dart';
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';

Future<void> main() async {
  final client = http.Client();
  try {
    final request = Request(
      'GET',
      Uri.parse('https://example.com'),
      Body.empty(),
      Headers.from({
        'User-Agent': ['R2-D2'],
      }),
    );
    final response = await client.sendInterop(request);
    print(response.statusCode);
    print(response.headers);
    print(await response.body.decode(utf8));
  } finally {
    client.close();
  }
}
```

Request and response bodies are streamed without buffering the entire body in
the adapter. `sendInterop` returns when the response headers are available.
Keep the client open until the response body is consumed or its subscription
is canceled. Decoding the body consumes the stream and buffers the decoded
text in memory. Supply a fresh request body when retrying unless its stream
supports replay.

Request header values are joined with `, `. Empty value lists are omitted;
explicit empty-string values are preserved. Response header values are kept
whole, including commas, except that `Set-Cookie` values are split into
separate entries.

[Interop]: https://pub.dev/packages/http_interop
