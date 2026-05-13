import 'package:flutter/material.dart';

import '../services/cart_service.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService.instance;


    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    _orderHeader(),
                    const SizedBox(height: 18),
                    _progressStatus(),
                    const SizedBox(height: 14),

                    ValueListenableBuilder<List<CartItem>>(
                      valueListenable: cartService.cartItems,
                      builder: (context, items, _) {
                        if (items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'No items found for this order.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff171725),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            children: items.map((item) {
                              return _productCard(
                                image: item.image,
                                name: item.name,
                                weight: item.weight,
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),


                    const SizedBox(height: 28),
                    _timeline(),
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
      height: 58,
      color: const Color(0xff3F7C86),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, size: 24),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Track Order",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _orderHeader() {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: const Color(0xffE9E9E9),
      child: Row(
        children: const [
          Expanded(
            child: _HeaderInfo(
              title: "Estimated Date",
              value: "04-04-2026",
            ),
          ),
          Expanded(
            child: _HeaderInfo(
              title: "Order Number",
              value: "#2326532",
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                "Ordered",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Text(
                "01 April",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              const Text(
                "04 April",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _dot(const Color(0xff3F7C86)),
              Expanded(child: _line(const Color(0xff3F7C86))),
              _dot(const Color(0xff3F7C86)),
              Expanded(child: _line(const Color(0xff171725))),
              _dot(const Color(0xff171725)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCard({
    required String image,
    required String name,
    required String weight,
  }) {
    return Container(
      height: 58,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(image, height: 42, width: 42, fit: BoxFit.contain),
          const SizedBox(width: 28),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  weight,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeline() {
    final steps = [
      {
        "date": "01 April",
        "title": "Order Placed",
        "subtitle": "we have received your order",
      },
      {
        "date": "01 April",
        "title": "Order Confirmed",
        "subtitle": "Your order has been confirmed",
      },
      {
        "date": "02 April",
        "title": "Item Packed",
        "subtitle": "Item has been in warehouse",
      },
      {
        "date": "03 April",
        "title": "In Transit",
        "subtitle": "",
      },
      {
        "date": "04 April",
        "title": "Out for Delivery",
        "subtitle": "",
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: List.generate(steps.length, (index) {
          final step = steps[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  step["date"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Column(
                children: [
                  Container(
                    width: 1.4,
                    height: index == 0 ? 0 : 16,
                    color: Colors.black,
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 1.4,
                    height: index == steps.length - 1 ? 0 : 48,
                    color: Colors.black,
                  ),
                ],
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step["title"]!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (step["subtitle"]!.isNotEmpty)
                        Text(
                          step["subtitle"]!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withOpacity(0.45),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _line(Color color) {
    return Container(height: 2, color: color);
  }
}

class _HeaderInfo extends StatelessWidget {
  final String title;
  final String value;

  const _HeaderInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xff171725),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}