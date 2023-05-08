
import 'package:flutter/material.dart';
import 'package:taskapp_mvvm/database/database_helper.dart';
import '../firebaseAPI/remote_data_source.dart';
import 'i_repository.dart';

class TodoRepository<Todo> extends IRepository {

  //final ITodoRepository<Todo> hiveLocalStorage;
  final DatabaseHelper localSqlLiteRepository;
  final RemoteDataSource firebaseRepository;

  TodoRepository({
    required this.localSqlLiteRepository,
    required this.firebaseRepository,
  });

  @override
  Future add(todo) async {

    print("ADDING TODO");
    var isRemote = todo.isRemote;
    print("VALUE OF ISREMOTE: $isRemote");

    if(todo.isRemote){
      try{
        await firebaseRepository.add(todo);
      }
      on Exception catch (e){
        print(e);
      }
    }
    else {
      await localSqlLiteRepository.add(todo);
    }

    return;
  }

  @override
  Future<void> delete(todo) async {
    await localSqlLiteRepository.delete(todo.id);
  }

  @override
  Future<List> getTodos() async {

    var todos = await localSqlLiteRepository.getTodos();
    try {
      var remoteTodos = await firebaseRepository.getTodos();

      todos.addAll(remoteTodos);

      todos.cast<Todo?>();
      return todos;

    } on Exception catch (e) {
      print(e);
    }
    todos.cast<Todo?>();

    return todos;

  }

  @override
  Future<void> update(todo) async {
    await localSqlLiteRepository.update(todo);
  }


  //local data

  //TODO add a networking class and remote data source
  //required this.networkInfo,
  //required this.remoteDataSource,

  //final firebase remoteDataSource;
  //final NetworkInfo networkInfo;

}