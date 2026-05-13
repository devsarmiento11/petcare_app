import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../services/stripe_payment_service.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import 'paymentsuccess_screen.dart';



class CheckoutScreen extends StatefulWidget {


  const CheckoutScreen({super.key, required this.totalCost});

  final double totalCost;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String paymentMethod = "🇵🇭";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8F8),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),

            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  _checkoutRow(
                    title: "Delivery",
                    value: "Select Method",
                    onTap: () {},
                  ),

                  _checkoutRow(
                    title: "Payment",
                    value: paymentMethod,
                    onTap: () {
                      // Show the same simple MasterCard UI to complete the payment
                      showMasterCardPaymentDialog(context);
                    },
                  ),

                  _checkoutRow(
                    title: "Promo Code",
                    value: "Pick discount",
                    onTap: () {},
                  ),

                  _checkoutRow(
                    title: "Total Cost",
                    value: "P ${widget.totalCost.toStringAsFixed(0)}",
                    onTap: () {},
                  ),

                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Color(0xff7C7C7C),
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: "By placing an order you agree to our\n",
                            ),
                            TextSpan(
                              text: "Terms And Conditions",
                              style: TextStyle(
                                color: Color(0xff181725),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  _bottomNavText(),

                  const SizedBox(height: 245),

                  _placeOrderButton(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Row(
        children: [
          const Text(
            "Checkout",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xff181725),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showMasterCardPaymentDialog(context);
            },
            child: const Icon(
              Icons.close,
              size: 28,
              color: Color(0xff181725),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkoutRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.04)),
            bottom: BorderSide(color: Colors.black.withOpacity(0.04)),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xff7C7C7C),
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xff181725),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xff181725),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: const [
          Text(
            "Home",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff3F4B5B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Text(
            "Profile",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff3F4B5B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void showMasterCardPaymentDialog(BuildContext context) {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Pay with MasterCard',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffF59E0B),
                        Color(0xffEF4444),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MasterCard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        cardNumberController.text.isEmpty
                            ? '•••• •••• •••• ••••'
                            : cardNumberController.text,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        expiryController.text.isEmpty
                            ? 'MM/YY'
                            : expiryController.text,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234 5678 9012 3456',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Expiry',
                          hintText: 'MM/YY',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        controller: cvvController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final card = cardNumberController.text.trim();
                final exp = expiryController.text.trim();
                final cvv = cvvController.text.trim();

                final isValid = card.length >= 12 && exp.isNotEmpty && cvv.length >= 3;

                if (!isValid) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please enter valid card details')),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentSuccessScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3F7C86),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm Payment'),
            ),
          ],
        );
      },
    );
  }

  Widget _placeOrderButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () async {
            final success = await StripePaymentService.payNow(
              amount: widget.totalCost.toInt() * 100,
              currency: "php",
            );

            if (success) {
              final user = FirebaseAuth.instance.currentUser;
              final uid = user?.uid;
              if (uid != null) {
                final cartService = CartService.instance;
                final items = List<CartItem>.from(cartService.cartItems.value);
                final totalCost = cartService.subtotal;
                if (items.isNotEmpty) {
                  await OrderService.recordPaidOrder(
                    uid: uid,
                    totalCost: totalCost,
                    items: items,
                    paymentProvider: 'stripe',
                  );
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaymentSuccessScreen(),
                ),
              );
            } else {


              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Payment failed or cancelled"),
                ),
              );
            }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff3F7C86),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Place Order",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

