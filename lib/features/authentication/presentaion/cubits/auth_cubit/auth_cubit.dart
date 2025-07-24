import 'package:bloc/bloc.dart';
import 'package:instagram/features/authentication/domain/repos/auth_repo.dart';
import '../../../domain/entities/app_user.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  AppUser? get currentUser => _currentUser;

  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> loginWithEmailAndPw(String email, String pw) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.loginWithEmailAndPassword(email, pw);
      if (user != null) {
        _currentUser = user;
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> register(String name, String email, String pw) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.registerWithEmailAndPassword(name, email, pw);
      if (user != null) {
        _currentUser = user;
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    await authRepo.logout();
    emit(AuthUnauthenticated());
  }
}
