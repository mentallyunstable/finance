part of 'category_bloc.dart';

sealed class CategoryBlocEvent {
  const CategoryBlocEvent();

  const factory CategoryBlocEvent.create({required final String name}) = CreateCategoryEvent;
}

final class CreateCategoryEvent extends CategoryBlocEvent {
  final String name;

  const CreateCategoryEvent({required this.name});
}
