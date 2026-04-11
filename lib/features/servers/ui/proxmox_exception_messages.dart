import 'package:dio/dio.dart';

import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

const int _kTechnicalDetailMaxLength = 280;

String? _truncateTechnicalDetail(String? raw) {
  if (raw == null) return null;
  final t = raw.trim();
  if (t.isEmpty) return null;
  if (t.length <= _kTechnicalDetailMaxLength) return t;
  return '${t.substring(0, _kTechnicalDetailMaxLength)}…';
}

/// Maps typed API errors to localized user-visible messages.
///
/// When the exception carries a [message], it is appended (truncated) so
/// Dio/Proxmox hints are visible (e.g. TLS errors, auth failure text).
String proxmoxExceptionMessage(Object error, AppLocalizations l10n) {
  if (error is! ProxmoxException) return l10n.errorProxmoxUnknown;

  final (String summary, String? detail) = switch (error) {
    AuthException(:final message) => (l10n.errorProxmoxAuth, message),
    NetworkException(:final message) => (l10n.errorProxmoxNetwork, message),
    ApiTimeoutException(:final message) => (l10n.errorProxmoxTimeout, message),
    PermissionException(:final message) => (
      l10n.errorProxmoxPermission,
      message,
    ),
    ServerException(:final statusCode, :final message) => (
      l10n.errorProxmoxServer(statusCode),
      message,
    ),
  };

  final d = _truncateTechnicalDetail(detail);
  if (d == null) return summary;
  return '$summary\n${l10n.errorProxmoxTechnicalDetails(d)}';
}

/// Full technical text for the verbose connection-test dialog (not localized).
String proxmoxExceptionDiagnosticsText(Object error) {
  if (error is DioException) {
    final inner = error.error;
    if (inner is ProxmoxException) {
      return proxmoxExceptionDiagnosticsText(inner);
    }
    final ro = error.requestOptions;
    final path = ro.path;
    final status = error.response?.statusCode;
    final buf =
        StringBuffer('DioException')
          ..writeln('\ntype: ${error.type.name}')
          ..writeln('method: ${ro.method}');
    if (error.message != null && error.message!.trim().isNotEmpty) {
      buf.writeln('message: ${error.message}');
    }
    if (status != null) {
      buf.writeln('statusCode: $status');
    }
    buf.writeln('path: $path');
    return buf.toString();
  }
  if (error is ProxmoxException) {
    return switch (error) {
      AuthException(:final message) =>
        'AuthException${message != null ? '\n$message' : ''}',
      NetworkException(:final message) =>
        'NetworkException${message != null ? '\n$message' : ''}',
      ApiTimeoutException(:final message) =>
        'ApiTimeoutException${message != null ? '\n$message' : ''}',
      PermissionException(:final message) =>
        'PermissionException${message != null ? '\n$message' : ''}',
      ServerException(:final statusCode, :final message) =>
        'ServerException HTTP $statusCode${message != null ? '\n$message' : ''}',
    };
  }
  return 'Unknown error (${error.runtimeType}); raw details omitted.';
}
