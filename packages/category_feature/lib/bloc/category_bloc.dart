import 'dart:async';

import 'package:category_feature/data/category_data.dart';
import 'package:category_feature/data/default_categories_data.dart';
import 'package:core/utils/try_catcher/bloc_try_catcher_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_bloc_event.dart';
part 'category_bloc_state.dart';
part 'category_bloc_state_data.dart';

final class CategoryBloc extends Bloc<CategoryBlocEvent, CategoryBlocState> with BlocTryCatcherMixin {
  CategoryBloc() : super(CategoryBlocState.initial(data: CategoryBlocStateData.initial())) {
    on<CategoryBlocEvent>(
      (event, emit) => switch (event) {
        final CreateCategoryEvent e => _onCreateCategoryEvent(e, emit),
      },
    );
  }

  FutureOr<void> _onCreateCategoryEvent(
    final CreateCategoryEvent event,
    final Emitter<CategoryBlocState> emit,
  ) async {}

  @override
  void emitError(final Emitter<CategoryBlocState> emit, final TryCatchError error) {
    // TODO: add localized error message
    emit(
      ErrorCategoryState(
        data: state.data,
        message: error.message ?? 'An unknown error occurred',
      ),
    );
  }
}
