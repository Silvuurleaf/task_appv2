import 'package:hive/hive.dart';
import 'package:taskapp_mvvm/deprecated/i_todo_repository.dart';
import 'package:taskapp_mvvm/models/todos_model.dart';


class HiveRepository<T> implements ITodoRepository<T> {
  final Box _box;

  HiveRepository(this._box);

  @override
  Future<T?> pull(dynamic id) async {
    if (this.boxIsClosed) {
      return null;
    }

    return this._box.get(id);
  }

  @override
  Future<void> add(T object) async {
    if (this.boxIsClosed) {
      return;
    }
    await this._box.add(object);
  }

  @override
  Future<void> place(String key, T todo) async{
    if (this.boxIsClosed) {
      return;
    }
    await this._box.put(key, todo);
  }

  bool get boxIsClosed => !(this._box?.isOpen ?? false);

  @override
  Future<void> delete(String todoKey, T todo) async {

    for(int i = 0; i < _box.length; i++){

      Todo? requestedTodo = await this._box.get(i);
      if(requestedTodo?.id == todoKey)
      {
        this._box.delete(i);
        return;
      }
    }

    return;

  }


  @override
  Future<void> update(String key, T todo) async {

    this._box.put(key, todo);
  }

  @override
  Future<void> updateByKey(String key, T todo) async {
    this._box.put(key, todo);
  }

  @override
  List<T> pullAllLocal() {

    List<T>? boxedItems = [];

/*    for(int i = 0; i < _box.length; i++){
      print(_box.length);
      print("from hive repo");
      print(this._box.get(i));

      boxedItems.add(this._box.get(i));
    }*/

    boxedItems = _box.values.cast<T>().toList();


    return boxedItems;
  }

  @override
  Future<List<T>> pullAllRemote() {
    // TODO: implement pullAllRemote
    throw UnimplementedError();
  }


}