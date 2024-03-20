import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carrentalco/components/bottom_nav_bar.dart';
import 'package:unicons/unicons.dart';

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<DocumentSnapshot> getCarDetails(String carId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot carSnapshot =
          await firestore.collection('cars').doc(carId).get();

      // Return the car document snapshot
      return carSnapshot;
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting car details: $e');
      throw e; // Rethrow the error to handle it in the calling function
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: themeData.backgroundColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leadingWidth: size.width * 0.15,
        title: const Text("Car RentalCo"),
        centerTitle: true,
      ),
      bottomNavigationBar: buildBottomNavBar(3, size, themeData),
      backgroundColor: themeData.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Your Bookings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Stream builder to fetch booking data
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No bookings found.');
                  }

                  return Column(
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return FutureBuilder<DocumentSnapshot>(
                        future: getCarDetails(data['carId']),
                        builder: (context, carSnapshot) {
                          if (carSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if (carSnapshot.hasError) {
                            return Text('Error: ${carSnapshot.error}');
                          }

                          if (!carSnapshot.hasData) {
                            return Text('Car details not found.');
                          }

                          Map<String, dynamic> carData =
                              carSnapshot.data!.data() as Map<String, dynamic>;

                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              'Car: ${carData['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.0),
                                Text(
                                  'Price: \$${carData['price']} per day',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Booking Time: ${_formatDate(data['time'])}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Start Date: ${_formatDate(data['startDate'])}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'End Date: ${_formatDate(data['endDate'])}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            trailing: data['status'] == "waiting"
                                ? Icon(UniconsLine.clock, color: Colors.amber,)
                                : data['status'] == "approved"
                                    ? Icon(UniconsLine.thumbs_up, color: Colors.green,)
                                    : Icon(UniconsLine.thumbs_down, color: Colors.red,),
                            // onTap: () {
                            //   // Add onTap functionality if needed
                            // },
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
