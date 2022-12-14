part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetMyProfileEvent extends UserEvent {}

class ResetProfileEvent extends UserEvent {}

class UpdateUserName extends UserEvent {}
