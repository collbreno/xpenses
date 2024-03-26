import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push('/tags');
              },
              child: const Text('Tags'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.push('/expenses');
              },
              child: const Text('Gastos'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.push('/new_tag');
              },
              child: const Text('Nova Tag'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.push('/new_expense');
              },
              child: const Text('Novo Gasto'),
            ),
          ],
        ),
      ),
    );
  }
}
