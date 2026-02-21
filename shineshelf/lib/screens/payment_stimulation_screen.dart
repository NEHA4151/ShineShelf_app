import 'package:flutter/material.dart';

class PaymentStimulationScreen extends StatefulWidget {
  final int paymentMethodIndex; // 0: UPI, 1: Card, 2: COD, 3: Net Banking
  final double amount;

  const PaymentStimulationScreen({
    super.key,
    required this.paymentMethodIndex,
    required this.amount,
  });

  @override
  State<PaymentStimulationScreen> createState() => _PaymentStimulationScreenState();
}

class _PaymentStimulationScreenState extends State<PaymentStimulationScreen> {
  bool _isProcessing = false;

  String get _paymentMethodName {
    switch (widget.paymentMethodIndex) {
      case 0:
        return "UPI (Google Pay / PhonePe)";
      case 1:
        return "Credit / Debit Card";
      case 2:
        return "Cash on Delivery";
      case 3:
        return "Net Banking";
      default:
        return "Payment Gateway";
    }
  }

  IconData get _paymentIcon {
    switch (widget.paymentMethodIndex) {
      case 0:
        return Icons.qr_code_scanner;
      case 1:
        return Icons.credit_card;
      case 2:
        return Icons.money;
      case 3:
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  void _simulatePayment(bool isSuccess) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    Navigator.pop(context, isSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Simulator: $_paymentMethodName"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_paymentIcon, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 24),
              Text(
                "Transaction Amount",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              Text(
                "₹${widget.amount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              if (_isProcessing)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Processing your payment...", style: TextStyle(fontSize: 16)),
                  ],
                )
              else
                Column(
                  children: [
                    const Text(
                      "Simulation Controls",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _simulatePayment(true),
                        child: const Text("SIMULATE SUCCESS", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _simulatePayment(false),
                        child: const Text("SIMULATE FAILURE", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              const Spacer(),
              const Text(
                "This is a sandbox environment for testing payment integrations.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
