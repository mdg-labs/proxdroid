/// Typed errors for Proxmox API usage (see `docs/ProxDroid_Architecture.md` §10).
///
/// Repositories should catch [DioException] from the client layer and rethrow
/// these types rather than leaking raw HTTP errors to the UI.
sealed class ProxmoxException implements Exception {
  const ProxmoxException();
}

/// Authentication failed (invalid API token, bad password, expired ticket).
final class AuthException extends ProxmoxException {
  const AuthException([this.message]);

  final String? message;

  @override
  String toString() =>
      message != null ? 'AuthException: $message' : 'AuthException';
}

/// Connectivity / DNS / TLS handshake failures before a response is received.
final class NetworkException extends ProxmoxException {
  const NetworkException([this.message]);

  final String? message;

  @override
  String toString() =>
      message != null ? 'NetworkException: $message' : 'NetworkException';
}

/// Connection or receive timeout from Dio (not `dart:async` [TimeoutException]).
final class ApiTimeoutException extends ProxmoxException {
  const ApiTimeoutException([this.message]);

  final String? message;

  @override
  String toString() =>
      message != null ? 'ApiTimeoutException: $message' : 'ApiTimeoutException';
}

/// HTTP error with status code (non-403 4xx / 5xx not mapped elsewhere).
final class ServerException extends ProxmoxException {
  const ServerException(this.statusCode, {this.message});

  final int statusCode;
  final String? message;

  @override
  String toString() =>
      'ServerException: HTTP $statusCode${message != null ? ' ($message)' : ''}';
}

/// Insufficient permissions (HTTP 403).
final class PermissionException extends ProxmoxException {
  const PermissionException([this.message]);

  final String? message;

  @override
  String toString() =>
      message != null ? 'PermissionException: $message' : 'PermissionException';
}
