import 'package:carrentalco/components/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

Widget buildBottomNavBar(int currIndex, Size size, ThemeData themeData) {
  return BottomNavigationBar(
    iconSize: size.width * 0.07,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontSize: 0),
    unselectedLabelStyle: const TextStyle(fontSize: 0),
    currentIndex: currIndex,
    backgroundColor: const Color(0x00ffffff),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: themeData.brightness == Brightness.dark
        ? Colors.indigoAccent
        : Colors.black,
    unselectedItemColor: const Color(0xff3b22a1),
    onTap: (value) {
      if (value != currIndex) {
        if (value == 1) {
          Get.offNamed('/home');
        }else if (value == 2) {
          Get.offNamed('/profile');
        }else if (value == 3) {
          Get.offNamed('/bookings');
        }
      }
    },
    items: [
      buildBottomNavItem(
        UniconsLine.envelope,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.car,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.user,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.notes,
        themeData,
        size,
      ),
    ],
  );
}