import 'package:flutter/material.dart';
import 'package:xpenses/utils/build_context_utils.dart';

class ErrorDialog extends StatelessWidget {
  final Object error;
  const ErrorDialog(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ops!'),
      content: Row(
        children: [
          const Icon(Icons.warning_rounded, size: 36),
          const SizedBox(width: 24),
          Text(error.toString()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.dismissDialog(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

Future<void> showErrorDialog(BuildContext context, {required Object error}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ErrorDialog(error),
  );
}
