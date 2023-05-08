

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todos_model.dart';

class RemoteDataSource {

  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');

  /*
        .withConverter<Todo>( fromFirestore: (snapshot, _) => Todo.fromJson(snapshot.data()!),
    toFirestore: (model, _) => model.toJson(),
  );
   */

  Future<List<Todo>> getTodos() async {

    final snapShot = await taskCollection.get();
    final todos = snapShot.docs.map((e) => Todo.fromSnapshot(e as DocumentSnapshot<Map<String, dynamic>>)).toList();

    return todos;
  }

  Future add(Todo todo) async {
    return await taskCollection.add({
      'id': todo.id,
      'title': todo.title,
      'description':todo.description,
      'shared': true,
      'isCanceled': todo.isCanceled,
      'isCompleted':todo.isCompleted,
    });
  }

  Future<int> delete(int id) async {
    throw UnimplementedError();
  }

  Future<int> update(Todo todo) async {
    throw UnimplementedError();
  }

}