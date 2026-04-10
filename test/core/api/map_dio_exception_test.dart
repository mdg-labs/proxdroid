import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/api/api_interceptors.dart';

void main() {
  test('mapDioException maps HTML body to NetworkException hint', () {
    final req = RequestOptions(path: '/version');
    final e = DioException(
      requestOptions: req,
      response: Response<dynamic>(
        requestOptions: req,
        statusCode: 502,
        data: '<html><body>cloudflare</body></html>',
      ),
      type: DioExceptionType.badResponse,
    );
    final out = mapDioException(e);
    expect(out, isA<NetworkException>());
    expect((out as NetworkException).message, contains('/api2/json'));
  });
}
