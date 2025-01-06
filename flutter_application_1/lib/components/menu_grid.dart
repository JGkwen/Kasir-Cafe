import 'package:flutter/material.dart';
import '../models/product.dart';

class MenuGrid extends StatelessWidget {
  final List<menus> filteredProducts;
  final Map<String, menus> bestSellers;
  final Function(menus product) onAddToCart;

  const MenuGrid({
    Key? key,
    required this.filteredProducts,
    required this.bestSellers,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final isBestSeller = bestSellers[product.category] == product;

        return Stack(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
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
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF674636)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${product.price}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFFAAB396)),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Color(0xFFAAB396)),
                            onPressed: () => onAddToCart(product),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isBestSeller)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF674636),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Best Seller',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
