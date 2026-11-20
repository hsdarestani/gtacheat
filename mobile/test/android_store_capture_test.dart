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
    for (var n = 0; n < 70 && find.text(const int.fromEnvironment('VICE_CAPTURE_TAB', defaultValue: 0) == 2 ? 'CHEATS AKTIVIEREN' : (const int.fromEnvironment('VICE_CAPTURE_TAB', defaultValue: 0) == 3 ? 'ÜBER DIE APP' : 'CHEAT-DATENBANK')).evaluate().isEmpty; n++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 70)));
      await tester.pump(const Duration(milliseconds: 40));
    }
    // Wait for actual offline data before rendering the chosen screenshot.

    const tab = int.fromEnvironment('VICE_CAPTURE_TAB', defaultValue: 0);
    final names = <int, String>{
      0: '01-cheat-datenbank',
      2: '02-anleitung',
      3: '03-ueber-die-app',
    };
    final expected = <int, String>{
      0: 'CHEAT-DATENBANK',
      2: 'CHEATS AKTIVIEREN',
      3: 'ÜBER DIE APP',
    };
    expect(names.containsKey(tab), isTrue);
    expect(find.text(expected[tab]!), findsOneWidget);
    final boundary = imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    expect(boundary, isNotNull);
    final image = await boundary!.toImage(pixelRatio: 3);
    expect(image.width, 1080);
    expect(image.height, 2400);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    expect(bytes, isNotNull);
    final dir = Directory('store/screenshots/android')..createSync(recursive: true);
    final file = File(dir.path + '/' + names[tab]! + '.png');
    file.writeAsBytesSync(bytes!.buffer.asUint8List());
    expect(file.lengthSync(), greaterThan(20000));
    image.dispose();
  });
}
