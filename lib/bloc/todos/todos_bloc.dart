import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data_layer/todo_repository.dart';
import '../../models/todos_model.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodoEvent, TodosState> {

  TodoRepository todosRepository;

  TodosBloc(this.todosRepository) : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<EditTodo>(_onEditTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodosState> emit,) async {

    List<Todo?> allTodos = await todosRepository.getTodos() as List<Todo?>;

    emit(TodosLoaded(todos: allTodos));
  }

  Future<void> _onAddTodo(
      AddTodo event,
      Emitter<TodosState> emit,
      ) async {

    final state = this.state;
    if (state is TodosLoaded) {

      await todosRepository.add(event.todo);

      emit(TodosLoaded(todos: List.from(state.todos)..add(event.todo),),
      );
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodosState> emit,) async {
    final state = this.state;
    if (state is TodosLoaded) {

      List<Todo?> todos = (state.todos.where((todo) {
        return todo?.id != event.todo.id;
      })).toList();

      //int sqlId = event.todo.id;

      await todosRepository.delete(event.todo);

      emit(TodosLoaded(todos: todos));
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit,) async {
    final state = this.state;
    if (state is TodosLoaded) {
      //List<Todo?> todos = (state.todos.map((todo) {
      //  return todo?.id == event.todo.id ? event.todo : todo;
      //})).toList();

      List<Todo?> todos = [event.todo];

      await todosRepository.update(event.todo);


      emit(TodosLoaded(todos: todos));
    }
  }


  void _onEditTodo(EditTodo event, Emitter<TodosState> emit,) {
    final state = this.state;

    if (state is TodosLoaded) {
     //List<Todo?> todos = (state.todos.map((todo) {
     // return todo?.id == event.todo.id ? event.todo : todo;
     //})).toList();
      List<Todo?> todos = [event.todo];

      emit(TodosLoaded(todos: todos));
    }
  }


}