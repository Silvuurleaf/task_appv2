import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todos/todos_bloc.dart';
import '../models/todos_model.dart';
import '../widgets/toggle_button.dart';

class AddTodoScreen extends StatefulWidget {

  AddTodoScreen({Key? key}) : super(key: key);


  @override
  State<AddTodoScreen> createState() => _AddTodoScreen();
}

class _AddTodoScreen extends State<AddTodoScreen> {

  final controllerTask = TextEditingController();
  String taskTitle = '';

  final controllerDescription = TextEditingController();
  String description ='';

  bool remoteTask = false;

  @override
  void initState() {
    super.initState();

    controllerTask.addListener(() => setState(() {}));
    controllerDescription.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {

    int idGenerator() {
      final now = DateTime.now();
      return now.microsecondsSinceEpoch;
    }

    getSaveLocation(bool isRemote) {
      setState(() {
        remoteTask = isRemote;
        print("SET STATE CALLED VALUE OF ISREMOTE: $isRemote");
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BloC Pattern: Add a To Do'),
      ),
      body: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          // TODO: implement listener
          if(state is TodosLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('added'),
                )
            );
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        _inputField('Title', controllerTask),
                        _inputField('Description', controllerDescription),

                        ToggleButton(callbackFunction: getSaveLocation,),

                        FloatingActionButton.extended(
                          onPressed: () {
                            //creates ToDo item

                            var todo = Todo(
                              id: idGenerator(),
                              title: controllerTask.value.text,
                              description: controllerDescription.value.text,
                              isRemote: remoteTask,
                            );

                            print("the value of is remote");
                            print(todo.isRemote);

                            //get Todos bloc add new item
                            context.read<TodosBloc>().add(AddTodo(todo: todo));


                            Navigator.pop(context);
                          },
                          label: const Text('add task',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Column(
                  children: [

                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column()
                      ),
                    ),
                  ]
                ),
              ]
            )
          ),
        ),
      ),
    );
  }

  Column _inputField(String field,
      TextEditingController controller,) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          child: TextFormField(

            decoration: InputDecoration.collapsed(
                hintText: field
            ),
            controller: controller,

          ),
        ),
      ],
    );
  }

}