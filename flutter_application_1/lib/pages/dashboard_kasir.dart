import 'package:flutter/material.dart';
import 'package:coffee_shop_kasir/services/database_service.dart';
import '../models/product.dart';
import 'payment_page.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> category = ['coffee', 'non-coffee', 'food', 'snack'];
  List<menus> products = [];
  List<menus> filteredProducts = [];
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> cart = [];
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      final querySnapshot = await _databaseService.getMenus();
      setState(() {
        products = querySnapshot;
        filteredProducts = products;
      });
    } catch (e) {
      print("Error fetching menus: $e");
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      GoRouter.of(context).go('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat logout: $e')),
      );
    }
  }

  void addToCart(menus product) {
    setState(() {
      cart.add({'product': product, 'quantity': 1});
    });
  }

  double getTotalPrice() {
    return cart.fold(
        0, (total, item) => total + (item['product'].price * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Myth Cafe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Panggil fungsi logout
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: category.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = selected ? cat : 'All';
                          filteredProducts = selectedCategory == 'All'
                              ? products
                              : products
                                  .where((product) => product.category == cat)
                                  .toList();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              product.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                product.description,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${product.price}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.orange),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle,
                                      color: Colors.orange),
                                  onPressed: () => addToCart(product),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Pesanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['product'].name),
                              Text(
                                'Rp ${item['product'].price}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (item['notes'] != null &&
                                  item['notes'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Catatan: ${item['notes']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    if (item['quantity'] > 1) {
                                      item['quantity'] -= 1;
                                    } else {
                                      cart.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: () {
                                  setState(() {
                                    item['quantity'] += 1;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.note_add,
                                    color: Colors.grey),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController notesController =
                                          TextEditingController(
                                              text: item['notes']);
                                      return AlertDialog(
                                        title: const Text('Tambah Catatan'),
                                        content: TextField(
                                          controller: notesController,
                                          decoration: const InputDecoration(
                                            hintText: 'Masukkan catatan',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                item['notes'] =
                                                    notesController.text;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Simpan'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${getTotalPrice().toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            cart: cart, // Kirim data pesanan
                            totalPrice: getTotalPrice(), // Kirim total harga
                          ),
                        ),
                      );
                    },
                    child: const Text('Lanjut ke Pembayaran'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
