part of 'catch_pokemon_bloc.dart';

abstract class CatchPokemonEvent extends Equatable {
  const CatchPokemonEvent();

  @override
  List<Object> get props => [];
}

class CatchByQR extends CatchPokemonEvent {
  final String QRresultCode;

  CatchByQR({required this.QRresultCode});
  @override
  List<Object> get props => [QRresultCode];
}

class ResetCatchEvent extends CatchPokemonEvent {}
