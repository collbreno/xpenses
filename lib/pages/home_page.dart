import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:xpenses/bloc/month_total_cubit.dart';
import 'package:xpenses/database/database.dart';
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
              const DrawerHeader(
                child: Text('Header'),
              ),
              if (kDebugMode) _buildDatabaseDebugButton(),
              ListTile(
                onTap: () {
                  context.pop();
                  const TagListRoute().push(context);
                },
                title: const Text('Gerenciar Tags'),
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

  Widget _buildDatabaseDebugButton() {
    return Builder(builder: (context) {
      return ListTile(
        textColor: Colors.red,
        iconColor: Colors.red,
        leading: Icon(MdiIcons.database),
        title: const Text('Database'),
        onTap: () {
          final db = context.read<IAppDatabase>() as AppDatabase;
          context.pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DriftDbViewer(db),
            ),
          );
        },
      );
    });
  }
}
