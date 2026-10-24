import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_http/http_interop_http.dart';
import 'package:test/test.dart';

void main() {
  test(
    'sendInterop sends request chunks before the upload stream ends',
    () async {
      final finishUpload = Completer<void>();
      final firstChunk = Completer<List<int>>();
      final receivedBytes = <int>[];
      const timeout = Duration(seconds: 2);

      Stream<Uint8List> uploadBytes() async* {
        yield Uint8List.fromList([1, 2]);
        await finishUpload.future;
        yield Uint8List.fromList([3, 4]);
      }

      final client = MockClient.streaming((request, body) async {
        await for (final chunk in body) {
          receivedBytes.addAll(chunk);
          if (!firstChunk.isCompleted) firstChunk.complete(List.of(chunk));
        }
        return http.StreamedResponse(const Stream.empty(), 200);
      });

      final pendingResponse = client.sendInterop(
        Request(
          'POST',
          Uri.parse('https://example.com/upload'),
          Body(uploadBytes()),
          Headers(),
        ),
      );

      try {
        // The producer stays open until the transport receives the first chunk.
        expect(await firstChunk.future.timeout(timeout), [1, 2]);
        expect(finishUpload.isCompleted, isFalse);

        finishUpload.complete();
        final response = await pendingResponse.timeout(timeout);
        expect(response.statusCode, 200);
        expect(receivedBytes, [1, 2, 3, 4]);
      } finally {
        // Release a buffering implementation too, so failure leaves no upload open.
        if (!finishUpload.isCompleted) finishUpload.complete();
        try {
          await pendingResponse.timeout(timeout);
        } finally {
          client.close();
        }
      }
    },
  );

  test(
    'sendInterop omits empty header lists but preserves empty values',
    () async {
      late Map<String, String> sentHeaders;
      final client = MockClient((request) async {
        sentHeaders = Map.of(request.headers);
        return http.Response('', 200);
      });
      addTearDown(client.close);

      await client.sendInterop(
        Request(
          'GET',
          Uri.parse('https://example.com/headers'),
          Body.empty(),
          Headers.from({
            'x-absent': [],
            'x-empty': [''],
            'x-mixed': ['', 'value', ''],
          }),
        ),
      );

      expect(sentHeaders, containsPair('x-empty', ''));
      expect(sentHeaders, containsPair('x-mixed', ', value, '));
      expect(sentHeaders, isNot(contains('x-absent')));
    },
  );

  const singletonHeaders = {
    'date': 'Sat, 24 Oct 2026 12:00:00 GMT',
    'content-disposition': 'attachment; filename="a,b.txt"',
  };

  for (final header in singletonHeaders.entries) {
    test('sendInterop preserves commas in ${header.key}', () async {
      final client = MockClient((request) async {
        return http.Response('', 200, headers: {header.key: header.value});
      });
      addTearDown(client.close);

      final response = await client.sendInterop(
        Request(
          'GET',
          Uri.parse('https://example.com/headers'),
          Body.empty(),
          Headers(),
        ),
      );

      expect(response.headers[header.key], [header.value]);
    });
  }

  test(
    'sendInterop exposes response chunks before the body stream ends',
    () async {
      final finishBody = Completer<void>();
      const timeout = Duration(seconds: 2);

      Stream<List<int>> responseBytes() async* {
        yield Uint8List.fromList([1, 2]);
        await finishBody.future;
        yield Uint8List.fromList([3, 4]);
      }

      final client = MockClient.streaming((request, body) async {
        await body.drain<void>();
        return http.StreamedResponse(responseBytes(), 200);
      });
      StreamIterator<Uint8List>? chunks;

      try {
        // The producer cannot finish until the caller receives the response.
        final response = await client
            .sendInterop(
              Request(
                'GET',
                Uri.parse('https://example.com/stream'),
                Body.empty(),
                Headers(),
              ),
            )
            .timeout(timeout);
        expect(response.statusCode, 200);

        chunks = StreamIterator(response.body.bytes);
        expect(await chunks.moveNext().timeout(timeout), isTrue);
        expect(chunks.current, [1, 2]);
        expect(finishBody.isCompleted, isFalse);

        finishBody.complete();
        expect(await chunks.moveNext().timeout(timeout), isTrue);
        expect(chunks.current, [3, 4]);
        expect(await chunks.moveNext().timeout(timeout), isFalse);
      } finally {
        // Also release a buffering implementation after the timeout failure.
        if (!finishBody.isCompleted) finishBody.complete();
        await chunks?.cancel();
        client.close();
      }
    },
  );
}
