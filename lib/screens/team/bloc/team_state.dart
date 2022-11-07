part of 'team_bloc.dart';

abstract class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object> get props => [];
}

class TeamInitial extends TeamState {}

class LoadingTeamState extends TeamState {}

class ErrorLoadingTeamState extends TeamState {}

class TeamSucceedState extends TeamState {
  final List<Pokemon> myTeam;

  TeamSucceedState({required this.myTeam});
  @override
  // TODO: implement props
  List<Object> get props => [myTeam];
}
