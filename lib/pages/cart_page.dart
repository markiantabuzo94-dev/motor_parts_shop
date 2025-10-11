// lib/pages/cart_page.dart
import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';
import 'order_history_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    setState(() {
      cart = HiveService.getCart();
    });
  }

  double _computeTotal() {
    double total = 0;
    for (var item in cart) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final qty = (item['quantity'] as int?) ?? 1;
      total += price * qty;
    }
    return total;
  }

  Future<void> _checkout() async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty'),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    await HiveService.checkout();
    _loadCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout successful!'),
        backgroundColor: Colors.black87,
      ),
    );

    // Optional: After checkout, navigate to Order History
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder if you want live updates when Hive changes.
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: cart.isEmpty
                  ? const Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        final qty = item['quantity'] ?? 1;

                        return Card(
                          color: Colors.grey[850],
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: Image.asset(
                              item['image'] ?? 'assets/images/helmet.webp',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/helmet.webp',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['name'] ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "₱${item['price']} x $qty",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (qty > 1) {
                                      await HiveService.updateCartItem(
                                        item['name'],
                                        qty - 1,
                                      );
                                      _loadCart();
                                    }
                                  },
                                ),
                                Text(
                                  "$qty",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await HiveService.updateCartItem(
                                      item['name'],
                                      qty + 1,
                                    );
                                    _loadCart();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    await HiveService.removeFromCart(
                                      item['name'],
                                    );
                                    _loadCart();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Total + Checkout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total: ₱${_computeTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                    ),
                    onPressed: _checkout,
                    child: const Text("Checkout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
