import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StripePaymentService {


  static const String cloudFunctionUrl =
      "https://us-central1-petcare-app-e536f.cloudfunctions.net/createPaymentIntent";

  static Future<bool> payNow({
    required int amount,
    required String currency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": amount,
          "currency": currency,
        }),
      );

      final data = jsonDecode(response.body);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data["clientSecret"],
          merchantDisplayName: "PetCare App",
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      return false;
    }
  }
}

