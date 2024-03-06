import 'dart:io';

import 'package:carrentalco/Screens/Profile/components/buildDealerDashboard.dart';
import 'package:carrentalco/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carrentalco/Data/firebase_functions.dart';
import 'package:carrentalco/Models/LoggedInUser.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isProfileComplete = false;
  LoggedInUser? _loggedInUser;

  @override
  void initState() {
    super.initState();
    checkProfileCompletion();
    getUserData();
  }

  Future<void> checkProfileCompletion() async {
    bool isComplete = await FirebaseFunctions.isProfileComplete();
    setState(() {
      _isProfileComplete = isComplete;
    });
  }

  Future<void> getUserData() async {
    try {
      LoggedInUser loggedInUser = await FirebaseFunctions.getUserData();
      setState(() {
        _loggedInUser = loggedInUser;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: buildBottomNavBar(2, size, themeData),
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeData.backgroundColor,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseFunctions.signOut(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _loggedInUser != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: size.width * 0.25,
                      backgroundImage:
                          NetworkImage(_loggedInUser!.photoURL ?? ''),
                    ),
                    SizedBox(height: 20),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.07),
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: " +
                                  (_loggedInUser!.displayName == ""
                                      ? 'Click edit to add.'
                                      : _loggedInUser!.displayName),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Email: " +
                                  (_loggedInUser!.email == ''
                                      ? 'Click edit to add.'
                                      : _loggedInUser!.email!),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Address: " +
                                  (_loggedInUser!.address == ''
                                      ? 'Click edit to add.'
                                      : _loggedInUser!.address),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (_loggedInUser!.isDealer == true)
                              Text(
                                'You are a Car Dealer',
                                style: TextStyle(fontSize: 16),
                              )
                            else
                              SizedBox(),
                            if (_loggedInUser!.isDealer == false)
                              Text(
                                'Car Dealer Request Pending',
                                style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                              ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(UniconsLine.edit),
                                onPressed: () {
                                  _showEditProfileModal(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_loggedInUser!.isDealer == true)
                      buildDealerDashboard(size, themeData)
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _loggedInUser != null
          ? _loggedInUser!.isDealer == null
              ? FloatingActionButton.extended(
                  label: Text("Become a Car Dealer"),
                  onPressed: () {
                    !_isProfileComplete
                        ? showProfileIncompleteSnackbar(context)
                        : FirebaseFunctions.setUserAsDealer().then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Sent the request. Waiting for approval'),
                              ),
                            );
                          }).catchError((error) {
                            print('Error setting user as dealer: $error');
                          });
                  },
                  icon: Icon(UniconsLine.shop),
                )
              : null
          : null,
    );
  }

  void showProfileIncompleteSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Complete your profile to proceed.'),
      ),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    String? newName;
    String? newAddress;
    File? newImage;
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: newImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(newImage!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage("https://via.placeholder.com/150"),
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () async {
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            newImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: Text('Select Image'),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    initialValue: _loggedInUser!.displayName,
                    onChanged: (value) {
                      setState(() {
                        newName = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address'),
                    initialValue: _loggedInUser!.address,
                    onChanged: (value) {
                      setState(() {
                        newAddress = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (newImage != null &&
                          newName != null &&
                          newAddress != null) {
                        await FirebaseFunctions.uploadProfileImageAndUpdateData(
                            newAddress: newAddress!,
                            newName: newName!,
                            imageFile: newImage!);
                      }
                      Get.back();
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
