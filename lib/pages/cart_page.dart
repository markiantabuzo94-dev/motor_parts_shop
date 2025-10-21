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
          backgroundColor: Colors.brown,
        ),
      );
      return;
    }

    await HiveService.checkout();
    _loadCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout successful!'),
        backgroundColor: Colors.brown,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightBrown = const Color(0xFFD2B48C);
    final darkerBrown = const Color(0xFF8B7355);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: darkerBrown,
      ),
      backgroundColor: lightBrown,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: cart.isEmpty
                  ? const Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
                  : ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        final qty = item['quantity'] ?? 1;

                        return Card(
                          color: Colors.brown[200],
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item['image'] ?? 'assets/images/helmet.webp',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['name'] ?? '',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "₱${item['price']} x $qty",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.black87,
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
                                  style: const TextStyle(color: Colors.black),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.black87,
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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.brown[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total: ₱${_computeTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkerBrown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
