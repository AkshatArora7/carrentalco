import 'package:carrentalco/Screens/DetailsPage/details_page.dart';
import 'package:carrentalco/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carrentalco/Data/firebase_functions.dart';
import 'package:carrentalco/Models/Car.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Car>> _futureCars;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCars = FirebaseFunctions.getCarsFromFirestore();
  }

  void _filterCars(String query, List<Car> cars) {
    setState(() {
      _futureCars = FirebaseFunctions.getCarsFromFirestore().then((cars) {
        return cars.where((car) => car.name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: buildBottomNavBar(0, size, themeData),
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (query) => _filterCars(query, []),
              decoration: InputDecoration(
                labelText: 'Search cars...',
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Car>>(
                future: _futureCars,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No cars found.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final car = snapshot.data![index];
                        return ListTile(
                          title: Text(car.name),
                          subtitle: Text(car.carClass),
                          onTap: () {
                            Get.to(() => DetailsPage(
                              car: car,
                            ));
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
