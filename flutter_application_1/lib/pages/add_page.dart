import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatelessWidget {
  final VoidCallback onMenuAdded;

  const AddPage({super.key, required this.onMenuAdded});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    String selectedCategory = 'coffee'; // Default category

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Menu'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi Menu'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga Menu'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar Menu'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: const [
                  DropdownMenuItem(value: 'coffee', child: Text('Coffee')),
                  DropdownMenuItem(
                      value: 'non-coffee', child: Text('Non-Coffee')),
                  DropdownMenuItem(value: 'food', child: Text('Food')),
                  DropdownMenuItem(value: 'snack', child: Text('Snack')),
                ],
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      imageUrlController.text.isNotEmpty &&
                      selectedCategory.isNotEmpty) {
                    await FirebaseFirestore.instance.collection('menus').add({
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'price': int.parse(priceController.text),
                      'imageUrl': imageUrlController.text,
                      'category': selectedCategory,
                    });
                    onMenuAdded();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
