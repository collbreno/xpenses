import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpenses/utils/async_data.dart';

class EntityListCubit<T> extends Cubit<AsyncData<List<T>>> {
  Future<List<T>> Function() method;
  EntityListCubit(this.method) : super(const AsyncData.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      final result = await method.call();
      emit(AsyncData.withData(result));
    } catch (e) {
      emit(AsyncData.withError(e));
    }
  }
}
