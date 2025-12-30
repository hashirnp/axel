import 'package:axel/core/routes/app_routes.dart';
import 'package:axel/features/Todo/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodos());

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 120) {
        context.read<TodoBloc>().add(LoadTodos());
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search todos',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => context.read<TodoBloc>().add(SearchTodos(v)),
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6,
                    separatorBuilder: (c, i) => const SizedBox(height: 12),
                    itemBuilder: (c, i) => Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }

                if (state is TodoLoaded && state.todos.isEmpty) {
                  return const Center(child: Text('No todos found'));
                }

                if (state is TodoLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TodoBloc>().add(LoadTodos(refresh: true));
                    },
                    child: ListView.separated(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.hasMore
                          ? state.todos.length + 1
                          : state.todos.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        if (i >= state.todos.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final todo = state.todos[i];

                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              todo.title,
                              style: theme.textTheme.titleMedium,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                todo.isFavorite
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: todo.isFavorite
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                context.read<TodoBloc>().add(
                                  ToggleTodoFavorite(todo.id),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is TodoError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
