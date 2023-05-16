

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

  Future delete(Todo todo) async {

    int id = todo.id;

    final snapShot = await taskCollection.where("id", isEqualTo: id).get();

    //snapShot.docs.forEach((doc) {
    //  print('${doc.id} => ${doc.data()}');
    //});

    snapShot.docs.forEach((doc) async => {

      await taskCollection.doc(doc.id).delete().then(
            (doc) => print("Document deleted"),
            onError: (e) => print("Error updating document $e"),
      )
    });

  }

  Future update(Todo todo) async {

    String id = todo.id as String;
    final snapShot = await taskCollection.where("id", isEqualTo: id).get();

    snapShot.docs.forEach((doc) async => {

      await taskCollection.doc(doc.id).update({
        'id': todo.id,
        'title': todo.title,
        'description': todo.description,
        'isCompleted': todo.isCompleted,
        'isCanceled': todo.isCanceled,
        'isRemote': true,
      })
    });


  }

}