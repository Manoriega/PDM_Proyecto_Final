import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user_auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserAuthRepository _authRepo = UserAuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<VerifyAuthEvent>(_authVerfication);
    on<AnonymousAuthEvent>(_authAnonymous);
    on<GoogleAuthEvent>(_authUser);
    on<SignOutEvent>(_signOut);
    on<EmailAuthEvent>(_EmailVerification);
  }
  final random = Random();

  Future<FutureOr<void>> _EmailVerification(EmailAuthEvent event, emit) async {
    emit(AuthAwaitingState());
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(AuthSuccessState());
    } catch (e) {
      print(e);
      emit(AuthErrorState());
    }
  }

  FutureOr<void> _authVerfication(event, emit) {
    // inicializar datos de la app
    if (_authRepo.isAlreadyAuthenticated()) {
      emit(AuthSuccessState());
    } else {
      emit(UnAuthState());
    }
  }

  FutureOr<void> _signOut(event, emit) async {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      await _authRepo.signOutFirebaseUser();
    } else {
      await _authRepo.signOutGoogleUser();
      await _authRepo.signOutFirebaseUser();
    }
    emit(SignOutSuccessState());
  }

  FutureOr<void> _authUser(event, emit) async {
    emit(AuthAwaitingState());
    try {
      await _authRepo.signInWithGoogle();
      emit(AuthSuccessState());
    } catch (e) {
      print("Error al autenticar: $e");
      emit(AuthErrorState());
    }
  }

  Future<void> _createUserCollectionFirebase(String uid) async {
    var userDoc = await FirebaseFirestore.instance
        .collection("poket_users")
        .doc(uid)
        .get();
    // Si no exite el doc, lo crea con valor default lista vacia
    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection("pocket_users").doc(uid).set(
        {
          'username':
              "TrainerMaster${next(0, 1000000)}x${next(0, 1000000)}${next(0, 1000000)}",
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "trainerPoints": 0,
          "battles": []
        },
      );
    } else {
      // Si ya existe el doc return
      return;
    }
  }

  int next(int min, int max) => min + random.nextInt(max - min);

  FutureOr<void> _authAnonymous(event, emit) {
    // TODO:
  }
}
