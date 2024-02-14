import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // User is already logged in, navigate to home page directly
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _navigateToHome();
      });
    } else {
      // User is not logged in, navigate to login screen
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _navigateToLogin();
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: MediaQuery.of(context).size.height > 800 ? 140.0 : 150,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

  }
}
