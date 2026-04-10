import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/app/app.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/app_settings_repository.dart';
import 'package:proxdroid/core/storage/server_adapter.dart';
import 'package:proxdroid/core/storage/server_storage.dart';

import 'support/in_memory_secure_storage.dart';

void main() {
  late Directory tempDir;
  late Box<Server> box;
  late Box<String> settingsBox;
  late ServerStorage serverStorage;
  late AppSettingsRepository appSettingsRepository;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final secure = InMemorySecureStorage();
    tempDir = Directory.systemTemp.createTempSync('proxdroid_widget_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(ServerAdapter().typeId)) {
      Hive.registerAdapter(ServerAdapter());
    }
    final hash = tempDir.path.hashCode.abs();
    final boxName = 'servers_$hash';
    box = await Hive.openBox<Server>(boxName);
    settingsBox = await Hive.openBox<String>('settings_$hash');
    serverStorage = ServerStorage(box: box, secureStorage: secure);
    appSettingsRepository = AppSettingsRepository(box: settingsBox);
  });

  tearDown(() async {
    final serverName = box.name;
    final settingsName = settingsBox.name;
    await box.close();
    await settingsBox.close();
    await Hive.deleteBoxFromDisk(serverName);
    await Hive.deleteBoxFromDisk(settingsName);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('ProxDroidApp loads MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          serverStorageProvider.overrideWithValue(serverStorage),
          appSettingsRepositoryProvider.overrideWithValue(
            appSettingsRepository,
          ),
        ],
        child: const ProxDroidApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
