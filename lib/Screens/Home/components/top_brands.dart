import 'package:carrentalco/Data/firebase_functions.dart';
import 'package:carrentalco/Models/Brand.dart';
import '../components/brand_logo.dart';
import '../components/category.dart';
import 'package:flutter/material.dart';

Column buildTopBrands(Size size, ThemeData themeData) {
  return Column(
    children: [
      buildCategory('Top Brands', size, themeData, '/allBrands'),
      Padding(
        padding: EdgeInsets.only(top: size.height * 0.015),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: size.width * 0.16),
          child: FutureBuilder<List<Brand>>(
            future: FirebaseFunctions.getBrands(limit: 4),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Brand> brands = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    return buildBrandLogo(
                      Image.asset(
                        brands[index].logoUrl,
                        height: size.width * 0.1,
                        width: size.width * 0.15,
                        fit: BoxFit.fill,
                      ),
                      size,
                      themeData,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    ],
  );
}