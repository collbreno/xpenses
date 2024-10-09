import 'package:equatable/equatable.dart';

class AsyncData<T> extends Equatable {
  final T? data;
  final Object? error;
  final bool isLoading;

  const AsyncData.loading()
      : isLoading = true,
        error = null,
        data = null;
  const AsyncData.withData(T result)
      : isLoading = false,
        data = result,
        error = null;
  const AsyncData.withError(this.error)
      : isLoading = false,
        data = null;

  const AsyncData.nothing()
      : isLoading = false,
        data = null,
        error = null;

  bool get hasError => error != null;
  bool get hasData => data != null;
  bool get hasNothing => !isLoading && !hasError && !hasData;

  @override
  List<Object?> get props => [data, error, isLoading];
}
