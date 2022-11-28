part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class VerifyAuthEvent extends AuthEvent {}

class AnonymousAuthEvent extends AuthEvent {}

class GoogleAuthEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class EmailAuthEvent extends AuthEvent {
  final String password;
  final String email;

  EmailAuthEvent(this.password, this.email);
  @override
  List<Object> get props => [password, email];
}
