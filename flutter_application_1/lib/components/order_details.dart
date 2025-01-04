import 'package:flutter/material.dart';
import 'package:coffee_shop_kasir/pages/payment_page.dart';

class OrderDetails extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final double totalPrice;
  final void Function(int index, int quantity) onUpdateQuantity;
  final void Function(int index) onRemoveItem;
  final void Function(int index, String notes) onAddNotes;

  const OrderDetails({
    Key? key,
    required this.cart,
    required this.totalPrice,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onAddNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    if (item['notes'] != null && item['notes'].isNotEmpty)
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
                        onUpdateQuantity(index, item['quantity'] - 1);
                      },
                    ),
                    Text('${item['quantity']}'),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () {
                        onUpdateQuantity(index, item['quantity'] + 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.note_add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController notesController =
                                TextEditingController(
                              text: item['notes'],
                            );
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
                                    onAddNotes(index, notesController.text);
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
              'Rp ${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman PaymentPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(
                  cart: cart,
                  totalPrice: totalPrice,
                ),
              ),
            );
          },
          child: const Text('Lanjut ke Pembayaran'),
        ),
      ],
    );
  }
}
