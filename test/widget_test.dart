import 'package:flutter_test/flutter_test.dart';
import 'package:quakevault/app.dart'; // FIXED: import app.dart instead of main.dart

void main() {
  testWidgets('QuakeVault app starts up', (WidgetTester tester) async {
    await tester.pumpWidget(const QuakeVaultApp());
    expect(find.text('QuakeVault'), findsOneWidget);
  });
}