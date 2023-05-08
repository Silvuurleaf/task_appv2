import 'package:taskapp_mvvm/models/todos_model.dart';

abstract class ITodoRepository<T> {
  Future<void> add(T todo);
  Future<void> place(String key, T todo);

  Future<void> delete(String id, T todo);

  Future<void> update(String id, T todo);
  Future<void> updateByKey(String id, T todo);

  //read
  Future<T?> pull(String id);
  List<T> pullAllLocal();
  Future<List<T?>> pullAllRemote();

}