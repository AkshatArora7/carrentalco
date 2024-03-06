import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carrentalco/Data/firebase_functions.dart';

class ViewDealerBookings extends StatefulWidget {
  const ViewDealerBookings({Key? key}) : super(key: key);

  @override
  State<ViewDealerBookings> createState() => _ViewDealerBookingsState();
}

class _ViewDealerBookingsState extends State<ViewDealerBookings> {
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
      backgroundColor: themeData.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: themeData.backgroundColor,
          leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: InkWell(
                onTap: () {
                  Get.back(); // Go back to the previous screen
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.cardColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.multiply,
                    color: themeData.secondaryHeaderColor,
                    size: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: const Text("CAR RENTALCO"),
          centerTitle: true,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFunctions.getDealerBookings(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No bookings found.'),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return FutureBuilder(
                  future: getCarDetails(data['carId']),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> carSnapshot) {
                    if (carSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (carSnapshot.hasError) {
                      return Text('Error: ${carSnapshot.error}');
                    }

                    if (!carSnapshot.hasData || !carSnapshot.data!.exists) {
                      return Text('Car details not found.');
                    }

                    Map<String, dynamic> carData =
                        carSnapshot.data!.data() as Map<String, dynamic>;

                    return Container(
                      margin: EdgeInsets.only(
                          bottom: size.width * 0.03,
                          right: size.width * 0.03,
                          left: size.width * 0.03),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Car Name: ${carData['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.0),
                                Text(
                                  'Price: \$${carData['price']} per day',
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Booking Time: ${_formatDate(data['time'])}',
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Start Date: ${_formatDate(data['startDate'])}',
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'End Date: ${_formatDate(data['endDate'])}',
                                ),
                              ],
                            ),
                          ),
                          if(data['status'] == 'waiting')
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('bookings')
                                              .doc(document
                                                  .id) // Use the document id to update the specific document
                                              .update({'status': 'cancel'});
                                          // Show a success message or perform any other action
                                          print(
                                              'Booking canceled successfully!');
                                        } catch (e) {
                                          // Handle any errors that occur during the update process
                                          print('Error approving booking: $e');
                                          // Show an error message or perform error handling
                                        }
                                      },
                                      child: Text("Cancel"))),
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('bookings')
                                              .doc(document
                                                  .id) // Use the document id to update the specific document
                                              .update({'status': 'approved'});
                                          // Show a success message or perform any other action
                                          print(
                                              'Booking approved successfully!');
                                        } catch (e) {
                                          // Handle any errors that occur during the update process
                                          print('Error approving booking: $e');
                                          // Show an error message or perform error handling
                                        }
                                      },
                                      child: Text("Approve")))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
