import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('German search returns only matching offline cheat records', () async {
    final raw = await rootBundle.loadString('assets/cheats.json');
    final obj = jsonDecode(raw) as Map<String, dynamic>;
    final cheats = obj['cheats'] as List<dynamic>;
    final matches = cheats.where((item) {
      final row = item as Map<String, dynamic>;
      return (row['title'] as String).toLowerCase().contains('munition');
    }).toList();
    expect(matches.length, 2);
    expect(matches.every((item) => (item as Map<String, dynamic>)['sequence'] != ''), isTrue);
  });
}
