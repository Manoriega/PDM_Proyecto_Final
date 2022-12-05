part of 'pokemon_garden_bloc.dart';

abstract class PokemonGardenEvent extends Equatable {
  const PokemonGardenEvent();

  @override
  List<Object> get props => [];
}

class getAllMyPokemonsEvent extends PokemonGardenEvent {}

class ResetAllMyPokemonsEvent extends PokemonGardenEvent {}
