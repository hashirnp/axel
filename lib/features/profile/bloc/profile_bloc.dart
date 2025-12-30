import 'dart:developer';

import 'package:axel/features/profile/domain/entity/profile.dart';
import 'package:axel/features/profile/domain/repositories/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoad);
    on<SaveProfile>(_onSave);
  }

  int _completion(Profile p) {
    int done = 0;
    log(p.toJson().toString());
    if (p.username!.isNotEmpty) done++;
    if (p.fullName!.isNotEmpty) done++;
    if (p.imagePath!.isNotEmpty) done++;
    if (p.dob!.year > 1900) done++;
    return ((done / 4) * 100).toInt();
  }

  Future<void> _onLoad(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile();
      emit(ProfileLoaded(profile, _completion(profile)));
    } catch (c, s) {
      log(c.toString(), stackTrace: s);
      emit(ProfileError('Failed to load profile'));
    }
  }

  Future<void> _onSave(SaveProfile event, Emitter<ProfileState> emit) async {
    await repository.updateProfile(event.profile);
    emit(ProfileSaved());
    add(LoadProfile());
  }
}
