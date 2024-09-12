import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/utils/async_data.dart';

class EntityListCubit<T> extends Cubit<AsyncData<List<T>>> {
  Future<List<T>> Function() method;
  EntityListCubit(this.method) : super(const AsyncData.loading());

  Future<void> load() async {
    try {
      final result = await method.call();
      emit(AsyncData.withData(result));
    } catch (e) {
      emit(AsyncData.withError(e));
    }
  }
}
