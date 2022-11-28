part of 'catch_pokemon_bloc.dart';

abstract class CatchPokemonState extends Equatable {
  const CatchPokemonState();

  @override
  List<Object> get props => [];
}

class CatchPokemonInitial extends CatchPokemonState {}

class IncorrectQR extends CatchPokemonState {}

class SucessfulCatch extends CatchPokemonState {
  final Pokemon pokemon;

  SucessfulCatch({required this.pokemon});
  @override
  // TODO: implement props
  List<Object> get props => [pokemon];
}
