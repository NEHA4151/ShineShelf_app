import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import 'payment_stimulation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0; // 0: UPI, 1: Card, 2: COD, 3: Net Banking

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Delivery Address Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Deliver to:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(user?.username ?? "Guest User", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("123, ShineShelf Library Campus,\nTech City, India - 560001", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text("Mobile: +91 9876543210"),
                ],
              ),
            ),
            const Divider(thickness: 4),

            // 2. Order Summary
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 10),
                   ...cart.items.map((book) => Padding(
                     padding: const EdgeInsets.symmetric(vertical: 4),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(child: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                         Text("₹${book.price.toStringAsFixed(2)}"),
                       ],
                     ),
                   )),
                   const Divider(),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                       Text("₹${cart.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple)),
                     ],
                   )
                ],
              ),
            ),
            const Divider(thickness: 4),

            // 3. Payment Options
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Payment Options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  RadioListTile(
                    value: 0,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("UPI (Google Pay / PhonePe)"),
                    subtitle: const Text("Pay instantly via UPI"),
                    secondary: const Icon(Icons.qr_code_scanner),
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val as int),
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("Credit / Debit / ATM Card"),
                    subtitle: const Text("Visa, MasterCard, RuPay"),
                    secondary: const Icon(Icons.credit_card),
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val as int),
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("Net Banking"),
                    secondary: const Icon(Icons.account_balance),
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val as int),
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("Cash on Delivery"),
                    subtitle: const Text("Pay when you get the book"),
                    secondary: const Icon(Icons.money),
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val as int),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
        ),
        child: Row(
          children: [
             Expanded(
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("₹${cart.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   const Text("View Price Details", style: TextStyle(color: Colors.blue, fontSize: 12)),
                 ],
               ),
             ),
             Expanded(
               child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.orange,
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(vertical: 12),
                 ),
                 onPressed: () async {
                    if (_selectedPaymentMethod == 2) {
                      // COD - Skip simulation
                      cart.clearCart();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order Placed Successfully (COD)!')),
                      );
                    } else {
                      // Navigate to Payment Stimulation Screen
                      final bool? isSuccess = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentStimulationScreen(
                            paymentMethodIndex: _selectedPaymentMethod,
                            amount: cart.totalAmount,
                          ),
                        ),
                      );

                      if (isSuccess == true) {
                        cart.clearCart();
                        if (!context.mounted) return;
                        Navigator.popUntil(context, (route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment Successful! Order Placed.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (isSuccess == false) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment Failed. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                 },
                 child: const Text("Place Order"),
               ),
             )
          ],
        ),
      ),
    );
  }
}
