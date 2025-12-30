import 'package:axel/core/di/service_locator.dart';
import 'package:axel/core/navigation/navigation_service.dart';
import 'package:axel/core/routes/app_routes.dart';
import 'package:axel/features/Auth/bloc/auth_bloc.dart';
import 'package:axel/features/Auth/ui/pages/login_page.dart';
import 'package:axel/features/Auth/ui/pages/register_page.dart';
import 'package:axel/features/Todo/bloc/todo_bloc.dart';
import 'package:axel/features/Todo/ui/pages/home_page.dart';
import 'package:axel/features/app/bloc/app_bloc.dart';
import 'package:axel/features/app/ui/splash_page.dart';
import 'package:axel/features/profile/bloc/profile_bloc.dart';
import 'package:axel/features/profile/ui/profile_page.dart';
import 'package:axel/features/settings/bloc/settings_bloc.dart';
import 'package:axel/features/settings/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppBloc>()..add(AppStarted())),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<TodoBloc>()),
        BlocProvider(create: (_) => getIt<ProfileBloc>()),
        BlocProvider(create: (_) => getIt<SettingsBloc>()),
      ],
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is AppUnauthenticated) {
            getIt<NavigationService>().pushNamedAndRemoveUntil(AppRoutes.login);
          }
        },
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            final appBloc = context.read<AppBloc>();

            return BlocListener<AppBloc, AppState>(
              listener: (context, state) {
                if (state is AppUnauthenticated) {
                  getIt<NavigationService>().pushNamedAndRemoveUntil(
                    AppRoutes.login,
                  );
                }
              },
              child: MaterialApp(
                navigatorKey: getIt<NavigationService>().navigatorKey,
                debugShowCheckedModeBanner: false,
                themeMode: appBloc.themeMode,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                initialRoute: AppRoutes.splash,
                routes: {
                  AppRoutes.splash: (_) => const SplashPage(),
                  AppRoutes.login: (_) => const LoginPage(),
                  AppRoutes.home: (_) => const HomePage(),
                  AppRoutes.register: (_) => const RegisterPage(),
                  AppRoutes.profile: (_) => const ProfilePage(),
                  AppRoutes.settings: (_) => const SettingsPage(),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
