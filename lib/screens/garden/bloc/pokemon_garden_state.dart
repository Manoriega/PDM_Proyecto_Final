part of 'pokemon_garden_bloc.dart';

abstract class PokemonGardenState extends Equatable {
  const PokemonGardenState();

  @override
  List<Object> get props => [];
}

class PokemonGardenInitial extends PokemonGardenState {}

class PokemonGardenLoading extends PokemonGardenState {}

class PokemonGardenError extends PokemonGardenState {}

class GotAllPokemons extends PokemonGardenState {
  final List<Pokemon> myPokemons;

  GotAllPokemons({required this.myPokemons});
  @override
  List<Object> get props => [myPokemons];
}
