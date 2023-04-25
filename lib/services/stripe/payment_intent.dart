import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:sunrise/constants/constants.dart';

abstract class SunrisePaymentIntent {
  static Future<void> init(String email, double amount) async {
    final response = await http.post(
      Uri.parse(stripePaymentIntentEndpoint),
      body: {
        'email': email,
        'amount': amount.toString(),
      },
    );

    final jsonResponse = jsonDecode(response.body);
    _paymentIntent(
      SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Sunrise',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      ),
    );
  }

  static _paymentIntent(
    SetupPaymentSheetParameters paymentSheetParameters,
  ) async {
    await Stripe.instance
        .initPaymentSheet(paymentSheetParameters: paymentSheetParameters);
    await Stripe.instance.presentPaymentSheet();
  }
}
