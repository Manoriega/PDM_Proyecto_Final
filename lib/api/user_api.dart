import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserApi {
  getUserName() async {
    var userId = FirebaseAuth.instance.currentUser?.uid, username = "";
    CollectionReference users =
        FirebaseFirestore.instance.collection("pocket_users");
    await users.doc(userId).get().then((doc) => {
          if (doc.exists) {username = doc.get("username")}
        });
    return username;
  }
}
