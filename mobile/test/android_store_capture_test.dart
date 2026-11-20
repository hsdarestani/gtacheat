import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vicecodes/main.dart';

/// Direct pixels of the actual Flutter app using an Android-sized viewport.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('capture three German Android-sized Flutter screens', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    SharedPreferences.setMockInitialValues({});
    final imageKey = GlobalKey();
    await tester.pumpWidget(RepaintBoundary(key: imageKey, child: const ViceCodes()));
    for (var n = 0; n < 70 && find.text('CHEAT-DATENBANK').evaluate().isEmpty; n++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 70)));
      await tester.pump(const Duration(milliseconds: 40));
    }
    expect(find.text('CHEAT-DATENBANK'), findsOneWidget,
      reason: 'Screenshots must show loaded UI, not a loading indicator.');

    Future<void> capture(int number, String suffix) async {
      await tester.pump();
      final boundary = imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      expect(boundary, isNotNull);
      final image = await boundary!.toImage(pixelRatio: 3);
      expect(image.width, 1080);
      expect(image.height, 2400);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      expect(bytes, isNotNull);
      final location = Directory('store/screenshots/android')..createSync(recursive: true);
      final filename = number.toString().padLeft(2, '0') + '-' + suffix + '.png';
      final file = File(location.path + '/' + filename);
      file.writeAsBytesSync(bytes!.buffer.asUint8List());
      expect(file.lengthSync(), greaterThan(20000));
      image.dispose();
    }

    await capture(1, 'cheat-datenbank');
    await tester.tap(find.text('HILFE'));
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('CHEATS AKTIVIEREN'), findsOneWidget);
    await capture(2, 'anleitung');
    await tester.tap(find.text('INFO'));
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('ÜBER DIE APP'), findsOneWidget);
    await capture(3, 'ueber-die-app');
  });
}
