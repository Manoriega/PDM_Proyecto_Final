import 'package:pokimon/classes/Pokemon.dart';

class Item {
  late String name, image, description;
  late int value, type, price;

  Item(this.name, this.value, this.type, this.image, this.description,
      this.price);

  useItem(Pokemon pokemon) {
    if (type == 0) {
      if (pokemon.currentHP + value >= pokemon.hp) {
        pokemon.currentHP = pokemon.hp;
      } else {
        pokemon.currentHP += value;
      }
    }
  }
}
