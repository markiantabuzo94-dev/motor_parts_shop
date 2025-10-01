// lib/pages/cart_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../hive_service/hive_service.dart';
import 'order_history_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: ValueListenableBuilder(
        valueListenable: Hive.box('cart').listenable(),
        builder: (context, box, _) {
          final cart = HiveService.getCart();

          if (cart.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          double total = 0;
          for (var item in cart) {
            final price = (item['price'] as num?)?.toDouble() ?? 0.0;
            final qty = (item['quantity'] as int?) ?? 1;
            total += price * qty;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    final qty = item['quantity'] ?? 1;

                    return Card(
                      color: Colors.grey[850],
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Image.asset(
                          item['image'] ?? 'assets/images/helmet.webp',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
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
                                }
                              },
                            ),
                            Text(
                              "$qty",
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () async {
                                await HiveService.updateCartItem(
                                  item['name'],
                                  qty + 1,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await HiveService.removeFromCart(item['name']);
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
                color: Colors.grey[850],
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₱${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                      ),
                      onPressed: () async {
                        await HiveService.checkout(); // save orders + clear cart
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Checkout successful!")),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderHistoryPage(),
                          ),
                        );
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
