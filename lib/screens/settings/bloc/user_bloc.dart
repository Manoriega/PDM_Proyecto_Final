import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokimon/classes/User.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetMyProfileEvent>(_getMyProfile);
    on<ResetProfileEvent>(_resetProfile);
  }

  FutureOr<void> _getMyProfile(
      GetMyProfileEvent event, Emitter<UserState> emit) async {
    emit(LoadingUserState());
    try {
      var queryUser = FirebaseFirestore.instance
              .collection("pocket_users")
              .doc(FirebaseAuth.instance.currentUser!.uid),
          user = await queryUser.get();
      MyUser newUser = MyUser(user.data()?["createdAt"],
          user.data()?["trainerPoints"], user.data()?["username"]);
      emit(UserSucceed(myUser: newUser));
    } catch (e) {
      print("Error al obtener perfil en espera: $e");
      emit(ErrorLoadingUserState());
    }
  }

  CollectionReference users =
      FirebaseFirestore.instance.collection('pocket_users');

  FutureOr<void> _resetProfile(
      ResetProfileEvent event, Emitter<UserState> emit) {
    emit(UserInitial());
  }
}
