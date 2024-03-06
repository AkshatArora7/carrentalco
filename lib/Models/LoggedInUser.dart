import 'package:cloud_firestore/cloud_firestore.dart';

class LoggedInUser {
  final String uid;
  final String displayName;
  final String? photoURL;
  final String? email;
  final String address;
  final bool? isDealer;

  LoggedInUser({
    required this.uid,
    required this.displayName,
    this.photoURL,
    this.email,
    required this.address,
    required this.isDealer,
  });

  factory LoggedInUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LoggedInUser(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'] ?? 'https://via.placeholder.com/150',
      email: data['email'],
      address: data['address'] ?? '',
      isDealer: data['isDealer'] ?? null,
    );
  }
}
