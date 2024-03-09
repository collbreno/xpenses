import 'package:equatable/equatable.dart';

class AsyncData<T> extends Equatable {
  final Object? error;
  final T? data;

  bool get isLoading => error == null && data == null;
  bool get hasData => data != null;
  bool get hasError => error != null;

  const AsyncData.withError(this.error) : data = null;
  const AsyncData.withData(this.data) : error = null;
  const AsyncData.loading()
      : data = null,
        error = null;

  @override
  List<Object?> get props => [error, data];
}
