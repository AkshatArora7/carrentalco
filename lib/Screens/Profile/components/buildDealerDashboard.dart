import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildDealerDashboard(Size size, ThemeData themeData) {
  return Padding(
    padding: EdgeInsets.only(
      top: size.height * 0.03,
      left: size.width * 0.05,
    ),
    child: Container(
      child: Column(
        children: [
          Text(
            "Dealer Options",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: themeData.secondaryHeaderColor,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.055,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: ListTile(
              onTap: (){
                Get.toNamed("/dealerBookings");
              },
              title: Text(
                "View Bookings",
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: ListTile(
              onTap: (){
                Get.toNamed("/dealerCars");
              },
              title: Text(
                "Your Cars",
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
