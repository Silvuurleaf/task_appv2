import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskapp_mvvm/database/database_helper.dart';
import 'package:taskapp_mvvm/firebaseAPI/remote_data_source.dart';
import 'package:taskapp_mvvm/screens/add_todo_screen.dart';
import 'package:taskapp_mvvm/screens/edit_todo_screen.dart';
import 'package:taskapp_mvvm/screens/home_screen.dart';
import 'package:taskapp_mvvm/models/todos_model.dart';

import 'package:taskapp_mvvm/theme/theme_const.dart';

import 'bloc/todos/todos_bloc.dart';
import 'bloc/todos_filter/todos_filter_bloc.dart';
import 'data_layer/todo_repository.dart';



final _router = GoRouter(
    initialLocation: '/',
    routes:[

      GoRoute(path:'/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: "editTask/:taskId",
            name: "editTasks",
            builder: (BuildContext context, GoRouterState state) {
              String? id = state.params['taskId'];
              return EditTodoScreen(taskId: id);
            },
          )
        ],
      ),

      //create task path
      GoRoute(
        path:'/createTasks',
        builder: (context, state)=> AddTodoScreen(),
      )
    ]
);


late Box todoListBox;

final DatabaseHelper sqliteDB = DatabaseHelper();
final RemoteDataSource firebase = RemoteDataSource();

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //initialize database
  await sqliteDB.init();

  final todosRepository = TodoRepository(
      localSqlLiteRepository: sqliteDB,
      firebaseRepository: firebase
  );

  runApp(MyApp(
    todosRepository: todosRepository,
  ));
}

class MyApp extends StatelessWidget {

  final TodoRepository todosRepository;

  const MyApp({
    required this.todosRepository,
    super.key
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TodosBloc(todosRepository)..add(const LoadTodos())
          ),
          BlocProvider(create: (context) => TodosFilterBloc(
              todosBloc: BlocProvider.of<TodosBloc>(context),
            ),
          )
        ],
          child: MaterialApp.router(
            title: 'task-app-v2-bloc-repo',
            theme: basic,
            routerConfig: _router,
          ),
      );
  }
}

