import 'package:flutter/material.dart';
import 'package:xpenses/pages/home_page.dart';
import 'package:xpenses/pages/new_expense_page.dart';
import 'package:xpenses/pages/theme_visualizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xff121212),
      onBackground: Colors.white,
      primary: Color(0xFF236855),
      onPrimary: Colors.white,
      secondary: Color(0xFF90B77E),
      onSecondary: Colors.black,
      tertiary: Color(0xFF1B2E15),
      onTertiary: Colors.white,
      surface: Color(0xff121212),
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    );

    return MaterialApp(
      title: 'Xpenses',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        ),
      ),
      home: const ThemeVisualizer(),
    );
  }
}
