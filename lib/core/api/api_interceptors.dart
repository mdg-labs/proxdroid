import 'package:dio/dio.dart';

import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

/// Extra key: skip attaching auth (used for `POST /access/ticket`).
const String kProxmoxSkipAuth = 'proxmoxSkipAuth';

/// Extra key: set after one 401 retry to avoid loops (username/password flow).
const String kProxmoxAuthRetried = 'proxmoxAuthRetried';

/// Maps a [DioException] to a [ProxmoxException] subtype.
ProxmoxException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ApiTimeoutException(e.message);
    case DioExceptionType.connectionError:
      return NetworkException(e.message);
    case DioExceptionType.badResponse:
      final resp = e.response;
      final rawData = resp?.data;
      final contentType =
          resp?.headers.value('content-type')?.toLowerCase() ?? '';
      if (rawData is String &&
          (rawData.trimLeft().startsWith('<') ||
              contentType.contains('text/html'))) {
        return const NetworkException(
          'Received HTML instead of the Proxmox API JSON. '
          'Ensure your reverse proxy or Cloudflare tunnel forwards paths under '
          '/api2/json/ to Proxmox.',
        );
      }
      final code = resp?.statusCode ?? 0;
      final msg = _messageFromResponse(rawData);
      if (code == 401) {
        return AuthException(msg);
      }
      if (code == 403) {
        return PermissionException(msg);
      }
      return ServerException(code, message: msg);
    case DioExceptionType.cancel:
      return NetworkException(e.message ?? 'Request cancelled');
    case DioExceptionType.badCertificate:
      return NetworkException(e.message ?? 'Bad certificate');
    case DioExceptionType.unknown:
      final inner = e.error;
      if (inner is ProxmoxException) {
        return inner;
      }
      return NetworkException(e.message ?? inner?.toString());
  }
}

String? _messageFromResponse(dynamic data) {
  if (data is Map<String, dynamic>) {
    final errors = data['errors'];
    if (errors is String) return errors;
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is String) return first;
    }
    final message = data['message'];
    if (message is String) return message;
  }
  return null;
}

/// Converts Dio failures into [ProxmoxException] via [DioException.error].
///
/// Register this **before** [ProxmoxAuthInterceptor] so auth `onError` runs
/// first on the error chain (Dio invokes `onError` in reverse add order).
class ProxmoxErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = mapDioException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: mapped.toString(),
      ),
    );
  }
}

/// In-memory ticket + CSRF for username/password auth; API token header otherwise.
class ProxmoxAuthInterceptor extends Interceptor {
  ProxmoxAuthInterceptor({
    required Dio dio,
    required this.serverAuthIsToken,
    this.apiToken,
    this.username,
    this.password,
  }) : _dio = dio;

  final Dio _dio;
  final bool serverAuthIsToken;

  /// Full `USER@REALM!TOKENID=SECRET` string as copied from the Proxmox UI
  /// (the part after `PVEAPIToken=` in the Authorization header).
  final String? apiToken;
  final String? username;
  final String? password;

  String? _ticket;
  String? _csrf;

  void clearSession() {
    _ticket = null;
    _csrf = null;
  }

  bool _isTicketPath(RequestOptions o) =>
      o.path == ApiEndpoints.accessTicket ||
      o.uri.path.endsWith('/access/ticket');

  bool _isMutating(String method) {
    final m = method.toUpperCase();
    return m == 'POST' || m == 'PUT' || m == 'PATCH' || m == 'DELETE';
  }

  Future<void> _acquireTicket() async {
    if (username == null || password == null) {
      throw const AuthException('Missing username or password');
    }
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.accessTicket,
      data: <String, dynamic>{'username': username, 'password': password},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        extra: <String, dynamic>{kProxmoxSkipAuth: true},
      ),
    );
    final data = response.data;
    if (data == null) {
      throw const AuthException('Empty ticket response');
    }
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      throw const AuthException('Invalid ticket response');
    }
    final t = inner['ticket'];
    final c = inner['CSRFPreventionToken'];
    if (t is! String || c is! String) {
      throw const AuthException('Missing ticket or CSRFPreventionToken');
    }
    _ticket = t;
    _csrf = c;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[kProxmoxSkipAuth] == true) {
      handler.next(options);
      return;
    }

    if (serverAuthIsToken) {
      final token = apiToken;
      if (token == null || token.isEmpty) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.unknown,
            error: const AuthException('Missing API token'),
          ),
        );
        return;
      }
      options.headers['Authorization'] = 'PVEAPIToken=$token';
      handler.next(options);
      return;
    }

    try {
      if (_ticket == null) {
        await _acquireTicket();
      }
    } on DioException catch (e) {
      handler.reject(e);
      return;
    } catch (e, st) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: e is ProxmoxException ? e : AuthException(e.toString()),
          stackTrace: st,
        ),
      );
      return;
    }

    options.headers['Cookie'] = 'PVEAuthCookie=$_ticket';
    if (_isMutating(options.method)) {
      options.headers['CSRFPreventionToken'] = _csrf;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (serverAuthIsToken) {
      handler.next(err);
      return;
    }

    final status = err.response?.statusCode;
    final ro = err.requestOptions;

    if (status != 401) {
      handler.next(err);
      return;
    }

    if (_isTicketPath(ro)) {
      handler.next(err);
      return;
    }

    if (ro.extra[kProxmoxAuthRetried] == true) {
      handler.next(err);
      return;
    }

    clearSession();

    try {
      await _acquireTicket();
    } on DioException catch (e) {
      handler.next(e);
      return;
    } catch (e, st) {
      handler.reject(
        DioException(
          requestOptions: ro,
          type: DioExceptionType.unknown,
          error: e is ProxmoxException ? e : AuthException(e.toString()),
          stackTrace: st,
        ),
      );
      return;
    }

    final nextExtra = Map<String, dynamic>.from(ro.extra)
      ..[kProxmoxAuthRetried] = true;

    try {
      final response = await _dio.fetch<dynamic>(ro.copyWith(extra: nextExtra));
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
