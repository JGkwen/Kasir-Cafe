import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double totalPrice;

  const PaymentPage({required this.cart, required this.totalPrice, Key? key})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = 'cash';

  Future<void> saveToFirebase() async {
    try {
      // Simpan setiap item pesanan ke database
      for (var item in widget.cart) {
        await FirebaseFirestore.instance.collection('salesReport').add({
          'name': item['product'].name,
          'price': item['product'].price.toString(),
          'quantity': item['quantity'],
          'category': item['product'].category,
          'description': item['product'].description,
          'imageUrl': item['product'].imageUrl ?? '',
          'paymentMethod': selectedPaymentMethod,
          'timestamp': Timestamp.now(),
        });
      }

      // Tampilkan notifikasi jika data berhasil disimpan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan ke Firebase!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error menyimpan data: $e')),
      );
    }
  }

  void _handlePaymentCompletion(BuildContext context) async {
    await saveToFirebase(); // Simpan data ke Firebase
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Pembayaran Berhasil',
          style: TextStyle(color: Color(0xFF674636)),
        ),
        content: Text(
          'Anda telah membayar menggunakan metode: $selectedPaymentMethod',
          style: const TextStyle(color: Color(0xFF674636)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text(
              'Kembali ke Dashboard',
              style: TextStyle(color: Color(0xFFAAB396)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        centerTitle: true,
        backgroundColor: const Color(0xFF674636),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF7EED3),
              Color(0xFFF5F5DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pesanan Anda',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF674636),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cart.length,
                  itemBuilder: (context, index) {
                    final item = widget.cart[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      color: const Color(0xFFF7EED3),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFAAB396),
                          child: Text(
                            '${item['quantity']}x',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          item['product'].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF674636),
                          ),
                        ),
                        subtitle: Text(
                          'Rp ${(item['product'].price * item['quantity']).toStringAsFixed(0)}',
                          style: const TextStyle(color: Color(0xFFAAB396)),
                        ),
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
                    'Total Bayar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF674636),
                    ),
                  ),
                  Text(
                    'Rp ${widget.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAAB396),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF674636),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  items: const [
                    DropdownMenuItem(value: 'cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'debit', child: Text('Debit')),
                    DropdownMenuItem(value: 'qris', child: Text('QRIS')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _handlePaymentCompletion(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFFAAB396),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Bayar Sekarang',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
