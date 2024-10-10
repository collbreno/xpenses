import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpenses/bloc/month_total_cubit.dart';
import 'package:xpenses/database/i_database.dart';
import 'package:xpenses/go_router_builder.dart';
import 'package:xpenses/route_params/expense_form_route_params.dart';
import 'package:xpenses/widgets/cards/month_total_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonthTotalCubit(
        context.read<IAppDatabase>(),
      )..load(),
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Header'),
              ),
              ListTile(
                onTap: () {
                  context.pop();
                  TagListRoute().push(context);
                },
                title: Text('Gerenciar Tags'),
                leading: const Icon(Icons.label),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: ListView(
          children: [
            _buildTotalMonthCard(),
          ],
        ),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  Widget _buildTotalMonthCard() {
    return BlocBuilder<MonthTotalCubit, MonthTotalState>(
      builder: (context, state) {
        return MonthTotalCard(state);
      },
    );
  }

  Widget _buildFAB() {
    return Builder(builder: (context) {
      return FloatingActionButton.extended(
        onPressed: () {
          ExpenseFormRoute(ExpenseFormRouteParams(
            expense: null,
            onSaved: () {},
          )).push(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Gasto'),
      );
    });
  }
}
