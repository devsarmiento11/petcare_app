import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import 'cart_screen.dart';


class ViewProductScreen extends StatefulWidget {
  const ViewProductScreen({
    super.key,
    required this.name,
    required this.brand,
    required this.price,
    required this.weight,
    required this.imagePath,
    required this.recommendedFor,
    required this.description,
  });

  final String name;
  final String brand;
  final String price;
  final String weight;
  final String imagePath;
  final String recommendedFor;
  final String description;

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  int quantity = 0;

  double _parsePrice(String priceText) {
    // Handles strings like "₱1000.00" or "1000.00"
    final cleaned = priceText.replaceAll(RegExp(r'[^0-9\.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 22),
                    _productImage(),
                    const SizedBox(height: 22),
                    _infoCard(),
                    const SizedBox(height: 28),
                    _description(),
                    const SizedBox(height: 24),
                    _recommendedFor(),
                    const SizedBox(height: 28),
                    _quantitySelector(),
                    const SizedBox(height: 34),
                    _addToCartButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      height: 68,
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
          Expanded(
            child: Center(
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff171725),
                ),
              ),
            ),
          ),
          const Icon(
            Icons.tune,
            size: 24,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _productImage() {
    return Center(
      child: Image.asset(
        widget.imagePath,
        height: 275,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.name} - ${widget.weight}",
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xff171725),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                "4.5",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 5),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index == 4 ? Icons.star_half : Icons.star,
                    size: 18,
                    color: const Color(0xffFFB800),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "(89 reviews)",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                widget.price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff171725),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        widget.description,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 12.5,
          height: 1.65,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.82),
        ),
      ),
    );
  }

  Widget _recommendedFor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text(
            "Recommended For:",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xff171725),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xff3E5FA8),
                width: 1,
              ),
            ),
            child: Text(
              widget.recommendedFor,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xff3E5FA8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          const Text(
            "Quantity",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black45,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _circleButton(
            icon: Icons.remove,
            onTap: () {
              if (quantity > 0) setState(() => quantity--);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "$quantity",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xff171725),
              ),
            ),
          ),
          _circleButton(
            icon: Icons.add,
            onTap: () {
              setState(() => quantity++);
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xff171725),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xff171725),
        ),
      ),
    );
  }

  Widget _addToCartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () {
            if (quantity == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select quantity first"),
                ),
              );
              return;
            }

            CartService.instance.addItem(
              image: widget.imagePath,
              name: widget.name,
              price: _parsePrice(widget.price),
              weight: widget.weight,
              quantity: quantity,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Added $quantity item(s) to cart"),
              ),
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff3F7C86),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "Add to cart",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Icon(Icons.shopping_bag_outlined, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}



