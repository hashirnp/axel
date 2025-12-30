import 'package:axel/core/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'app_event.dart';
part 'app_state.dart';

@injectable
class AppBloc extends Bloc<AppEvent, AppState> {
  final LocalStorage localStorage;

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get themeMode => _mode;

  AppBloc(this.localStorage) : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<ToggleTheme>(_onToggleTheme);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(AppLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));

      final loggedIn = await localStorage.isLoggedIn();

      if (loggedIn) {
        emit(AppAuthenticated());
      } else {
        emit(AppUnauthenticated());
      }
    } catch (_) {
      emit(AppError('Initialization failed'));
    }
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<AppState> emit) async {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    emit(AppThemeChanged(_mode));
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AppState> emit) async {
    await localStorage.clearSession();
    emit(AppUnauthenticated());
  }
}
