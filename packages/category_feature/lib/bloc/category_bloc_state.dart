part of 'category_bloc.dart';

sealed class CategoryBlocState {
  final CategoryBlocStateData data;

  const CategoryBlocState({required this.data});

  const factory CategoryBlocState.initial({
    required final CategoryBlocStateData data,
  }) = InitialCategoryState;
}

final class InitialCategoryState extends CategoryBlocState {
  const InitialCategoryState({required super.data});
}

final class ErrorCategoryState extends CategoryBlocState {
  final String message;

  const ErrorCategoryState({
    required super.data,
    required this.message,
  });
}
