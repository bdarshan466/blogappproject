import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  Future<void> signup(
      String email, String password, String name, BuildContext ctx) async {
    UserCredential userCredential;
    String uId;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      uId = userCredential.user.uid;
      FirebaseFirestore.instance.collection("users").doc(uId).set({
        "email": email,
        "name": name,
      });
      notifyListeners();
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password, BuildContext ctx) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
