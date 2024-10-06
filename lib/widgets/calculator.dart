import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:money2/money2.dart';
import 'package:xpenses/constants.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  static const _BACK = 'back';
  static const _OPEN_PARENTHESIS = '(';
  static const _CLOSE_PARENTHESIS = ')';
  static const _CLEAR = 'C';
  static const _DIVISION = '/';
  static const _TIMES = '*';
  static const _MINUS = '-';
  static const _PLUS = '+';
  static const _EVAL = '=';
  static const _COMMA = '.';

  final _buttons = [
    _CLEAR,
    _OPEN_PARENTHESIS,
    _CLOSE_PARENTHESIS,
    _DIVISION,
    //
    '7',
    '8',
    '9',
    _TIMES,
    //
    '4',
    '5',
    '6',
    _MINUS,
    //
    '1',
    '2',
    '3',
    _PLUS,
    //
    _COMMA,
    '0',
    _BACK,
    _EVAL,
  ];

  final operations = [];

  late String _result;
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    _result = '';
    _hasError = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDisplay(),
          GridView.builder(
            shrinkWrap: true,
            itemCount: _buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) => _buildButton(_buttons[index]),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _evaluate();
                    });
                    if (!_hasError) {
                      Navigator.pop(
                        context,
                        Money.fromNumWithCurrency(
                            double.parse(_result), Constants.currency),
                      );
                    } else if (_result.isEmpty) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Ok'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        _result,
        style: TextStyle(
          fontSize: 18,
          color: _hasError ? Theme.of(context).colorScheme.error : null,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildButton(String btn) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: _getButtonColor(btn),
      child: InkWell(
        onTap: () => _btnPressed(btn),
        child: Center(
          child: Text(
            btn,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _btnPressed(String btn) {
    setState(() {
      _hasError = false;
      if (btn == _CLEAR) {
        _result = '';
      } else if (btn == _BACK) {
        _result = _result.substring(0, _result.length - 1);
      } else if (btn == _EVAL) {
        _evaluate();
      } else {
        _result += btn;
      }
    });
  }

  void _evaluate() {
    try {
      _result = Parser()
          .parse(_result)
          .evaluate(EvaluationType.REAL, ContextModel())
          .toString();
    } catch (e) {
      _hasError = true;
    }
  }

  Color _getButtonColor(String btn) {
    if ([
      _CLEAR,
      _OPEN_PARENTHESIS,
      _CLOSE_PARENTHESIS,
      _DIVISION,
      _TIMES,
      _MINUS,
      _PLUS,
      _EVAL
    ].contains(btn)) {
      return Theme.of(context).colorScheme.tertiary;
    } else {
      return Theme.of(context).colorScheme.secondary;
    }
  }
}

Future<Money?> showCalculator(BuildContext context) {
  return showDialog<Money>(
    context: context,
    builder: (context) {
      return const Calculator();
    },
  );
}
