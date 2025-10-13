import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = 'GCash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2B48C), // 🟤 same as homepage
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB99976), // 🟤 same as homepage AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Payment options
            _buildPaymentOption("GCash", Icons.phone_android),
            _buildPaymentOption("PayMaya", Icons.account_balance_wallet),
            _buildPaymentOption("Cash on Delivery", Icons.local_shipping),

            const SizedBox(height: 30),

            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5E4C3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: const Text(
                  "Total Amount",
                  style: TextStyle(color: Colors.brown),
                ),
                trailing: Text(
                  "₱3,500.00",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade400,
                  ),
                ),
              ),
            ),

            const Spacer(),

            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Processing payment via $selectedMethod...",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
                icon: const Icon(Icons.payment, color: Colors.white),
                label: const Text(
                  "Proceed to Pay",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    return Card(
      color: const Color(0xFFF5E4C3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          method,
          style: const TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Radio<String>(
          activeColor: Colors.deepPurple,
          value: method,
          groupValue: selectedMethod,
          onChanged: (value) => setState(() => selectedMethod = value!),
        ),
      ),
    );
  }
}
