import 'package:http_interop_http/src/header_folding.dart';

class StandardFolding implements HeaderFolding {
  const StandardFolding();

  static const _csvHeaders = {
    'accept',
    'accept-ch',
    'accept-encoding',
    'accept-language',
    'accept-patch',
    'accept-post',
    'access-control-allow-headers',
    'access-control-allow-methods',
    'access-control-expose-headers',
    'access-control-request-headers',
    'allow',
    'alt-svc',
    'clear-site-data',
    'content-encoding',
    'content-language',
    'critical-ch',
    'forwarded',
    'if-match',
    'if-none-match',
    'keep-alive',
    'permissions-policy',
    'server-timing',
    'te',
    'timing-allow-origin',
    'trailer',
    'transfer-encoding',
    'vary',
    'via',
    'www-authenticate',
  };

  static final _cookieSplitter = RegExp(r'(?<!(Sun|Mon|Tue|Wed|Thu|Fri|Sat)),');

  @override
  List<String> split(String keyLowerCase, String values) {
    if (_csvHeaders.contains(keyLowerCase)) {
      return values.split(',').map((it) => it.trim()).toList();
    }
    if (keyLowerCase == 'set-cookie') {
      return values.split(_cookieSplitter);
    }
    return [values];
  }

  @override
  String fold(List<String> values) => values.join(', ');
}
