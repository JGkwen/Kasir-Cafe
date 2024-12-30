import 'package:cloud_firestore/cloud_firestore.dart';

class menus {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String filter;

  // Constructor
  menus({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.filter,
  });

  // Menyimpan data dari Firestore ke dalam objek Menu
  factory menus.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map; // Mendapatkan data dari document
    return menus(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      filter: data['filter'] ?? '',
    );
  }

  // Mengonversi objek Menu ke dalam bentuk Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'filter': filter,
    };
  }
}
