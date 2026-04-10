import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Maps typed API errors to localized user-visible messages.
String proxmoxExceptionMessage(Object error, AppLocalizations l10n) {
  if (error is ProxmoxException) {
    return switch (error) {
      AuthException() => l10n.errorProxmoxAuth,
      NetworkException() => l10n.errorProxmoxNetwork,
      ApiTimeoutException() => l10n.errorProxmoxTimeout,
      PermissionException() => l10n.errorProxmoxPermission,
      final ServerException e => l10n.errorProxmoxServer(e.statusCode),
    };
  }
  return l10n.errorProxmoxUnknown;
}
