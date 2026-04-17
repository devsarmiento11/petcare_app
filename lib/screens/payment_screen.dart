import 'package:flutter/material.dart';
import '../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  bool _isLoading = false;
  
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers for card details
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  
  // Booking data (received from booking screen)
  String _serviceName = 'Grooming';
  String _petName = 'Max';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  double _subtotal = 50.0;
  final double _serviceFee = 5.0;
  
  // Service prices
  static const Map<String, double> _servicePrices = {
    'Grooming': 50.0,
    'Veterinary Checkup': 80.0,
    'Vaccination': 45.0,
    'Dental Care': 100.0,
    'Training Session': 60.0,
    'Pet Hotel': 75.0,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBookingData();
  }

  void _loadBookingData() {
    // Try to get booking data from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      setState(() {
        _serviceName = args['service'] ?? 'Grooming';
        _petName = args['pet'] ?? 'Max';
        _selectedDate = args['date'] ?? DateTime.now();
        _selectedTime = args['time'] ?? TimeOfDay.now();
        _subtotal = _servicePrices[_serviceName] ?? 50.0;
      });
    }
  }

  double get _total => _subtotal + _serviceFee;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _processPayment() async {
    // Validate form if credit card is selected
    if (_selectedPaymentMethod == 'Credit Card') {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare payment details
      final paymentDetails = <String, dynamic>{};
      
      if (_selectedPaymentMethod == 'Credit Card') {
        paymentDetails['cardNumber'] = _cardNumberController.text.trim();
        paymentDetails['expiryDate'] = _expiryDateController.text.trim();
        paymentDetails['cvv'] = _cvvController.text.trim();
        paymentDetails['cardholderName'] = _cardholderNameController.text.trim();
      }

      // Process payment using PaymentService
      final paymentService = PaymentService();
      final success = await paymentService.processPayment(
        amount: _total,
        paymentMethod: _selectedPaymentMethod,
        paymentDetails: paymentDetails,
      );

      if (mounted) {
        if (success) {
          _showSuccessDialog();
        } else {
          _showErrorDialog('Payment failed. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('An error occurred: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text(
          'Your appointment has been booked successfully!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number';
    }
    final cleaned = value.replaceAll(RegExp(r'\s'), '');
    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Please enter a valid card number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Card number must contain only digits';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiry date';
    }
    // Format: MM/YY
    final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter valid date (MM/YY)';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    }
    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'CVV must contain only digits';
    }
    return null;
  }

  String? _validateCardholderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter cardholder name';
    }
    if (value.length < 2) {
      return 'Please enter a valid name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSummaryRow('Service', _serviceName),
                      _buildSummaryRow('Pet', _petName),
                      _buildSummaryRow('Date', _formatDate(_selectedDate)),
                      _buildSummaryRow('Time', _formatTime(_selectedTime)),
                      const Divider(height: 24),
                      _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
                      _buildSummaryRow('Service Fee', '\$${_serviceFee.toStringAsFixed(2)}'),
                      const Divider(height: 24),
                      _buildSummaryRow('Total', '\$${_total.toStringAsFixed(2)}', isBold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
  Column(
                children: [
                  _buildPaymentOption(
                    'Credit Card',
                    Icons.credit_card,
                    '**** **** **** 4242',
                  ),
                  _buildPaymentOption(
                    'PayPal',
                    Icons.payment,
                    'user@email.com',
                  ),
                  _buildPaymentOption(
                    'Apple Pay',
                    Icons.apple,
                    'Pay with Apple Pay',
                  ),
                  _buildPaymentOption(
                    'Cash on Delivery',
                    Icons.money,
                    'Pay when service is provided',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Card Details (shown when credit card is selected)
              if (_selectedPaymentMethod == 'Credit Card') ...[
                const Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234 5678 9012 3456',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateCardNumber,
                  maxLength: 19,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryDateController,
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: _validateExpiryDate,
                        maxLength: 5,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateCVV,
                        maxLength: 4,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardholderNameController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    hintText: 'John Doe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: _validateCardholderName,
                ),
                const SizedBox(height: 24),
              ],

              // Pay Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Pay \$${_total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = _selectedPaymentMethod == title;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
          value: title,
      ),
    );
  }
}

