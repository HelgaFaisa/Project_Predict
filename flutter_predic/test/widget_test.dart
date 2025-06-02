import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_predic/logindokter/login.dart'; // Ganti juga jika perlu
import 'package:flutter_predic/main.dart';

void main() {
  testWidgets('Login success navigates to HomePage', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(MyApp());

    // Temukan field username dan password
    final usernameField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    // Masukkan input
    await tester.enterText(usernameField, 'admin');
    await tester.enterText(passwordField, '1234');

    // Tap tombol login
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verifikasi: Pindah ke halaman HomePage
    expect(find.text('Selamat datang di Menu Utama!'), findsOneWidget);
  });

  testWidgets('Login failed shows error message', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final usernameField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    await tester.enterText(usernameField, 'user');
    await tester.enterText(passwordField, 'wrongpass');

    await tester.tap(loginButton);
    await tester.pump(); // Tunggu setState

    // Cek error text muncul
    expect(find.text('Username atau Password salah!'), findsOneWidget);
  });
}
