part of 'app_bloc.dart';

abstract class AppState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppAuthenticated extends AppState {}

class AppUnauthenticated extends AppState {}

class AppError extends AppState {
  final String message;
  AppError(this.message);
}

class AppThemeChanged extends AppState {
  final ThemeMode mode;
  AppThemeChanged(this.mode);
}
