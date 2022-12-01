part of 'combat_bloc.dart';

abstract class CombatState extends Equatable {
  const CombatState();

  @override
  List<Object> get props => [];
}

class CombatInitial extends CombatState {}

class PlayerTurnState extends CombatState {}

class PlayerChangePokemonState extends CombatState {
  final Pokemon changedP;

  PlayerChangePokemonState(this.changedP);
  @override
  // TODO: implement props
  List<Object> get props => [changedP];
}

class PlayerAttackFailedState extends CombatState {
  final String msg;
  PlayerAttackFailedState(this.msg);

  @override
  // TODO: implement props
  List<Object> get props => [msg];
}

class PlayerAttackSuccedState extends CombatState {
  final String msg;

  PlayerAttackSuccedState(this.msg);

  @override
  // TODO: implement props
  List<Object> get props => [msg];
}

class PlayerUseItem extends CombatState {
  final String msg;

  PlayerUseItem(this.msg);

  @override
  // TODO: implement props
  List<Object> get props => [msg];
}

class EnemyTurnState extends CombatState {}

class EnemyActionState extends CombatState {
  final String msg;

  EnemyActionState(this.msg);

  @override
  // TODO: implement props
  List<Object> get props => [msg];
}

class PlayerWinState extends CombatState {
  final String msg;

  PlayerWinState(this.msg);
  @override
  // TODO: implement props
  List<Object> get props => [msg];
}

class PlayerLooseState extends CombatState {
  final String msg;

  PlayerLooseState(this.msg);

  @override
  // TODO: implement props
  List<Object> get props => [msg];
}

class PlayerActivePokemonDiesState extends CombatState {}

class EnemyActivePokemonDiesState extends CombatState {}

class WaitingState extends CombatState {
  final String msg;
  final int state;

  WaitingState(this.msg, this.state);
  @override
  // TODO: implement props
  List<Object> get props => [msg, state];
}
