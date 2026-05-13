import 'package:flutter/foundation.dart';

class CartItem {
  final String image;
  final String name;
  final double price;
  final String weight;
  int quantity;

  CartItem({
    required this.image,
    required this.name,
    required this.price,
    required this.weight,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
        'image': image,
        'name': name,
        'price': price,
        'weight': weight,
        'quantity': quantity,
      };
}

class CartService {
  CartService._internal();
  static final CartService instance = CartService._internal();

  final ValueNotifier<List<CartItem>> cartItems =
      ValueNotifier<List<CartItem>>([]);

  void addItem({
    required String image,
    required String name,
    required double price,
    required String weight,
    int quantity = 1,
  }) {
    final current = List<CartItem>.from(cartItems.value);

    final idx = current.indexWhere((e) => e.name == name && e.weight == weight);
    if (idx >= 0) {
      current[idx].quantity += quantity;
    } else {
      current.add(
        CartItem(
          image: image,
          name: name,
          price: price,
          weight: weight,
          quantity: quantity,
        ),
      );
    }

    cartItems.value = current;
  }

  void incrementAt(int index) {
    if (index < 0 || index >= cartItems.value.length) return;
    final current = List<CartItem>.from(cartItems.value);
    current[index].quantity += 1;
    cartItems.value = current;
  }

  void decrementAt(int index) {
    if (index < 0 || index >= cartItems.value.length) return;
    final current = List<CartItem>.from(cartItems.value);
    final nextQty = current[index].quantity - 1;
    if (nextQty <= 0) {
      current.removeAt(index);
    } else {
      current[index].quantity = nextQty;
    }
    cartItems.value = current;
  }

  double get subtotal => cartItems.value.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );
}

