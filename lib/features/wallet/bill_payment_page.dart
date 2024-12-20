import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const PaymentDetailsPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Bill Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Information
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.subscriptions, color: Colors.red, size: 32),
              ),
              title: Text(
                transaction['title'] ?? 'Service Name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                transaction['date'] ?? 'Date',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),

            // Price Details
            _buildPriceRow("Price", transaction['price'] ?? "\$0.00"),
            const SizedBox(height: 8),
            _buildPriceRow("Fee", transaction['fee'] ?? "\$0.00"),
            const SizedBox(height: 8),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            _buildPriceRow("Total", transaction['amount'] ?? "\$0.00",
                isBold: true),

            const SizedBox(height: 24),

            // Payment Method Section
            const Text(
              "Select payment method",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Debit Card
            _buildPaymentMethod(
                context, "Debit Card", Icons.credit_card, true),

            const SizedBox(height: 8),

            // PayPal
            _buildPaymentMethod(
                context, "Paypal", Icons.paypal, false),

            const Spacer(),

            // Pay Now Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Handle payment action here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Payment Successful!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                "Pay Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(
      BuildContext context, String method, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Handle payment method selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.withOpacity(0.1) : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.teal : Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.teal : Colors.grey, size: 24),
            const SizedBox(width: 16),
            Text(
              method,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.teal : Colors.grey[700],
              ),
            ),
            const Spacer(),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? Colors.teal : Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
