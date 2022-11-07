part of 'team_bloc.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object> get props => [];
}

class GetMyTeamEvent extends TeamEvent {}

class ResetMyTeamEvent extends TeamEvent {}
