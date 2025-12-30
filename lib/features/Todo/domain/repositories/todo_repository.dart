import 'package:axel/features/Todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> fetchTodos({
    required int page,
    required int limit,
    String? query,
  });

  Future<void> toggleFavorite(int id);
}
