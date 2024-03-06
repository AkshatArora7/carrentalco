import 'dart:io';

import 'package:carrentalco/Data/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

class AddDealerCars extends StatefulWidget {
  const AddDealerCars({Key? key}) : super(key: key);

  @override
  State<AddDealerCars> createState() => _AddDealerCarsState();
}

class _AddDealerCarsState extends State<AddDealerCars> {
  String? _selectedBag;
  String? _selectedClass;
  String? _selectedPeople;
  String? _selectedBrand;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _powerController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  File? _image;

  List<String> bagOptions = ['1-3', '4-5', '5+'];
  List<String> classOptions = ['Economy', 'Sport', 'Luxury', 'Truck'];
  List<String> peopleOptions = ['1-4', '5-6', '6+'];
  List<String> brandOptions = [];

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      QuerySnapshot brandSnapshot =
      await FirebaseFirestore.instance.collection('brands').get();

      setState(() {
        brandOptions =
            brandSnapshot.docs.map((doc) => doc['name'].toString()).toList();
      });
    } catch (error) {
      print('Error fetching brands: $error');
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
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
        leading: Padding(
          padding: EdgeInsets.only(left: size.width * 0.05),
          child: SizedBox(
            height: size.width * 0.1,
            width: size.width * 0.1,
            child: InkWell(
              onTap: () {
                Get.back();
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
        title: const Text("Add Cars"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  height: size.height * 0.25,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: _image != null
                      ? Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.add_photo_alternate),
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    // width: size.width * 0.7,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter car name',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Bag:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Select Number of Bags"),
                      value: _selectedBag,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBag = newValue;
                        });
                      },
                      items: bagOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Class:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded:true,
                      hint: Text("Select Class"),
                      value: _selectedClass,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedClass = newValue;
                        });
                      },
                      items: classOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'People:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded:true,
                      hint: Text("Select Number of people"),
                      value: _selectedPeople,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPeople = newValue;
                        });
                      },
                      items: peopleOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Power:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: TextFormField(
                      controller: _powerController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter power',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Price:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter price',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Rating:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: TextFormField(
                      controller: _placeController,
                      decoration: InputDecoration(
                        hintText: 'Enter rating',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Rating:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter rating',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Year:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter year',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    child: Text(
                      'Brand:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded:true,
                      hint: Text("Select Brand"),
                      value: _selectedBrand,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBrand = newValue;
                        });
                      },
                      items: brandOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Save car details
                  saveCarDetails();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveCarDetails() async {
    // Implement saving logic here
    print('Name: ${_nameController.text}');
    print('Bag: $_selectedBag');
    print('Class: $_selectedClass');
    print('People: $_selectedPeople');
    print('Power: ${_powerController.text}');
    print('Price: ${_priceController.text}');
    print('Rating: ${_locationController.text}');
    print('Rating: ${_placeController.text}');
    print('Year: ${_yearController.text}');
    print('Brand: $_selectedBrand');

    await FirebaseFunctions.uploadCarData(
      bag: _selectedBag!,
      people: _selectedPeople!,
      name: _nameController.text,
      classType: _selectedClass!,
      brand: _selectedBrand!,
      power: int.tryParse(_powerController.text)!,
      price: int.tryParse(_priceController.text)!,
      year: int.tryParse(_yearController.text)!,
      image: _image!,
      place: _placeController.text,
      location: _locationController.text
    );

    Get.back();
  }
}
