import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final Object error;

  const AppErrorWidget(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning),
            const SizedBox(height: 16),
            Text(error.toString()),
          ],
        ),
      ),
    );
  }
}
