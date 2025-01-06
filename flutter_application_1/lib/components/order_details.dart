import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final double totalPrice;
  final void Function(int index, int quantity) onUpdateQuantity;
  final void Function(int index) onRemoveItem;
  final void Function(int index, String notes) onAddNotes;
  final VoidCallback onProceedToPayment;

  const OrderDetails({
    Key? key,
    required this.cart,
    required this.totalPrice,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onAddNotes,
    required this.onProceedToPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Pesanan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF674636),
          ),
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
                    Text(
                      item['product'].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF674636),
                      ),
                    ),
                    Text(
                      'Rp ${item['product'].price}',
                      style: const TextStyle(
                        color: Color(0xFFAAB396),
                      ),
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
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Color(0xFFAAB396),
                      ),
                      onPressed: () {
                        onUpdateQuantity(index, item['quantity'] - 1);
                      },
                    ),
                    Text(
                      '${item['quantity']}',
                      style: const TextStyle(
                        color: Color(0xFF674636),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFFAAB396),
                      ),
                      onPressed: () {
                        onUpdateQuantity(index, item['quantity'] + 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.note_add,
                        color: Color(0xFF674636),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController notesController =
                                TextEditingController(
                              text: item['notes'],
                            );
                            return AlertDialog(
                              title: const Text(
                                'Tambah Catatan',
                                style: TextStyle(color: Color(0xFF674636)),
                              ),
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
                                  child: const Text(
                                    'Batal',
                                    style: TextStyle(color: Color(0xFFAAB396)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onAddNotes(index, notesController.text);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Simpan',
                                    style: TextStyle(color: Color(0xFFAAB396)),
                                  ),
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
        const Divider(color: Color(0xFFAAB396)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF674636),
              ),
            ),
            Text(
              'Rp ${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAAB396),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onProceedToPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFAAB396),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Center(
            child: Text(
              'Lanjut ke Pembayaran',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
