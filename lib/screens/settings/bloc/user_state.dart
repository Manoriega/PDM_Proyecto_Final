part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class LoadingUserState extends UserState {}

class ErrorLoadingUserState extends UserState {}

class UserSucceed extends UserState {
  final MyUser myUser;
  final String profileImage;

  UserSucceed(this.profileImage, {required this.myUser});
  @override
  // TODO: implement props
  List<Object> get props => [myUser];
}
