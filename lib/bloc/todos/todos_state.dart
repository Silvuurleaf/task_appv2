part of 'todos_bloc.dart';

@immutable
abstract class TodosState {}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Todo?> todos;

  TodosLoaded({
    this.todos = const <Todo?>[],
  });

  @override
  List<Object> get props => [todos];
}

class TodosError extends TodosState {}
