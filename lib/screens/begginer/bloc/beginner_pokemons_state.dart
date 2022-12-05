part of 'beginner_pokemons_bloc.dart';

abstract class BeginnerPokemonsState extends Equatable {
  const BeginnerPokemonsState();

  @override
  List<Object> get props => [];
}

class BeginnerPokemonsInitial extends BeginnerPokemonsState {}

class BeginnerPokemonsLoading extends BeginnerPokemonsState {}

class BeginerPokemonsSucess extends BeginnerPokemonsState {}

class ChoosePokemonsState extends BeginnerPokemonsState {}

class BeginnerPokemonError extends BeginnerPokemonsState {}
