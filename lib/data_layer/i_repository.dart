

abstract class IRepository<Todo> {
  Future<void> add(Todo todo);
  Future<List<Todo>> getTodos();
  Future<void> delete(Todo todo);
  Future<void> update(Todo todo);

}