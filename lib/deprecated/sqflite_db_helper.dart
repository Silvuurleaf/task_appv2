import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskapp_mvvm/models/todos_model.dart';


class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todo.db');
    
    return await openDatabase(path, version: 1, onCreate: _onCreate,);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todo_list(
      id INTEGER PRIMARY KEY,
      name TEXT
    )
    ''');
  }

  Future<List<Todo>> getTodos() async {
    Database db = await instance.database;
    var todos = await db.query('todo_list', orderBy: 'name');



    //List todoList = todos.isNotEmpty
    //  ? todos.map((c) => Todo.fromMap(c)).toList()
    //  : [];

    List<Todo> todoList = [];

    return todoList;
  }
}