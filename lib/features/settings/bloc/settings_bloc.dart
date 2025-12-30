import 'package:axel/core/const/strings.dart';
import 'package:axel/features/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences prefs;
  final AppBloc appBloc;

  SettingsBloc(this.prefs, this.appBloc) : super(SettingsInitial()) {
    on<ClearCacheRequested>((event, emit) async {
      final userId = prefs.getString(StringConstants.currentUserId);
      if (userId != null) {
        await prefs.remove('${StringConstants.favKey}_$userId');
      }

      await prefs.remove(StringConstants.cacheKey);
      await prefs.remove(StringConstants.favKey);

      appBloc.add(CacheCleared());
      emit(SettingsActionDone('Cache cleared'));
    });
  }
}
