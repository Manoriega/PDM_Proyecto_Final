import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TeamProvider with ChangeNotifier {
  Future<bool> searchPokemonInDB(String pokemon) async {
    var pokemonInDB = await FirebaseFirestore.instance
        .collection('pokemon_users')
        .where('name', isEqualTo: pokemon)
        .where('onTeam', isEqualTo: true);
    if (pokemonInDB == null)
      return false;
    else
      return true;
  }
}
