import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../hive_service/hive_service.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  Future<void> _downloadReceipt(Map<String, dynamic> order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Order Receipt',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Order ID: ${order['id']}'),
              pw.Text('Total: ₱${order['total']}'),
              pw.SizedBox(height: 10),
              pw.Text(
                'Items:',
                style: pw.TextStyle(decoration: pw.TextDecoration.underline),
              ),
              ...((order['items'] as List).map(
                (item) => pw.Text(
                  '${item['name']} - ₱${item['price']} x ${item['quantity']}',
                ),
              )),
            ],
          );
        },
      ),
    );

    // 💾 This opens the PDF download/save dialog
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'receipt_${order['id']}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = HiveService.getOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Download Receipts"),
        backgroundColor: Colors.brown[700],
      ),
      backgroundColor: const Color(0xFFD2B48C),
      body: orders.isEmpty
          ? const Center(child: Text("No receipts available."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Colors.brown[200],
                  child: ListTile(
                    title: Text("Order #${order['id']}"),
                    subtitle: Text("₱${order['total']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.download, color: Colors.black87),
                      onPressed: () => _downloadReceipt(order),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
