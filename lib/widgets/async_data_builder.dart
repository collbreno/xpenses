import 'package:flutter/material.dart';
import 'package:xpenses/widgets/app_error_widget.dart';
import 'package:xpenses/utils/async_data.dart';

class AsyncDataBuilder<T> extends StatelessWidget {
  final AsyncData<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? nothingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const AsyncDataBuilder({
    super.key,
    required this.state,
    required this.builder,
    this.loadingBuilder,
    this.nothingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return loadingBuilder != null
          ? loadingBuilder!(context)
          : const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
    } else if (state.hasError) {
      return errorBuilder != null
          ? errorBuilder!(context, state.error!)
          : AppErrorWidget(state.error!);
    } else if (state.hasData) {
      // ignore: null_check_on_nullable_type_parameter
      return builder(context, state.data!);
    } else {
      if (nothingBuilder != null) {
        return nothingBuilder!(context);
      } else {
        throw AssertionError('Cubit did not started loading');
      }
    }
  }
}
