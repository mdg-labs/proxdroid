/// Proxmox REST paths relative to the API base `https://host:port/api2/json`.
///
/// Use with Dio [BaseOptions.baseUrl] ending in `/api2/json` so requests use
/// paths like [version] → `GET /api2/json/version`.
abstract final class ApiEndpoints {
  /// `GET /version` — cluster / daemon version (connection test).
  static const String version = '/version';

  /// `POST /access/ticket` — username/password login (form body).
  static const String accessTicket = '/access/ticket';
}
