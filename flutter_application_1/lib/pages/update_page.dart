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
                    Icons.edit,
                    color: Color(0xFF674636), // Warna ikon
                  ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

class UpdateForm extends StatelessWidget {
  final menus menu;
  final VoidCallback onMenuUpdated;

  const UpdateForm({
    super.key,
    required this.menu,
    required this.onMenuUpdated,
  });

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
        backgroundColor: const Color(0xFF674636), // Warna AppBar
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Pastikan kontainer mencakup seluruh layar
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  filled: true,
                  fillColor: Color(0xFFF7EED3), // Warna field
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Menu',
                  filled: true,
                  fillColor: Color(0xFFF7EED3),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga Menu',
                  filled: true,
                  fillColor: Color(0xFFF7EED3),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar Menu',
                  filled: true,
                  fillColor: Color(0xFFF7EED3),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  filled: true,
                  fillColor: Color(0xFFF7EED3),
                  border: OutlineInputBorder(),
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAAB396), // Warna tombol
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white), // Warna teks tombol
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
