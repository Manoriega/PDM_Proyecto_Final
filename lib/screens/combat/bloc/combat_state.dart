part of 'combat_bloc.dart';

abstract class CombatState extends Equatable {
  const CombatState();

  @override
  List<Object> get props => [];
}

class CombatInitial extends CombatState {}

class PlayerTurnState extends CombatState {}

class EnemyTurnState extends CombatState {}

class PlayerWinState extends CombatState {}

class PlayerLooseState extends CombatState {}
