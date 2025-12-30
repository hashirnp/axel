import 'package:axel/core/error/error_mapper.dart';
import 'package:axel/features/Auth/domain/entities/user.dart';
import 'package:axel/features/Auth/domain/usecases/login_usecase.dart';
import 'package:axel/features/Auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;

  AuthBloc(this.loginUsecase, this.registerUsecase) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUsecase(
        event.username,
        event.password,
        event.rememberMe,
      );
      if (user == null) {
        emit(AuthFailure('Invalid credentials'));
      } else {
        emit(AuthSuccess());

      }
    } catch (e) {
      emit(AuthFailure(ErrorMapper.map(e)));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await registerUsecase(event.user);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(ErrorMapper.map(e)));
    }
  }
}
