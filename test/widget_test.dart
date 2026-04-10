import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/app/app.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/server_adapter.dart';
import 'package:proxdroid/core/storage/server_storage.dart';

import 'support/in_memory_secure_storage.dart';

void main() {
  late Directory tempDir;
  late Box<Server> box;
  late ServerStorage serverStorage;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final secure = InMemorySecureStorage();
    tempDir = Directory.systemTemp.createTempSync('proxdroid_widget_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(ServerAdapter().typeId)) {
      Hive.registerAdapter(ServerAdapter());
    }
    final boxName = 'servers_${tempDir.path.hashCode.abs()}';
    box = await Hive.openBox<Server>(boxName);
    serverStorage = ServerStorage(box: box, secureStorage: secure);
  });

  tearDown(() async {
    final name = box.name;
    await box.close();
    await Hive.deleteBoxFromDisk(name);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('ProxDroidApp loads MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [serverStorageProvider.overrideWithValue(serverStorage)],
        child: const ProxDroidApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
