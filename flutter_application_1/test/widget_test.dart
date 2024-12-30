import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_shop_kasir/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Gunakan nama kelas aplikasi utama dari main.dart
    await tester.pumpWidget(const MyApp());

    // Verifikasi UI awal
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Simulasikan tindakan pengguna
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifikasi perubahan setelah tindakan pengguna
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
