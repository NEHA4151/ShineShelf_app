import 'package:flutter/material.dart';
import 'dart:async';

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
  
  // Timer for UPI
  int _timeLeft = 120;
  Timer? _timer;

  // Net Banking State
  int _netBankingStep = 0; 
  String? _selectedBank;
  final TextEditingController _otpController = TextEditingController();

  // Card State
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startAutoSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _startAutoSimulation() {
    if (widget.paymentMethodIndex == 0) {
      // UPI
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            timer.cancel();
            _simulatePayment(true);
          }
        });
      });
    } else if (widget.paymentMethodIndex == 3 || widget.paymentMethodIndex == 1) {
      // Net Banking or Card - wait for UI interactions
    } else {
      // Card / Other
      setState(() {
        _isProcessing = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) _simulatePayment(true);
      });
    }
  }

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

    // Brief transition delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    Navigator.pop(context, isSuccess);
  }

  Widget _buildUPIUI() {
    return Column(
      children: [
        const Text("Scan QR Code to Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        const Icon(Icons.qr_code_2, size: 200), // Sample QR Code
        const SizedBox(height: 20),
        const Text("Awaiting payment completion...", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
        Text("Automatically verifying in $_timeLeft seconds", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCardUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter Card Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        TextField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          maxLength: 16,
          decoration: const InputDecoration(
            labelText: "Card Number",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryController,
                keyboardType: TextInputType.datetime,
                maxLength: 5,
                decoration: const InputDecoration(
                  labelText: "Expiry (MM/YY)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "PIN / CVV",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
               backgroundColor: Colors.green,
               foregroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              if (_cardNumberController.text.isNotEmpty && 
                  _expiryController.text.isNotEmpty && 
                  _pinController.text.isNotEmpty) {
                 _simulatePayment(true);
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Please fill all card details')),
                 );
              }
            },
            child: const Text("PAY FAST & SECURE"),
          ),
        )
      ],
    );
  }

  Widget _buildNetBankingUI() {
    if (_netBankingStep == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Redirecting to your banking page...", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedBank,
            decoration: const InputDecoration(
              labelText: "Choose Bank",
              border: OutlineInputBorder(),
            ),
            items: ["State Bank of India", "HDFC Bank", "ICICI Bank", "Axis Bank"]
                .map((bank) => DropdownMenuItem(value: bank, child: Text(bank)))
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedBank = val;
              });
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.deepPurple,
                 foregroundColor: Colors.white,
                 padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _selectedBank == null ? null : () {
                setState(() {
                  _netBankingStep = 1;
                });
              },
              child: const Text("PROCEED"),
            ),
          )
        ],
      );
    } else if (_netBankingStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome to $_selectedBank Secure Login", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          const Text("Enter OTP sent to your registered mobile number", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: "Enter 6-digit OTP",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.green,
                 foregroundColor: Colors.white,
                 padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (_otpController.text.length == 6) {
                   setState(() {
                     _netBankingStep = 2; // Processing
                   });
                   _simulatePayment(true);
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
                   );
                }
              },
              child: const Text("SUBMIT OTP & PAY"),
            ),
          )
        ],
      );
    } else {
      return const SizedBox(); // Covered by _isProcessing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment: $_paymentMethodName"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isProcessing && widget.paymentMethodIndex != 0) 
                Icon(_paymentIcon, size: 80, color: Colors.deepPurple),
              if (!_isProcessing && widget.paymentMethodIndex != 0) 
                 const SizedBox(height: 24),
              const Text(
                "Transaction Amount",
                style: TextStyle(fontSize: 18, color: Colors.grey),
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
                    Text("Processing your payment safely...", style: TextStyle(fontSize: 16)),
                  ],
                )
              else if (widget.paymentMethodIndex == 0)
                _buildUPIUI()
              else if (widget.paymentMethodIndex == 1)
                _buildCardUI()
              else if (widget.paymentMethodIndex == 3)
                _buildNetBankingUI()
              else
                const Column(
                  children: [
                    Text("Securely processing your payment...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              const SizedBox(height: 48),
              const Text(
                "Secured by ShineShelf Payment Gateway",
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
