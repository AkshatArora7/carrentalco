import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carrentalco/Models/Car.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

Widget buildDealerCars({required Car carData, required Size size, required ThemeData themeData}) {
  return Center(
    child: SizedBox(
      height: size.width * 0.5,
      width: size.width,
      child: Container(
        margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
        decoration: BoxDecoration(
          color: themeData.cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.width * 0.02,
            horizontal: size.width * 0.03,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            carData.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: themeData.secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        carData.carClass,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: themeData.secondaryHeaderColor,
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: size.width * 0.2,
                      width: size.width * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: carData.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${carData.price}\$',
                      style: GoogleFonts.poppins(
                        color: themeData.secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '/per day',
                      style: GoogleFonts.poppins(
                        color: themeData.primaryColor.withOpacity(0.8),
                        // fontSize: size.width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xff3b22a1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: const Icon(
                          UniconsLine.edit_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
