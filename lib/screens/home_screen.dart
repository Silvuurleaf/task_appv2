import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/todos/todos_bloc.dart';
import '../models/todos_model.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task App'),
        actions: [
          IconButton(onPressed: () {
            context.push('/createTasks');
          }, icon: const Icon(Icons.add)),
        ],
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {

          if(state is TodosLoading){
            return const CircularProgressIndicator();
          }
          if(state is TodosLoaded){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.todos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ValueKey(state.todos[index]!.id),
                            background: Container(
                              color: const Color(0xFFACDDD7),
                            ),

                            onDismissed: (DismissDirection direction){
                              if(direction == DismissDirection.startToEnd){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Task Completed"))
                                );
                              }

                              context.read<TodosBloc>().add(
                                DeleteTodo(todo: state.todos[index]!),
                              );
                            },

                            child: _todoCard(context, state.todos[index]!)
                        );
                      })
                ],
              ),
            );
          }
          else {
            return const Text('something wrong');
          }
        },
      ),
    );
  }


  Card _todoCard(BuildContext context, Todo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(

            onTap:(){
              //fire an edit toDo event
              context.read<TodosBloc>().add(EditTodo(todo: todo));
              int? editingTaskId = todo.id;
              print("The editing task id: $editingTaskId");
              context.push('/editTask/$editingTaskId');

            } ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //#${todo.id}:
                Text(todo.title),
                Row(
                  children: [
                    IconButton(onPressed: () {
                      context.read<TodosBloc>().add(
                        DeleteTodo(todo: todo),
                      );
                    }, icon: const Icon(Icons.cancel)),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

}
