import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../utils/dummy_data.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ClearErrorRequested>(_onClearErrorRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final storedPassword = DummyData.credentials[event.email];
    if (storedPassword != null && storedPassword == event.password) {
      try {
        final user = DummyData.users.firstWhere((u) => u.email == event.email);
        emit(AuthAuthenticated(user));
      } catch (_) {
        emit(const AuthFailure('User tidak ditemukan di dummy data'));
      }
    } else {
      emit(const AuthFailure('Email atau password salah'));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }

  void _onClearErrorRequested(
    ClearErrorRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }
}
