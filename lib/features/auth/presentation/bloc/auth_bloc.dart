import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource _authDataSource;
  final SecureStorageService _storageService;

  AuthBloc(this._authDataSource, this._storageService)
      : super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

 Future<void> _onCheckAuthStatus(
  CheckAuthStatus event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoading());

  final isLoggedIn = await _storageService.isLoggedIn();

  if (isLoggedIn) {
    final userInfo = await _storageService.getUserInfo();

    if (userInfo['userId'] != null &&
        userInfo['studentId'] != null &&
        userInfo['userName'] != null) {
      // Create UserModel from stored data
      final user = UserModel(
        id: userInfo['userId']!,
        studentId: userInfo['studentId']!,
        email: '', // Not stored locally
        role: 'student',
        fullName: userInfo['userName']!,
      );

      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  } else {
    emit(const AuthUnauthenticated());
  }
}


  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Call API
      final response = await _authDataSource.login(
        studentId: event.studentId,
        password: event.password,
      );

      // Save tokens
      await _storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      // Save user info
      await _storageService.saveUserInfo(
        userId: response.user.id,
        studentId: response.user.studentId,
        userName: response.user.fullName,
      );

      // Emit authenticated state
      emit(AuthAuthenticated(response.user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken != null) {
        await _authDataSource.logout(refreshToken);
      }
    } catch (e) {
      // Ignore logout errors
    } finally {
      await _storageService.clearAll();
      emit(const AuthUnauthenticated());
    }
  }
}