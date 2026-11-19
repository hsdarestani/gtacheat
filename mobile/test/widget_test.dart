import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vicecodes/main.dart';

void main() {
  testWidgets('Vice Codes launches with the German title', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ViceCodes());
    await tester.pumpAndSettle();
    expect(find.text('VICE CODES'), findsOneWidget);
  });
}
