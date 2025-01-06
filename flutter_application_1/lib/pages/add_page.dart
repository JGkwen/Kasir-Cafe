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
        backgroundColor: const Color(0xFF674636), // Warna AppBar
      ),
      body: Container(
        width: double.infinity,
        height:
            double.infinity, // Pastikan latar belakang menutupi seluruh layar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF7EED3), // Warna gradasi atas
              Color(0xFFF5F5DC), // Warna gradasi bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Menu',
                    labelStyle:
                        TextStyle(color: Color(0xFF674636)), // Warna label
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAAB396)), // Warna border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF674636)), // Warna fokus
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Menu',
                    labelStyle:
                        TextStyle(color: Color(0xFF674636)), // Warna label
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAAB396)), // Warna border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF674636)), // Warna fokus
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga Menu',
                    labelStyle:
                        TextStyle(color: Color(0xFF674636)), // Warna label
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAAB396)), // Warna border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF674636)), // Warna fokus
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar Menu',
                    labelStyle:
                        TextStyle(color: Color(0xFF674636)), // Warna label
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAAB396)), // Warna border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF674636)), // Warna fokus
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    labelStyle:
                        TextStyle(color: Color(0xFF674636)), // Warna label
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAAB396)), // Warna border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF674636)), // Warna fokus
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'coffee',
                        child: Text('Coffee',
                            style: TextStyle(color: Color(0xFF674636)))),
                    DropdownMenuItem(
                        value: 'non-coffee',
                        child: Text('Non-Coffee',
                            style: TextStyle(color: Color(0xFF674636)))),
                    DropdownMenuItem(
                        value: 'food',
                        child: Text('Food',
                            style: TextStyle(color: Color(0xFF674636)))),
                    DropdownMenuItem(
                        value: 'snack',
                        child: Text('Snack',
                            style: TextStyle(color: Color(0xFF674636)))),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAAB396), // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Warna teks tombol
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
