import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:pokimon/classes/Move.dart';
import 'package:pokimon/utils/secrets.dart';

import '../../../classes/Pokemon.dart';

part 'pokemon_garden_event.dart';
part 'pokemon_garden_state.dart';

class PokemonGardenBloc extends Bloc<PokemonGardenEvent, PokemonGardenState> {
  PokemonGardenBloc() : super(PokemonGardenInitial()) {
    on<getAllMyPokemonsEvent>(_getPokemons);
    on<ResetAllMyPokemonsEvent>(_resetMyGarden);
  }

  FutureOr<void> _getPokemons(getAllMyPokemonsEvent event, emit) async {
    try {
      var queryUser = FirebaseFirestore.instance
              .collection("pocket_users")
              .doc(FirebaseAuth.instance.currentUser!.uid),
          docsRef = await queryUser.get(),
          listIds = docsRef.data()?["pokemons"];

      var queryPokemons =
          await FirebaseFirestore.instance.collection("pokemon_users").get();

      var myTeamPokemons = queryPokemons.docs
          .where((doc) =>
              listIds.contains(doc.id) && doc.data()["onTeam"] == false)
          .map((doc) => doc.data().cast<String, dynamic>())
          .toList();
      List<Pokemon> myTeam = [];
      for (var i = 0; i < myTeamPokemons.length; i++) {
        var pokemonUri =
            Uri.parse(APIBASE + "pokemon/" + myTeamPokemons[i]["name"]);
        dynamic pokemonResponse = await get(pokemonUri);
        Map<String, dynamic> pokemonJSON =
            await jsonDecode(pokemonResponse.body);
        dynamic speciesUri =
            Uri.parse(APIBASE + "pokemon-species/" + myTeamPokemons[i]["name"]);
        dynamic speciesResponse = await get(speciesUri);
        Map<String, dynamic> speciesJSON =
            await jsonDecode(speciesResponse.body);
        var firstAttackJSON = await getMove(myTeamPokemons[i]["firstAttack"]!),
            secondAttackJSON =
                await getMove(myTeamPokemons[i]["secondAttack"]!);
        Move firstAttack = Move(firstAttackJSON),
            secondAttack = Move(secondAttackJSON);
        myTeam.add(Pokemon(pokemonJSON, speciesJSON, myTeamPokemons[i]["level"],
            firstAttack, secondAttack));
      }
      emit(GotAllPokemons(myPokemons: myTeam));
    } catch (e) {
      print("Error al obtener items en espera: $e");
      emit(PokemonGardenError());
    }
  }

  FutureOr<void> _resetMyGarden(event, emit) {
    emit(PokemonGardenInitial());
  }
}
