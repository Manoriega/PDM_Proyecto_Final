import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pokimon/classes/Move.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/utils/secrets.dart';

part 'catch_pokemon_event.dart';
part 'catch_pokemon_state.dart';

class CatchPokemonBloc extends Bloc<CatchPokemonEvent, CatchPokemonState> {
  CatchPokemonBloc() : super(CatchPokemonInitial()) {
    on<CatchByQR>(_getPokemon);
    on<ResetCatchEvent>(_resetCatch);
  }
  _getPokemon(CatchByQR event, emit) async {
    try {
      var pokemonUri = Uri.parse(APIBASE + "pokemon/" + event.QRresultCode);
      var pokemonResponse = await get(pokemonUri);
      Map<String, dynamic> pokemonJSON = await jsonDecode(pokemonResponse.body);
      var speciesUri =
          Uri.parse(APIBASE + "pokemon-species/" + event.QRresultCode);
      var speciesResponse = await get(speciesUri);
      Map<String, dynamic> speciesJSON = await jsonDecode(speciesResponse.body);
      var firstAttackJSON = await getMove("tackle"),
          secondAttackJSON = await getSpecialMove(event.QRresultCode);
      Move firstAttack = Move(firstAttackJSON),
          secondAttack = Move(secondAttackJSON);
      Pokemon pokemonfromQR =
          Pokemon(pokemonJSON, speciesJSON, 5, firstAttack, secondAttack);
      emit(SucessfulCatch(pokemon: pokemonfromQR));
    } catch (e) {
      emit(IncorrectQR());
    }
  }

  FutureOr<void> _resetCatch(event, emit) {
    emit(CatchPokemonInitial());
  }
}
