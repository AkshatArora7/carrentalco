import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String id;
  final String name;
  final String logoUrl;
  final List cars;

  Brand({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.cars
  });

  factory Brand.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Brand(
      id: doc.id,
      name: data['name'] ?? '',
      logoUrl: data['logo'] ?? '',
      cars: data['cars'] ?? []
    );
  }
}