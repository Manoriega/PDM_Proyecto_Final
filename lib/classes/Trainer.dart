import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/item.dart';

class Trainer {
  late String name;
  late Pokemon active;
  late List<Pokemon> team;
  late List<Item> backpack;

  Trainer(this.name, this.active, this.team, this.backpack);
}
