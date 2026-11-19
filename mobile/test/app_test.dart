import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vicecodes/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('offline database contains only documented direction sequences', () async {
    final raw = await rootBundle.loadString('assets/cheats.json');
    final obj = jsonDecode(raw) as Map<String, dynamic>;
    final cheats = obj['cheats'] as List<dynamic>;
    expect(cheats.length, 19);
    final ids = <String>{};
    for (final row in cheats) {
      final record = row as Map<String, dynamic>;
      expect(ids.add(record['id'] as String), isTrue);
      expect((record['title'] as String).isNotEmpty, isTrue);
      expect((record['unlock'] as String).isNotEmpty, isTrue);
      expect(RegExp(r'^[UDLR]( [UDLR])+$').hasMatch(record['sequence'] as String), isTrue);
    }
  });

  testWidgets('German native app displays searchable cheat list', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ViceCodes());
    await tester.pumpAndSettle();
    expect(find.text('VICE CODES'), findsOneWidget);
    expect(find.text('CHEAT-DATENBANK'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Munition');
    await tester.pumpAndSettle();
    expect(find.text('Munition auffüllen'), findsOneWidget);
  });
}
