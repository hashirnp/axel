part of 'todo_bloc.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final bool hasMore;
  TodoLoaded(this.todos, this.hasMore);
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}
