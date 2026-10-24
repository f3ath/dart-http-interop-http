## [0.10.0] - 2026-10-24
### Changed
- BREAKING: Rename InteropHandler to ClientExt and handleInterop to sendInterop.
- BREAKING: Require Dart 3.13 or later and http\_interop 3.0.
- Stream request and response bodies without full buffering. Keep the client open until the response body is consumed or its subscription is canceled.

### Fixed
- Preserve commas in response header values while keeping Set-Cookie values separate.
- Omit empty request header lists while preserving explicit empty-string values.

## [0.9.0] - 2024-06-30
### Changed
- Simplified API

## [0.8.1] - 2024-06-29
### Fixed
- Updated the readme

## [0.8.0] - 2024-06-29
### Changed
- Bump interop to 2.0

## [0.7.0] - 2023-10-24
### Added
- Injectable header folding logic

### Changed
- ClientWrapper ctor signature

### Removed
- Injectable converters

## [0.6.0] - 2023-09-07
### Changed
- Bump interop to 0.8

## [0.5.0] - 2023-08-20
### Changed
- Bump the interop to 0.7

## [0.4.0] - 2023-08-16
### Changed
- Dependencies version bump

## [0.3.0] - 2023-05-07
### Changed
- Renamed HandlerWrapper to ClientWrapper
- Relaxed SDK version to 2.19

## [0.2.0] - 2023-05-07
### Changed
- Bump dependencies

## [0.1.1] - 2023-04-30
### Fixed
- Content-Type was set for requests with an empty body

## [0.1.0] - 2023-04-22
### Changed
- Bump deps

## [0.0.1] - 2023-04-16
### Added
- Initial commit

[0.10.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.9.0...0.10.0
[0.9.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.8.1...0.9.0
[0.8.1]: https://github.com/f3ath/dart-http-interop-http/compare/0.8.0...0.8.1
[0.8.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.7.0...0.8.0
[0.7.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.6.0...0.7.0
[0.6.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.5.0...0.6.0
[0.5.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.4.0...0.5.0
[0.4.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.3.0...0.4.0
[0.3.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.1.1...0.2.0
[0.1.1]: https://github.com/f3ath/dart-http-interop-http/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/f3ath/dart-http-interop-http/compare/0.0.1...0.1.0
[0.0.1]: https://github.com/f3ath/dart-http-interop-http/releases/tag/0.0.1
