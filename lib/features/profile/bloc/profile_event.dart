part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final Profile profile;
  SaveProfile(this.profile);
}
