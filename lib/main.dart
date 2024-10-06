import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xpenses/database/database.dart';
import 'package:xpenses/go_router_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  MyApp(this.database, {super.key});

  final _router = GoRouter(
    initialLocation: const HomeRoute().location,
    routes: $appRoutes,
  );

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

    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (context) => database,
        ),
      ],
      child: MaterialApp.router(
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
        routerConfig: _router,
      ),
    );
  }
}
