import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokimon/classes/item.dart';

class StoreUtils {
  buyItem(Item item, int num) async {
    print(num);
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        docsRef = await queryUser.get();
    var itemsList = docsRef.data()?["items"];
    for (var i = 0; i < num; i++) {
      itemsList.add(item.name);
    }
    queryUser.update({
      "trainerPoints": FieldValue.increment((-1 * (item.price * num))),
      "items": itemsList
    });
  }

  getTrainerPoints() async {
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        user = await queryUser.get();
    return user.data()?["trainerPoints"];
  }
}
