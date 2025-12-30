part of 'settings_bloc.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsActionDone extends SettingsState {
  final String message;
  SettingsActionDone(this.message);
}
