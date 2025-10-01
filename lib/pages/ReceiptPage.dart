import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  final Map<String, dynamic> order;
  const ReceiptPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = List<Map<String, dynamic>>.from(order['items']);
    final total = order['total'];

    return Scaffold(
      appBar: AppBar(title: const Text("Receipt")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order['id']}"),
            Text("Date: ${order['date']}"),
            const SizedBox(height: 16),
            const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final price = item['price'] ?? 0;
                  final qty = item['quantity'] ?? 1;
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text("₱$price x $qty"),
                    trailing: Text("₱${price * qty}"),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              "TOTAL: ₱$total",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
