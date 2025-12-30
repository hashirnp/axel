import 'dart:convert';

import 'package:axel/core/const/strings.dart';
import 'package:axel/core/network/dio_client.dart';
import 'package:axel/features/Todo/data/models/todo_model.dart';
import 'package:axel/features/Todo/domain/entities/todo.dart';
import 'package:axel/features/Todo/domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  final DioClient dio;
  final SharedPreferences prefs;

  TodoRepositoryImpl(this.dio, this.prefs);

  @override
  Future<List<Todo>> fetchTodos({
    required int page,
    required int limit,
    String? query,
  }) async {
    List<TodoModel> cachedTodos = [];

    // 1️⃣ Load full cache
    final cache = prefs.getString(StringConstants.cacheKey);
    if (cache != null) {
      cachedTodos = (jsonDecode(cache) as List)
          .map((e) => TodoModel.fromJson(e))
          .toList();
    }

    try {
      // 2️⃣ Fetch current page
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/todos',
        queryParams: {'_page': page, '_limit': limit},
      );

      final apiTodos = (response.data as List)
          .map((e) => TodoModel.fromJson(e))
          .toList();

      // 3️⃣ Merge cache + api (conflict-safe)
      final mergedMap = {
        for (var t in cachedTodos) t.id: t,
        for (var t in apiTodos) t.id: t,
      };

      final mergedList = mergedMap.values.toList()
        ..sort((a, b) => a.id.compareTo(b.id));

      // 4️⃣ Save full merged cache
      await prefs.setString(
        StringConstants.cacheKey,
        jsonEncode(mergedList.map((e) => e.toJson()).toList()),
      );

      // 5️⃣ Return only current page slice
      return _applyFavoritesAndSearch(
        _paginate(mergedList, page, limit),
        query,
      );
    } catch (_) {
      if (cachedTodos.isEmpty) rethrow;

      return _applyFavoritesAndSearch(
        _paginate(cachedTodos, page, limit),
        query,
      );
    }
  }

  // 🔹 Safe pagination
  List<TodoModel> _paginate(List<TodoModel> source, int page, int limit) {
    final start = (page - 1) * limit;
    final end = start + limit;

    if (start >= source.length) return [];
    return source.sublist(start, end.clamp(0, source.length));
  }

  // 🔹 Safe favorites + search
  List<Todo> _applyFavoritesAndSearch(List<TodoModel> source, String? query) {
    final favs = _safeGetFavorites();

    final filtered = query == null || query.isEmpty
        ? source
        : source
              .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return filtered.map((t) {
      return Todo(
        id: t.id,
        title: t.title,
        completed: t.completed,
        isFavorite: favs.contains(t.id.toString()),
      );
    }).toList();
  }

  List<String> _safeGetFavorites() {
    try {
      return prefs.getStringList(_favKeyForUser()) ?? [];
    } catch (_) {
      prefs.remove(_favKeyForUser());
      return [];
    }
  }

  @override
  Future<void> toggleFavorite(int id) async {
    final favs = _safeGetFavorites();

    favs.contains(id.toString())
        ? favs.remove(id.toString())
        : favs.add(id.toString());

    await prefs.setStringList(_favKeyForUser(), favs);
  }

  String _favKeyForUser() {
    final userId = prefs.getString(StringConstants.currentUserId);

    if (userId == null) {
      throw Exception('User not logged in');
    }
    return '${StringConstants.favKey}_$userId';
  }
}
