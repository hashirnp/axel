part of 'app_bloc.dart';

abstract class AppEvent {}

class AppStarted extends AppEvent {}

class ToggleTheme extends AppEvent {}

class LogoutRequested extends AppEvent {}
