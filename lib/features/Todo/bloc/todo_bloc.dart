import 'dart:async';
import 'dart:developer';

import 'package:axel/core/error/error_mapper.dart';
import 'package:axel/features/Todo/domain/entities/todo.dart';
import 'package:axel/features/Todo/domain/usecases/fetch_todo_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'todo_event.dart';
part 'todo_state.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FetchTodosUsecase fetchTodos;

  static const int _limit = 20;
  int _page = 1;
  bool _hasMore = true;
  bool _loading = false;
  String _query = '';
  final List<Todo> _todos = [];

  TodoBloc(this.fetchTodos) : super(TodoInitial()) {
    on<LoadTodos>(_onLoad);
    on<SearchTodos>(
      _onSearch,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<ToggleTodoFavorite>(_onToggleFav);
    on<ClearTodoCache>(_onClearTodoCache);
  }

  Future<void> _onLoad(LoadTodos event, Emitter<TodoState> emit) async {
    if (_loading || (!_hasMore && !event.refresh)) return;

    _loading = true;

    if (event.refresh) {
      _page = 1;
      _hasMore = true;
      _todos.clear();
    }

    // 🔹 Emit loading ONLY for first page
    if (_page == 1) {
      emit(TodoLoading());
    }

    try {
      final result = await fetchTodos(
        page: _page,
        limit: _limit,
        query: _query,
      );

      _hasMore = result.length == _limit;
      _page++;

      _todos.addAll(result);

      Set s = {};
      for (var element in _todos) {
        if (s.contains(element.title)) {
          log("duplicate ${element.title}");
        } else {
          log(s.add(element.title).toString());
        }
      }

      emit(TodoLoaded(List.from(_todos), _hasMore));
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      emit(TodoError(ErrorMapper.map(e)));
    } finally {
      _loading = false;
    }
  }

  Future<void> _onSearch(SearchTodos event, Emitter<TodoState> emit) async {
    _query = event.query;
    add(LoadTodos(refresh: true));
  }

  Future<void> _onToggleFav(
    ToggleTodoFavorite event,
    Emitter<TodoState> emit,
  ) async {
    await fetchTodos.repository.toggleFavorite(event.id);

    final index = _todos.indexWhere((t) => t.id == event.id);
    if (index == -1) return;

    _todos[index] = _todos[index].copyWith(
      isFavorite: !_todos[index].isFavorite,
    );

    emit(TodoLoaded(List.from(_todos), _hasMore));
  }

  FutureOr<void> _onClearTodoCache(
    ClearTodoCache event,
    Emitter<TodoState> emit,
  ) async {
    _page = 1;
    _hasMore = true;
    _query = '';
    _todos.clear();

    emit(TodoLoading());

    // 🔥 MUST refresh to reload favs for current user
    add(LoadTodos(refresh: true));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }
}
