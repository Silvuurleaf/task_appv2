import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/todos/todos_bloc.dart';
import '../models/todos_model.dart';

class EditTodoScreen extends StatefulWidget {

  var taskId;
  EditTodoScreen({Key? key, this.taskId}) : super(key: key);

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();

}

class _EditTodoScreenState extends State<EditTodoScreen> {

  int idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerId = TextEditingController();
    TextEditingController controllerTask = TextEditingController();
    TextEditingController controllerDescription = TextEditingController();

    var task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BloC Pattern: Editing a todo'),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {

          if(state is TodosLoading){
            return const CircularProgressIndicator();
          }
          if(state is TodosLoaded){

            int taskId = int.parse(widget.taskId);
            print("taskId  $taskId");

            task = state.todos[0];

            String taskIdString = widget.taskId;
            String taskTitle = task.title;
            String taskDesc = task.description;
            bool isRemote = task.isRemote;

            print("task title: $taskTitle");
            print("task desc: $taskDesc");

            controllerId.text = taskIdString;
            controllerTask.text = taskTitle;
            controllerDescription.text = taskDesc;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //_inputField('ID', controllerId),
                    _inputField('Task', controllerTask),
                    _inputField('Description', controllerDescription),
                    ElevatedButton(
                      onPressed: () {

                        var todo;

                        if(isRemote){
                          todo = Todo(
                            id: idGenerator(),
                            title: controllerTask.value.text,
                            description: controllerDescription.value.text,
                            isRemote: isRemote,
                            remoteId: taskIdString,
                          );
                        }
                        else{
                          todo = Todo(
                            id: int.parse(taskIdString),
                            title: controllerTask.value.text,
                            description: controllerDescription.value.text,
                            isRemote: isRemote,
                            remoteId: taskIdString,
                          );
                        }

                        context.read<TodosBloc>().add(UpdateTodo(todo: todo));
                        //context.read<TodosBloc>().add(const LoadTodos());
                        context.push('/');
                        //TODO when I push not loading all the tasks
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme
                            .of(context)
                            .primaryColor,
                      ),
                      child: const Text('Submit Changes'),
                    ),
                  ],
                ),
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

  Column _inputField(String field,
      TextEditingController controller,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$field:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          child: TextFormField(
            controller: controller,
          ),
        ),
      ],
    );
  }

}