// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:axel/core/di/modules.dart' as _i877;
import 'package:axel/core/navigation/navigation_service.dart' as _i461;
import 'package:axel/core/network/dio_client.dart' as _i870;
import 'package:axel/core/storage/local_storage.dart' as _i617;
import 'package:axel/features/app/bloc/app_bloc.dart' as _i345;
import 'package:axel/features/Auth/bloc/auth_bloc.dart' as _i673;
import 'package:axel/features/Auth/data/repositories/auth_repository_impl.dart'
    as _i212;
import 'package:axel/features/Auth/domain/repositories/auth_repository.dart'
    as _i700;
import 'package:axel/features/Auth/domain/usecases/login_usecase.dart' as _i368;
import 'package:axel/features/Auth/domain/usecases/register_usecase.dart'
    as _i1029;
import 'package:axel/features/profile/bloc/profile_bloc.dart' as _i36;
import 'package:axel/features/profile/data/repositories/profile_repo_imple.dart'
    as _i17;
import 'package:axel/features/profile/domain/repositories/profile_repo.dart'
    as _i69;
import 'package:axel/features/profile/domain/usecase/update_profile_usecase.dart'
    as _i10;
import 'package:axel/features/settings/bloc/settings_bloc.dart' as _i224;
import 'package:axel/features/Todo/bloc/todo_bloc.dart' as _i156;
import 'package:axel/features/Todo/data/repositories/todo_repository_impl.dart'
    as _i48;
import 'package:axel/features/Todo/domain/repositories/todo_repository.dart'
    as _i214;
import 'package:axel/features/Todo/domain/usecases/fetch_todo_usecase.dart'
    as _i1009;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => storageModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i461.NavigationService>(() => _i461.NavigationService());
    gh.lazySingleton<_i870.DioClient>(() => _i870.DioClient());
    gh.factory<_i224.SettingsBloc>(
      () => _i224.SettingsBloc(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i700.AuthRepository>(
      () => _i212.AuthRepositoryImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i69.ProfileRepository>(
      () => _i17.ProfileRepositoryImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i368.LoginUsecase>(
      () => _i368.LoginUsecase(gh<_i700.AuthRepository>()),
    );
    gh.factory<_i1029.RegisterUsecase>(
      () => _i1029.RegisterUsecase(gh<_i700.AuthRepository>()),
    );
    gh.lazySingleton<_i617.LocalStorage>(
      () => _i617.LocalStorageImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i345.AppBloc>(() => _i345.AppBloc(gh<_i617.LocalStorage>()));
    gh.lazySingleton<_i214.TodoRepository>(
      () => _i48.TodoRepositoryImpl(
        gh<_i870.DioClient>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i36.ProfileBloc>(
      () => _i36.ProfileBloc(gh<_i69.ProfileRepository>()),
    );
    gh.factory<_i10.UpdateProfileUsecase>(
      () => _i10.UpdateProfileUsecase(gh<_i69.ProfileRepository>()),
    );
    gh.factory<_i673.AuthBloc>(
      () => _i673.AuthBloc(
        gh<_i368.LoginUsecase>(),
        gh<_i1029.RegisterUsecase>(),
      ),
    );
    gh.factory<_i1009.FetchTodosUsecase>(
      () => _i1009.FetchTodosUsecase(gh<_i214.TodoRepository>()),
    );
    gh.factory<_i156.TodoBloc>(
      () => _i156.TodoBloc(gh<_i1009.FetchTodosUsecase>()),
    );
    return this;
  }
}

class _$StorageModule extends _i877.StorageModule {}
