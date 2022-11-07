part of 'combat_bloc.dart';

abstract class CombatEvent extends Equatable {
  const CombatEvent();

  @override
  List<Object> get props => [];
}

class PlayerAttackEvent extends CombatEvent {
  final int attack;

  PlayerAttackEvent(this.attack);

  @override
  // TODO: implement props
  List<Object> get props => [attack];
}

class PlayerChangePokemonEvent extends CombatEvent {}

class PlayerUseItemEvent extends CombatEvent {
  final int item;

  PlayerUseItemEvent(this.item);
  @override
  // TODO: implement props
  List<Object> get props => [item];
}
