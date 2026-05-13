import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import 'checkout_screen.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}



class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService.instance;

  final double shippingCharge = 270.00;


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: cartService.cartItems,
      builder: (context, items, _) {
        final subtotal = items.fold(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        final total = subtotal + shippingCharge;

        return Scaffold(
          backgroundColor: const Color(0xffF7F7F7),
          body: SafeArea(
            child: Column(
              children: [
                _topBar(context),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                    child: Column(
                      children: [
                        ...items.asMap().entries.map((entry) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 24),
                            child: _cartItemCard(entry.key, entry.value),
                          );
                        }),

                        if (items.isEmpty) ...[
                          const SizedBox(height: 110),
                          const Text(
                            'Your cart is empty.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff171725),
                            ),
                          ),
                        ],

                        const SizedBox(height: 145),

                        _priceSummary(subtotal: subtotal, total: total),

                        const SizedBox(height: 32),

                        _checkoutButton(total: total),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      height: 66,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0xff3F7C86),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 28,
              color: Color(0xff171725),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Cart",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff171725),
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _cartItemCard(int index, CartItem item) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            item.image,
            height: 62,
            width: 62,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rs ${item.price.toStringAsFixed(2)} x ${item.quantity}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff171725),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff171725),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.weight,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quantityIcon(
                icon: Icons.add,
                onTap: () => cartService.incrementAt(index),
              ),
              Text(
                "${item.quantity}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.35),
                  fontWeight: FontWeight.w600,
                ),
              ),
              _quantityIcon(
                icon: Icons.remove,
                onTap: () => cartService.decrementAt(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Icon(
        icon,
        size: 22,
        color: const Color(0xff171725),
      ),
    );
  }

  Widget _priceSummary({
    required double subtotal,
    required double total,
  }) {
    return Column(
      children: [
        _priceRow(
          label: "Subtotal",
          value: "P ${subtotal.toStringAsFixed(2)}",
          isBold: false,
        ),
        const SizedBox(height: 14),
        _priceRow(
          label: "Shipping charges",
          value: "P ${shippingCharge.toStringAsFixed(2)}",
          isBold: false,
        ),
        const SizedBox(height: 22),
        _priceRow(
          label: "Total",
          value: "P ${total.toStringAsFixed(0)}",
          isBold: true,
        ),
      ],
    );
  }

  Widget _priceRow({
    required String label,
    required String value,
    required bool isBold,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 17 : 12,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: const Color(0xff171725),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 20 : 12,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: const Color(0xff171725),
          ),
        ),
      ],
    );
  }

  Widget _checkoutButton({required double total}) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(totalCost: total),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff3F7C86),
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Text(
          "Checkout",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

}




