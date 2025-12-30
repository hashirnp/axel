class Todo {
  final int id;
  final String title;
  final bool completed;
  final bool isFavorite;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.isFavorite,
  });

  Todo copyWith({bool? isFavorite}) {
    return Todo(
      id: id,
      title: title,
      completed: completed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
