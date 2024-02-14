import 'package:carrentalco/Data/Routes.dart';
import 'package:carrentalco/Screens/NoPageFound/NoPageFound.dart';
import 'package:carrentalco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carrentalco/Data/themes_data.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAR RENTALCO',
      theme: lightModeTheme,
      darkTheme: darkModeTheme,
      routes: routes,
      initialRoute: '/',
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => NoPageFound(),
        );
      },
    );
  }
}