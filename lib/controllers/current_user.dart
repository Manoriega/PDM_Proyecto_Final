import 'package:flutter/foundation.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/user.dart';

class UserProvider with ChangeNotifier {
  late MyUser _user;
  List<Pokemon> _team = [], _garden = [];

  MyUser get user => _user;
  List<Pokemon> get team => _team;
  List<Pokemon> get garden => _garden;

  void setTeam(List<Pokemon> team) {
    _team = team;
  }

  void setUser(MyUser user){
    _user = user;
  }

  void addPokemonToTeam(Pokemon pokemon) {
    if (_team.length < 4) {
      _team.add(pokemon);
    } else {
      _garden.add(pokemon);
    }
  }
}
