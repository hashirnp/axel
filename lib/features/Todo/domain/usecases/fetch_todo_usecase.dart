import 'package:axel/features/Todo/domain/entities/todo.dart';
import 'package:axel/features/Todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchTodosUsecase {
  final TodoRepository repository;
  FetchTodosUsecase(this.repository);

  Future<List<Todo>> call({
    required int page,
    required int limit,
    String? query,
  }) {
    return repository.fetchTodos(
      page: page,
      limit: limit,
      query: query,
    );
  }
}
