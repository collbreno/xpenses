import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpenses/bloc/entity_list_cubit.dart';
import 'package:xpenses/bloc/installments_cubit.dart';
import 'package:xpenses/database/database.dart';
import 'package:xpenses/models/tag_model.dart';
import 'package:xpenses/pages/expense_form_page.dart';
import 'package:xpenses/pages/home_page.dart';
import 'package:xpenses/pages/installments_page.dart';
import 'package:xpenses/pages/tag_form_page.dart';
import 'package:xpenses/pages/tag_list_page.dart';
import 'package:xpenses/route_params/expense_form_route_params.dart';
import 'package:xpenses/route_params/tag_form_route_params.dart';

part 'go_router_builder.g.dart';

@TypedGoRoute<HomeRoute>(path: '/', routes: [
  TypedGoRoute<TagFormRoute>(path: 'tag_form'),
  TypedGoRoute<ExpenseFormRoute>(path: 'expense_form'),
  TypedGoRoute<TagListRoute>(path: 'tag_list'),
  TypedGoRoute<InstallmentsRoute>(path: 'installments'),
])
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

@immutable
class TagFormRoute extends GoRouteData {
  final TagFormRouteParams $extra;
  const TagFormRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TagFormPage(
      onSaved: $extra.onSaved,
      tag: $extra.tag,
    );
  }
}

@immutable
class ExpenseFormRoute extends GoRouteData {
  final ExpenseFormRouteParams $extra;
  const ExpenseFormRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<EntityListCubit<Tag>>(
      create: (context) => EntityListCubit<Tag>(
        context.read<AppDatabase>().getAllTags,
      )..load(),
      child: ExpenseFormPage(
        onSaved: $extra.onSaved,
        expense: $extra.expense,
      ),
    );
  }
}

@immutable
class TagListRoute extends GoRouteData {
  const TagListRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<EntityListCubit<Tag>>(
      create: (context) => EntityListCubit<Tag>(
        () => context.read<AppDatabase>().getAllTags(),
      )..load(),
      child: const TagListPage(),
    );
  }
}

@immutable
class InstallmentsRoute extends GoRouteData {
  const InstallmentsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<InstallmentsCubit>(
      create: (context) => InstallmentsCubit(
        context.read<AppDatabase>(),
      )..loadRange(),
      child: const InstallmentsPage(),
    );
  }
}
