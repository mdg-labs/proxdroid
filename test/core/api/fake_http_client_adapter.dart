import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Records [RequestOptions] and returns canned [ResponseBody]s in order.
final class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this._responses);

  final List<ResponseBody> _responses;
  final List<RequestOptions> requests = <RequestOptions>[];
  int _index = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (_index >= _responses.length) {
      throw StateError('FakeHttpClientAdapter: no canned response left');
    }
    return _responses[_index++];
  }
}
