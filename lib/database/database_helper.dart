
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskapp_mvvm/models/todos_model.dart';

class DatabaseHelper {


  static const _databaseName = "todos.db";
  static const _databaseVersion = 1;
  static const _dbNameReference = "todos";

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }



  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
      )
      ''');
  }

  Future<List<Todo>> getTodos() async {
    Database db = _db;
    var todos = await db.query(_dbNameReference, orderBy: 'id');
    List<Todo> todoList = todos.isNotEmpty
        ? todos.map((c) => Todo.fromMap(c)).toList()
        : [];
    return todoList;
  }

  Future<int> add(Todo todo) async {
    Database db = _db;
    return await db.insert(_dbNameReference, todo.toMap());
  }

  Future<int> delete(int id) async {
    Database db = _db;
    return await db.delete(_dbNameReference, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    Database db = _db;
    return await db.update(_dbNameReference, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
  }



}

