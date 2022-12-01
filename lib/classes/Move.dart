import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/secrets.dart' as SECRETS;

class Move {
  late int power, accuracy;
  late String name, type, category;

  Move(Map<String, dynamic> moveJson) {
    power = moveJson["power"];
    accuracy = moveJson["accuracy"];
    name = firstCharacterCap(moveJson["name"]);
    type = firstCharacterCap(moveJson["type"]["name"]);
    category = moveJson["damage_class"]["name"];
  }
  @override
  String toString() {
    return "$name. Power: $power. Accuracy: $accuracy. Type: $type. Category: $category";
  }
}

getMove(String moveName) async {
  var url = "${SECRETS.APIBASE}move/$moveName",
      movementResponse = await http.get(Uri.parse(url)),
      movement = jsonDecode(movementResponse.body);
  return movement;
}

String firstCharacterCap(String str) {
  String s = str.substring(0, 1).toUpperCase() + str.substring(1);
  return s;
}
