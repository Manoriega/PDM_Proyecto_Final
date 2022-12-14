import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int next(int min, int max) => min + random.nextInt(max - min);

  final random = Random();

  // true -> go home page
  // false -> go login page
  bool isAlreadyAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> signOutGoogleUser() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOutFirebaseUser() async {
    await _auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    //Google sign in
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    // credenciales de usuario autenticado con Google
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // firebase sign in con credenciales de Google
    final authResult = await _auth.signInWithCredential(credential);

    // Extraer token**
    // User user = authResult.user!;
    // final firebaseToken = await user.getIdToken();
    // print("user fcm token:${firebaseToken}");

    // crear tabla user en firebase cloudFirestore y agregar valor fotoListId []
    await _createUserCollectionFirebase(_auth.currentUser!.uid);
  }

  Future<void> signInWithEmail(String emailAddress, String password) async {
    await _auth.signInWithEmailAndPassword(
        email: emailAddress, password: password);
  }

  Future<void> _createUserCollectionFirebase(String uid) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('pocket_users')
        .doc(uid)
        .get();
    // Si no exite el doc, lo crea con valor default lista vacia
    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('pocket_users').doc(uid).set(
        {
          'username':
              "TrainerMaster${next(0, 10)}x${next(0, 10)}${next(0, 10)}",
          "createdAt": DateTime.now(),
          "trainerPoints": 0,
          "battles": [],
          "pokemons": []
        },
      );
    } else {
      // Si ya existe el doc return
      return;
    }
  }
}
