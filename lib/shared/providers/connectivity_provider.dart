import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Current and changing radio connectivity from [connectivity_plus].
///
/// Emits the result of [Connectivity.checkConnectivity] first, then every event
/// from [Connectivity.onConnectivityChanged]. Values are **never empty** (see
/// plugin docs); offline is `[ConnectivityResult.none]`.
///
/// Phase 6 will use this for the persistent offline banner
/// ([ProxDroid_Roadmap.md] §6.1).
@riverpod
Stream<List<ConnectivityResult>> connectivity(ConnectivityRef ref) async* {
  final plugin = Connectivity();
  yield await plugin.checkConnectivity();
  yield* plugin.onConnectivityChanged;
}
