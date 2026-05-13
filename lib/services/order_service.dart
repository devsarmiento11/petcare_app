import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/cart_service.dart';

class OrderService {
  OrderService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> recordPaidOrder({
    required String uid,
    required double totalCost,
    required List<CartItem> items,
    required String paymentProvider,
  }) async {
    final now = DateTime.now();

    final orderData = {
      'uid': uid,
      'createdAt': Timestamp.fromDate(now),
      'status': 'paid',
      'totalCost': totalCost,
      'paymentProvider': paymentProvider,
      'items': items
          .map((e) => {
                'image': e.image,
                'name': e.name,
                'price': e.price,
                'weight': e.weight,
                'quantity': e.quantity,
              })
          .toList(),
    };

    await _firestore.collection('orders').add(orderData);
  }
}

