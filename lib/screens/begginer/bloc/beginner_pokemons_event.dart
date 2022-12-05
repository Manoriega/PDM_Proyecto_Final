part of 'beginner_pokemons_bloc.dart';

abstract class BeginnerPokemonsEvent extends Equatable {
  const BeginnerPokemonsEvent();

  @override
  List<Object> get props => [];
}

class IsPokemonsEmptyEvent extends BeginnerPokemonsEvent {}

class AddBeginnerPokemonsEvent extends BeginnerPokemonsEvent {
  final BeginnerPokemon pokemon;

  AddBeginnerPokemonsEvent({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}
