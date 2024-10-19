import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Aguarde'),
      content: Row(
        children: [
          SizedBox.square(
            dimension: 36,
            child: CircularProgressIndicator(),
          ),
          SizedBox(width: 24),
          Text('Carregando...'),
        ],
      ),
    );
  }
}

Future<void> showLoadingDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const LoadingDialog(),
  );
}
