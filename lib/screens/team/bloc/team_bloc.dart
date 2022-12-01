// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:http/http.dart' as http;
import '../../../utils/secrets.dart' as SECRETS;
import '../../combat/utils/utils.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc() : super(TeamInitial()) {
    on<GetMyTeamEvent>(_getMyTeam);
    on<ResetMyTeamEvent>(_resetMyTeam);
  }

  FutureOr<void> _getMyTeam(
      GetMyTeamEvent event, Emitter<TeamState> emit) async {
    emit(LoadingTeamState());
    try {
      var queryUser = FirebaseFirestore.instance
              .collection("pocket_users")
              .doc(FirebaseAuth.instance.currentUser!.uid),
          docsRef = await queryUser.get(),
          listIds = docsRef.data()?["pokemons"];

      var queryPokemons =
          await FirebaseFirestore.instance.collection("pokemon_users").get();

      var myTeamPokemons = queryPokemons.docs
          .where(
              (doc) => listIds.contains(doc.id) && doc.data()["onTeam"] == true)
          .map((doc) => doc.data().cast<String, dynamic>())
          .toList();
      List<Pokemon> myTeam = [];
      for (var i = 0; i < myTeamPokemons.length; i++) {
        var pokemonUri =
            Uri.parse(SECRETS.APIBASE + "pokemon/" + myTeamPokemons[i]["name"]);
        var pokemonResponse = await http.get(pokemonUri);
        Map<String, dynamic> pokemonJSON = jsonDecode(pokemonResponse.body);
        var speciesUri = Uri.parse(
            SECRETS.APIBASE + "pokemon-species/" + myTeamPokemons[i]["name"]);
        var speciesResponse = await http.get(speciesUri);
        Map<String, dynamic> speciesJSON = jsonDecode(speciesResponse.body);
        myTeam.add(Pokemon(
            pokemonJSON,
            speciesJSON,
            myTeamPokemons[i]["level"],
            myTeamPokemons[i]["firstAttack"],
            myTeamPokemons[i]["secondAttack"]));
      }
      emit(TeamSucceedState(myTeam: myTeam));
    } catch (e) {
      print("Error al obtener items en espera: $e");
      emit(ErrorLoadingTeamState());
    }
  }

  FutureOr<void> _resetMyTeam(ResetMyTeamEvent event, Emitter<TeamState> emit) {
    emit(TeamInitial());
  }
}
