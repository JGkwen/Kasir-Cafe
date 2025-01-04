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
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final menu = products[index];
          return ListTile(
            title: Text(menu.name),
            subtitle: Text('Rp ${menu.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('menus')
                    .doc(menu.id)
                    .delete();
                onMenuDeleted();
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
