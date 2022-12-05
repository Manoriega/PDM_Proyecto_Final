import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokimon/classes/BeginnerPokemon.dart';

part 'beginner_pokemons_event.dart';
part 'beginner_pokemons_state.dart';

class BeginnerPokemonsBloc
    extends Bloc<BeginnerPokemonsEvent, BeginnerPokemonsState> {
  BeginnerPokemonsBloc() : super(BeginnerPokemonsInitial()) {
    on<AddBeginnerPokemonsEvent>(_CreateBeginnerPokemons);
    on<IsPokemonsEmptyEvent>(_pokemonIsEmpty);
  }

  FutureOr<void> _pokemonIsEmpty(IsPokemonsEmptyEvent event, emit) async {
    try {
      var queryUser = await FirebaseFirestore.instance
          .collection('pocket_users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      var docsRef = await queryUser.get();
      dynamic test = docsRef.data()?["pokemons"];
      var variable = docsRef.get('pokemons');
      List<dynamic> listIds = docsRef.data()?["pokemons"] as List;
      if (listIds.isEmpty)
        emit(ChoosePokemonsState());
      else
        emit(BeginerPokemonsSucess());
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> _CreateBeginnerPokemons(
      AddBeginnerPokemonsEvent event, emit) async {
    bool result = await addPokemon(event.pokemon);
    if (result == true)
      emit(BeginerPokemonsSucess());
    else
      emit(BeginnerPokemonError());
  }

  Future<bool> addPokemon(BeginnerPokemon pokemon) async {
    CollectionReference pokemons =
        FirebaseFirestore.instance.collection('pokemon_users');
    try {
      var pokemonID = await pokemons.add({
        "firstAttack": pokemon.firstattack,
        "level": pokemon.level,
        "name": pokemon.name,
        "onTeam": pokemon.onTeam,
        "secondAttack": pokemon.secondattack
      });
      return _updateUserPokemons(pokemonID.id);
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateUserPokemons(String PokemonId) async {
    try {
      //traer el user
      var queryUser = await FirebaseFirestore.instance
          .collection('pocket_users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var docsRef = await queryUser.get();
      List<dynamic> listIds = docsRef.data()?["pokemons"];
      listIds.add(PokemonId);
      //agregar el nuevo id a la lista
      await queryUser.update({"pokemons": listIds});
      return true;
    } catch (e) {
      return false;
    }
  }
}
