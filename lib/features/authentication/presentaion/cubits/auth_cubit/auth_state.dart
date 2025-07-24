part of 'auth_cubit.dart';

@immutable
sealed class AuthenticationState {}

final class AuthInitial extends AuthenticationState {}

final class AuthLoading extends AuthenticationState {}

final class AuthAuthenticated extends AuthenticationState {
  final AppUser user;
  AuthAuthenticated(this.user);
}

final class AuthUnauthenticated extends AuthenticationState {}

final class AuthFailed extends AuthenticationState {
  final String message;
  AuthFailed(this.message);
}