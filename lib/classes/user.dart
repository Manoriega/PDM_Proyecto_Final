// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late DateTime createdAt;
  late num trainerPoints;
  late String userName;

  MyUser(Timestamp createdAt, this.trainerPoints, this.userName) {
    this.createdAt = createdAt.toDate();
  }
}
