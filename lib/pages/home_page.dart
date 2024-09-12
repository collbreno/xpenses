import 'package:flutter/material.dart';
import 'package:xpenses/go_router_builder.dart';
import 'package:xpenses/route_params/expense_form_route_params.dart';
import 'package:xpenses/route_params/tag_form_route_params.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                const TagListRoute().push(context);
              },
              child: const Text('Tags'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                const ExpenseListRoute().push(context);
              },
              child: const Text('Gastos'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Nova Tag'),
              onPressed: () {
                TagFormRoute(TagFormRouteParams(
                  tag: null,
                  onSaved: () {},
                )).push(context);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Novo Gasto'),
              onPressed: () {
                ExpenseFormRoute(ExpenseFormRouteParams(
                  expense: null,
                  onSaved: () {},
                )).push(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
