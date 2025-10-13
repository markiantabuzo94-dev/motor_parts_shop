import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../hive_service/hive_service.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DEB3),
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: const Color(0xFFB98E5F),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.ordersBox.listenable(),
        builder: (context, box, _) {
          final orders = HiveService.getOrders();
          if (orders.isEmpty) {
            return const Center(
              child: Text(
                "No orders yet.",
                style: TextStyle(color: Colors.brown),
              ),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = (order['items'] as List);
              final total = order['total'];

              return Card(
                color: const Color(0xFFE6C9A8),
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(
                    "Order #${order['id']}",
                    style: const TextStyle(color: Colors.brown),
                  ),
                  subtitle: Text(
                    "₱${total.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.brown),
                  ),
                  children: items.map((item) {
                    return ListTile(
                      leading: Image.asset(
                        item['image'],
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        item['name'],
                        style: const TextStyle(color: Colors.brown),
                      ),
                      subtitle: Text(
                        "₱${item['price']} x ${item['quantity']}",
                        style: const TextStyle(color: Colors.brown),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
