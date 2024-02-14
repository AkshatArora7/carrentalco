import 'package:carrentalco/Screens/Home/home_page.dart';
import 'package:carrentalco/Screens/Login/login_screen.dart';
import 'package:carrentalco/Screens/Signup/signup_screen.dart';
import 'package:carrentalco/Screens/Splash/Splash.dart';
import 'package:carrentalco/Screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const Splash(), // Default route
  '/welcome': (context) => const WelcomeScreen(),
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginScreen(),
  '/signUp': (context) => const SignUpScreen(),
  '/profile': (context) => const SignUpScreen(),
};
