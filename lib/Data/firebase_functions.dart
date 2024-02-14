import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseFunctions {
  static void SignUp(String email, String password, BuildContext context) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
// Add more user data fields here as needed
      }).then((_) {
// _emailController.clear();
// _passwordController.clear();

// Navigate to the next screen
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }).catchError((error) {
      print("Failed to sign up: $error");
// Handle error, e.g., display error message to user
    });
  }

  static void Login(String email, String password, BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      // Successfully signed in
      // Navigate to the next screen (e.g., home screen)
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((error) {
      print("Failed to sign in: $error");
      // Handle error, e.g., display error message to user
    });
  }

  static void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    }).catchError((error) {
      print("Failed to sign out: $error");
      // Handle error, e.g., display error message to user
    });
  }

}
