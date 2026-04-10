import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:proxdroid/app/app.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/app_settings_repository.dart';
import 'package:proxdroid/core/storage/secure_storage_backend.dart';
import 'package:proxdroid/core/storage/server_adapter.dart';
import 'package:proxdroid/core/storage/server_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(ServerAdapter().typeId)) {
    Hive.registerAdapter(ServerAdapter());
  }

  final serverBox = await Hive.openBox<Server>(kServersHiveBoxName);
  final settingsBox = await Hive.openBox<String>(kSettingsHiveBoxName);
  final serverStorage = ServerStorage(
    box: serverBox,
    secureStorage: FlutterSecureStorageAdapter(const FlutterSecureStorage()),
  );
  final appSettingsRepository = AppSettingsRepository(box: settingsBox);

  runApp(
    ProviderScope(
      overrides: [
        serverStorageProvider.overrideWithValue(serverStorage),
        appSettingsRepositoryProvider.overrideWithValue(appSettingsRepository),
      ],
      child: const ProxDroidApp(),
    ),
  );
}
