import 'dart:io';

import 'package:carrentalco/Models/Brand.dart';
import 'package:carrentalco/Models/Car.dart';
import 'package:carrentalco/Models/LoggedInUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseFunctions {
  static void SignUp(String email, String password, BuildContext context) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'email': email, 'password': password}).then((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }).catchError((error) {
      print("Failed to sign up: $error");
    });
  }

  static void Login(String email, String password, BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((error) {
      print("Failed to sign in: $error");
    });
  }

  static void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    }).catchError((error) {
      print("Failed to sign out: $error");
    });
  }

  static Future<LoggedInUser> getUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Create LoggedInUser object from the document data
      LoggedInUser user = LoggedInUser.fromFirestore(userSnapshot);
      return user;
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Car>> getCarsFromFirestore({int limit = 0}) async {
    List<Car> cars = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = limit == 0
        ? await FirebaseFirestore.instance.collection('cars').get()
        : await FirebaseFirestore.instance
            .collection('cars')
            .limit(limit)
            .get();

    snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      cars.add(Car.fromFirestore(doc));
    });

    return cars;
  }

  static Future<List<Brand>> getBrands({int limit = 0}) async {
    List<Brand> brands = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = limit == 0
        ? await FirebaseFirestore.instance.collection('brands').get()
        : await FirebaseFirestore.instance
            .collection('brands')
            .limit(limit)
            .get();

    querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      brands.add(Brand.fromFirestore(doc));
    });

    return brands;
  }

  static Future<bool> isProfileComplete() async {
    try {
      // Get current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get user document from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if profile information is complete
      bool isProfileComplete = userSnapshot.get('displayName') != null &&
          userSnapshot.get('photoURL') != null &&
          userSnapshot.get('address') != null &&
          userSnapshot.get('displayName').isNotEmpty &&
          userSnapshot.get('photoURL').isNotEmpty &&
          userSnapshot.get('address').isNotEmpty;

      return isProfileComplete;
    } catch (error) {
      throw error;
    }
  }

  static Future<void> setUserAsDealer() async {
    try {
      // Get current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update user's document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isDealer': false, // Set the isDealer flag to true
      });
    } catch (error) {
      throw error;
    }
  }

  static Future<void> uploadProfileImageAndUpdateData(
      {required File imageFile,
      required String newName,
      required String newAddress}) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String imageURL = await _uploadImageToStorage(imageFile, userId);

      await _updateUserData(
          imageURL: imageURL,
          newName: newName,
          newAddress: newAddress,
          uid: userId);
    } catch (error) {
      throw error;
    }
  }

  static Future<String> _uploadImageToStorage(
      File imageFile, String userID) async {
    try {
      String filePath = 'profile_images/$userID/${imageFile.path}';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (error) {
      throw error;
    }
  }

  static Future<void> _updateUserData(
      {required String newName,
      required String newAddress,
      required String uid,
      required String imageURL}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'displayName': newName,
        'address': newAddress,
        'photoURL': imageURL,
      });
    } catch (error) {
      throw error;
    }
  }

  static Future<void> uploadCarData(
      {required String name,
      required String bag,
      required String classType,
      required String people,
      required int power,
      required int price,
      required int year,
      required String brand,
      required File image,
      required String place,
      required String location}) async {
    try {
      // Get current user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
        var ref = FirebaseStorage.instance
            .ref()
            .child('car_images/${userId}/$imageFileName');

        await ref.putFile(image);

        // Get download URL of the uploaded image
        String imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('cars').add({
          'owner': userId,
          'name': name,
          'bag': bag,
          'class': classType,
          'people': people,
          'power': power,
          'price': price,
          'year': year,
          'brand': brand,
          'image': imageUrl,
          'place': place,
          'location': location
        });
        // Car data saved successfully
        print('Car data uploaded successfully');
      } else {
        // User is not logged in
        print('User is not logged in');
      }
    } catch (error) {
      // Error occurred while uploading car data
      print('Error uploading car data: $error');
    }
  }

  static Future<void> uploadBookingData({
    required DateTime startDate,
    required DateTime endDate,
    required String carId,
    required String ownerId
  }) async {
    try {
      // Get a reference to the Firestore database
      final firestore = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Add a new document with a generated ID to the "bookings" collection
      await firestore.collection('bookings').add({
        'startDate': startDate,
        'endDate': endDate,
        "carId": carId,
        'userId': userId,
        'time': DateTime.now(),
        'ownerId': ownerId,
        'status': 'waiting'
      });

      print('Booking data uploaded successfully!');
    } catch (e) {
      print('Error uploading booking data: $e');
      // Handle error as needed
    }
  }

  static Stream<QuerySnapshot<Object?>> getDealerBookings() {
    try {
      String ownerId = FirebaseAuth.instance.currentUser!.uid;
      return FirebaseFirestore.instance
          .collection('bookings')
          .where('ownerId', isEqualTo: ownerId)
          .snapshots();
    } catch (e) {
      print('Error getting dealer bookings: $e');
      throw e;
    }
  }
}
