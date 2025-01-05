import 'package:flutter/material.dart';
import 'package:coffee_shop_kasir/components/order_details.dart';
import 'package:coffee_shop_kasir/components/category_selector.dart';
import 'package:coffee_shop_kasir/components/menu_grid.dart';
import 'package:coffee_shop_kasir/pages/payment_page.dart';
import 'package:coffee_shop_kasir/services/database_service.dart';
import '../models/product.dart';
import 'package:go_router/go_router.dart';

class KasirDashboard extends StatefulWidget {
  const KasirDashboard({super.key});

  @override
  State<KasirDashboard> createState() => _KasirDashboardState();
}

class _KasirDashboardState extends State<KasirDashboard> {
  List<String> category = ['coffee', 'non-coffee', 'food', 'snack'];
  List<menus> products = [];
  List<menus> filteredProducts = [];
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> cart = [];
  final DatabaseService _databaseService = DatabaseService();

  Map<String, menus> bestSellers = {}; // Menyimpan best seller per kategori

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
        _calculateBestSellers(); // Kalkulasi best seller
        filteredProducts = products;
      });
    } catch (e) {
      print("Error fetching menus: $e");
    }
  }

  void _calculateBestSellers() {
    for (String cat in category) {
      final filtered = products.where((menu) => menu.category == cat).toList();
      if (filtered.isNotEmpty) {
        filtered.sort((a, b) => b.sales.compareTo(a.sales));
        bestSellers[cat] = filtered.first;
      }
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

  void _goToPaymentPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentPage(cart: cart, totalPrice: getTotalPrice()),
      ),
    );

    if (result == true) {
      _fetchMenus(); // Refresh data
      setState(() {
        cart.clear(); // Kosongkan detail pesanan
      });
    }
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
          child: CategorySelector(
            categories: category,
            selectedCategory: selectedCategory,
            onCategorySelected: (cat) {
              setState(() {
                selectedCategory = cat;
                filteredProducts = selectedCategory == 'All'
                    ? products
                    : products
                        .where((product) => product.category == cat)
                        .toList();
              });
            },
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MenuGrid(
                filteredProducts: filteredProducts,
                bestSellers: bestSellers,
                onAddToCart: addToCart,
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
                onProceedToPayment: () => _goToPaymentPage(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
