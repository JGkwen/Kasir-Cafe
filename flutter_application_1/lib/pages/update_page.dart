import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class UpdatePage extends StatelessWidget {
  final VoidCallback onMenuUpdated;
  final List<menus> products;

  const UpdatePage(
      {super.key, required this.onMenuUpdated, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Menu'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final menu = products[index];
          return ListTile(
            title: Text(menu.name),
            subtitle: Text('Rp ${menu.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateForm(
                      menu: menu,
                      onMenuUpdated: onMenuUpdated,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class UpdateForm extends StatelessWidget {
  final menus menu;
  final VoidCallback onMenuUpdated;

  const UpdateForm(
      {super.key, required this.menu, required this.onMenuUpdated});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: menu.name);
    final TextEditingController descriptionController =
        TextEditingController(text: menu.description);
    final TextEditingController priceController =
        TextEditingController(text: menu.price.toString());
    final TextEditingController imageUrlController =
        TextEditingController(text: menu.imageUrl);
    String selectedCategory = menu.category;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Menu'),
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
                    await FirebaseFirestore.instance
                        .collection('menus')
                        .doc(menu.id)
                        .update({
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'price': int.parse(priceController.text),
                      'imageUrl': imageUrlController.text,
                      'category': selectedCategory,
                    });
                    onMenuUpdated();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
