import 'package:carrentalco/Screens/AllBrands/AllBrands.dart';
import 'package:carrentalco/Screens/AllCars/AllCars.dart';
import 'package:carrentalco/Screens/Bookings/Bookings.dart';
import 'package:carrentalco/Screens/DealerDashboard/ViewBookings/ViewBookings.dart';
import 'package:carrentalco/Screens/DealerDashboard/ViewCars/ViewCars.dart';
import 'package:carrentalco/Screens/DealerDashboard/ViewCars/components/AddDealerCars.dart';
import 'package:carrentalco/Screens/Home/home_page.dart';
import 'package:carrentalco/Screens/Login/login_screen.dart';
import 'package:carrentalco/Screens/Profile/profile_screen.dart';
import 'package:carrentalco/Screens/Signup/signup_screen.dart';
import 'package:carrentalco/Screens/Splash/Splash.dart';
import 'package:carrentalco/Screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final List<GetPage> routes = [
  GetPage(name: '/', page: () => const Splash()),
  GetPage(name: '/welcome', page: () => const WelcomeScreen()),
  GetPage(name: '/home', page: () => const HomePage()),
  GetPage(name: '/login', page: () => const LoginScreen()),
  GetPage(name: '/signUp', page: () => const SignUpScreen()),
  GetPage(name: '/profile', page: () => const ProfileScreen()),
  GetPage(name: '/allBrands', page: () => const AllBrands()),
  GetPage(name: '/allCars', page: () => const AllCars()),
  GetPage(name: '/dealerBookings', page: () => const ViewDealerBookings()),
  GetPage(name: '/dealerCars', page: () => const ViewDealerCars()),
  GetPage(name: '/addDealerCars', page: () => const AddDealerCars()),
  GetPage(name: '/bookings', page: () => const Bookings()),
];
