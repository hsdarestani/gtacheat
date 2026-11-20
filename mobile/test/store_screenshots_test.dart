import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vicecodes/main.dart';

/// Genuine Flutter-rendered store screenshots, never marketing mockups.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final viewport in [
    (name: 'ios', size: const Size(1290, 2796), ratio: 3.0),
    (name: 'android', size: const Size(1080, 2400), ratio: 3.0),
  ]) {
    testWidgets('${viewport.name} screenshots depict real UI', (tester) async {
      tester.view.physicalSize = viewport.size;
      tester.view.devicePixelRatio = viewport.ratio;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final key = GlobalKey();
      await tester.pumpWidget(RepaintBoundary(key: key, child: const ViceCodes()));
      await tester.pumpAndSettle();

      for (var i = 0; i < 30 && find.text('CHEAT-DATENBANK').evaluate().isEmpty; i++) {
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        });
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text('CHEAT-DATENBANK'), findsOneWidget,
          reason: 'A loading spinner is not a valid store screenshot.');

      Future<void> capture(String suffix) async {
        await tester.pumpAndSettle();
        final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        expect(boundary, isNotNull);
        final img = await boundary!.toImage(pixelRatio: viewport.ratio);
        final png = await img.toByteData(format: ui.ImageByteFormat.png);
        expect(png, isNotNull);
        final bytes = png!.buffer.asUint8List();
        final dir = Directory('store/screenshots/${viewport.name}');
        dir.createSync(recursive: true);
        final file = File('${dir.path}/$suffix.png');
        file.writeAsBytesSync(bytes);
        expect(bytes.length, greaterThan(20000));
        expect(img.width, viewport.size.width.round());
        expect(img.height, viewport.size.height.round());
        img.dispose();
      }

      await capture('01-cheat-datenbank');

      await tester.tap(find.text('250.000 \$').first);
      await tester.pumpAndSettle();
      expect(find.text('TASTENKOMBINATION'), findsOneWidget);
      await capture('02-code-details');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await tester.tap(find.text('HILFE'));
      await tester.pumpAndSettle();
      expect(find.text('CHEATS AKTIVIEREN'), findsOneWidget);
      await capture('03-anleitung');
    });
  }
}
