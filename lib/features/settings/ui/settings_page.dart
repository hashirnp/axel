import 'package:axel/core/routes/app_routes.dart';
import 'package:axel/features/Todo/bloc/todo_bloc.dart';
import 'package:axel/features/app/bloc/app_bloc.dart';
import 'package:axel/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsActionDone) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionTitle(title: 'Appearance'),

            Card(
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: appBloc.themeMode == ThemeMode.dark,
                onChanged: (_) => appBloc.add(ToggleTheme()),
              ),
            ),

            const SizedBox(height: 24),
            _SectionTitle(title: 'Account'),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              ),
            ),

            const SizedBox(height: 24),
            _SectionTitle(title: 'Data'),

            Card(
              child: ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear Cache'),
                onTap: () {
                  context.read<SettingsBloc>().add(ClearCacheRequested());
                  context.read<TodoBloc>().add(ClearTodoCache());
                  context.read<TodoBloc>().add(LoadTodos());
                },
              ),
            ),

            const SizedBox(height: 24),
            _SectionTitle(title: 'Danger Zone'),

            Card(
              color: theme.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  appBloc.add(LogoutRequested());
                  appBloc.add(UserChanged(null));
                  context.read<TodoBloc>().add(ClearTodoCache());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
