/// Collapses header values.
typedef HeaderJoiner = Map<String, String> Function(
    Map<String, List<String>> headers);

/// Expands header values.
typedef HeaderSplitter = Map<String, List<String>> Function(
    Map<String, String>);

Map<String, String> joinHeaders(Map<String, List<String>> headers) =>
    headers.map((k, v) => MapEntry(k, v.join(', ')));

Map<String, List<String>> splitHeaders(Map<String, String> headers) =>
    headers.map((key, value) => MapEntry(
        key, _split(key.toLowerCase(), value).map((it) => it.trim()).toList()));

List<String> _split(String keyLowerCase, String values) {
  if (_listBasedHeaders.contains(keyLowerCase)) {
    return values.split(',');
  }
  if (keyLowerCase == 'set-cookie') {
    return values.split(_cookieSplitter);
  }
  return [values];
}

final _cookieSplitter = RegExp(r'(?<!(Sun|Mon|Tue|Wed|Thu|Fri|Sat)),');
const _listBasedHeaders = {
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
