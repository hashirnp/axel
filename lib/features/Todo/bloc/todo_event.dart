part of 'todo_bloc.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {
  final bool refresh;
  LoadTodos({this.refresh = false});
}

class SearchTodos extends TodoEvent {
  final String query;
  SearchTodos(this.query);
}

class ToggleTodoFavorite extends TodoEvent {
  final int id;
  ToggleTodoFavorite(this.id);
}

class ClearTodoCache extends TodoEvent {}
