import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:xpenses/bloc/entity_form_cubit.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/bloc/expense_form_cubit.dart';
import 'package:xpenses/bloc/tag_form_cubit.dart';
import 'package:xpenses/entities/expense_entity.dart';
import 'package:xpenses/entities/tag_entity.dart';
import 'package:xpenses/object_box.dart';
import 'package:xpenses/pages/expenses_page.dart';
import 'package:xpenses/pages/home_page.dart';
import 'package:xpenses/pages/expense_form_page.dart';
import 'package:xpenses/pages/tag_form_page.dart';
import 'package:xpenses/pages/tags_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final objectBox = await ObjectBox.create();
  runApp(MyApp(objectBox));
}

class MyApp extends StatelessWidget {
  final ObjectBox objectBox;
  MyApp(this.objectBox, {super.key});

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/new_tag',
        builder: (context, state) => BlocProvider<EntityFormCubit<Tag>>(
          create: (context) {
            return TagFormCubit(context.read<Box<Tag>>().putAsync);
          },
          child: const NewTagPage(),
        ),
      ),
      GoRoute(
        path: '/new_expense',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => EntityListCubit<Tag>(
                  context.read<Box<Tag>>().getAllAsync,
                ),
              ),
              BlocProvider<EntityFormCubit<Expense>>(
                create: (context) => ExpenseFormCubit(
                  context.read<Box<Expense>>().putAsync,
                ),
              ),
            ],
            child: const NewExpensePage(),
          );
        },
      ),
      GoRoute(
        path: '/tags',
        builder: (context, state) => const TagsPage(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesPage(),
      ),
    ],
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
        Provider<Box<Tag>>(
          create: (context) => objectBox.store.box<Tag>(),
        ),
        Provider<Box<Expense>>(
          create: (context) => objectBox.store.box<Expense>(),
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
