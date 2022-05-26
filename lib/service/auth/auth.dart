import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailAuth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int r = 0; //signup
  int i = 0; //sign in

  Future<int> emailsignUp(String em, String pw) async {
    int res = 0;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: em, password: pw);
      r = 0;
      res = 1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        r = 1;
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        r = 2;
        print('The account already exists for that email.');
      }
    } catch (e) {
      r = 3;
      print(e);
    }

    notifyListeners();
    return res;
  }

  Future<int> emailsignIN(em, pw) async {
    int res = 0;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: em, password: pw);
      i = 0;
      res = 1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        i = 1;
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        i = 2;
        print('Wrong password provided for that user.');
      }
    }
    //   notifyListeners();
    return res;
  }

  int getSignupstatus() {
    return r;
  }

  int getSigninstatus() {
    return i;
  }
}
