import 'package:carrentalco/Data/cars.dart';
import 'package:carrentalco/Data/firebase_functions.dart';
import 'package:carrentalco/Models/Car.dart';
import '../components/car.dart';
import '../components/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildMostRented(Size size, ThemeData themeData) {
  return Column(
    children: [
      buildCategory('Most Rented', size, themeData, '/allCars'),
      Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.015,
          left: size.width * 0.03,
          right: size.width * 0.03,
        ),
        child: FutureBuilder<List<Car>>(
          future: FirebaseFunctions.getCarsFromFirestore(limit: 3), // Use your method to fetch cars from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Car> cars = snapshot.data!;
              return SizedBox(
                height: size.width * 0.55,
                width: cars.length * size.width * 0.5 * 1.03,
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    return buildCar(
                      size: size,
                      themeData: themeData,
                      carData: cars[index], // Pass car data to buildCar method
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    ],
  );
}
