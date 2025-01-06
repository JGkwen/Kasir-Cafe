import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class DeletePage extends StatelessWidget {
  final VoidCallback onMenuDeleted;
  final List<menus> products;

  const DeletePage(
      {super.key, required this.onMenuDeleted, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hapus Menu'),
        backgroundColor: const Color(0xFF674636), // Warna latar AppBar
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF7EED3), // Gradasi atas
              Color(0xFFF5F5DC), // Gradasi bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final menu = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              color: const Color(0xFFF7EED3), // Warna latar belakang kartu
              child: ListTile(
                title: Text(
                  menu.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF674636), // Warna teks
                  ),
                ),
                subtitle: Text(
                  'Rp ${menu.price}',
                  style: const TextStyle(
                    color: Color(0xFFAAB396), // Warna subtitle
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xFF674636), // Warna ikon
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('menus')
                        .doc(menu.id)
                        .delete();
                    onMenuDeleted();
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
