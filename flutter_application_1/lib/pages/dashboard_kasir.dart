import 'package:flutter/material.dart';
import 'package:coffee_shop_kasir/components/order_details.dart';
import 'package:coffee_shop_kasir/services/database_service.dart';
import '../models/product.dart';
import 'package:go_router/go_router.dart';

class KasirDashboard extends StatefulWidget {
  const KasirDashboard({super.key});

  @override
  State<KasirDashboard> createState() => _CashierDashboardState();
}

class _CashierDashboardState extends State<KasirDashboard> {
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

  void addToCart(menus product) {
    setState(() {
      cart.add({'product': product, 'quantity': 1, 'notes': ''});
    });
  }

  double getTotalPrice() {
    return cart.fold(
        0, (total, item) => total + (item['product'].price * item['quantity']));
  }

  void logout(BuildContext context) {
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Myth Cafe - Kasir'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
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
              child: OrderDetails(
                cart: cart,
                totalPrice: getTotalPrice(),
                onUpdateQuantity: (index, quantity) {
                  setState(() {
                    if (quantity > 0) {
                      cart[index]['quantity'] = quantity;
                    } else {
                      cart.removeAt(index);
                    }
                  });
                },
                onRemoveItem: (index) {
                  setState(() {
                    cart.removeAt(index);
                  });
                },
                onAddNotes: (index, notes) {
                  setState(() {
                    cart[index]['notes'] = notes;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
