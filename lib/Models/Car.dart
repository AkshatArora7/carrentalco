import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String companyId;
  final String name;
  final String carClass;
  final int power;
  final String people;
  final String bags;
  final String image;
  final int price;
  final bool isRotated;
  final String rating;
  final String place;
  final String location;
  final String owner;

  Car({
    required this.place,
    required this.location,
    required this.id,
    required this.companyId,
    required this.name,
    required this.carClass,
    required this.power,
    required this.people,
    required this.bags,
    required this.image,
    required this.price,
    required this.isRotated,
    required this.rating,
    required this.owner
  });

  factory Car.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Car(
      id: doc.id,
      owner: data['owner'] ?? '',
      companyId: data['companyId'] ?? '',
      name: data['name'] ?? '',
      carClass: data['class'] ?? '',
      place: data['place'] ?? '',
      location: data['location'] ?? '',
      power: data['power'] ?? 0,
      people: data['people'] ?? '',
      bags: data['bag'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0),
      isRotated: data['isRotated'] ?? false,
      rating: (data['rating'] ?? ''),
    );
  }
}
