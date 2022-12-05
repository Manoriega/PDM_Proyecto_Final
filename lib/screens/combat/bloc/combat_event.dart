part of 'combat_bloc.dart';

abstract class CombatEvent extends Equatable {
  const CombatEvent();

  @override
  List<Object> get props => [];
}

class PlayerAttackEvent extends CombatEvent {
  final int attack;
  final Trainer player, enemy;

  PlayerAttackEvent(this.attack, this.player, this.enemy);

  @override
  // TODO: implement props
  List<Object> get props => [attack, player, enemy];
}

class PlayerChangePokemonEvent extends CombatEvent {
  final Pokemon pokemonActive;

  PlayerChangePokemonEvent(this.pokemonActive);

  @override
  // TODO: implement props
  List<Object> get props => [pokemonActive];
}

class PlayerUseItemEvent extends CombatEvent {
  final Item item;
  final Pokemon pokemon;
  final Trainer player;

  PlayerUseItemEvent(this.item, this.pokemon, this.player);
  @override
  // TODO: implement props
  List<Object> get props => [item, pokemon, player];
}

class EnemyTurnEvent extends CombatEvent {
  final Trainer enemy, player;
  final int option;

  EnemyTurnEvent(this.enemy, this.option, this.player);
  @override
  // TODO: implement props
  List<Object> get props => [enemy, option, player];
}

class SetPlayerTurnEvent extends CombatEvent {}
