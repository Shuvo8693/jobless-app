import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'dart:convert';

import 'package:jobless/service/api_constants.dart';



class PaymentController extends GetxController{

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(String amount,String currency,dynamic subscriptionId) async {
    try {
      // Create payment intent data
      paymentIntent = await createPaymentIntent(amount, currency);
      // initialise the payment sheet setup
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Client secret key from payment data
          paymentIntentClientSecret: paymentIntent?['client_secret']??'',
          // Merchant Name
          merchantDisplayName: 'Flutterwings',
          // return URl if you want to add
          // returnURL: 'flutterstripe://redirect',
        ),
      );
      // Display payment sheet
     await displayPaymentSheet(subscriptionId);
    } catch (e) {
      print("exception $e");

      if (e is StripeConfigException) {
        print("Stripe exception ${e.message}");
      } else {
        print("exception $e");
      }
    }
  }

  displayPaymentSheet(dynamic subscriptionId) async {
    try {
      // "Display payment sheet";
      await Stripe.instance.presentPaymentSheet();
      // Show when payment is done
         dynamic id = paymentIntent?['id'];
         String currency = paymentIntent?['currency'];
         int amount =paymentIntent?['amount'] ;
         String purchaseToken =paymentIntent?['client_secret'];
      print(paymentIntent.toString());
      print(subscriptionId.toString());
      if(id !=null && amount !=null && purchaseToken !=null){
       await handlePayment(id,subscriptionId,amount, paymentIntent??{} );
      }
      Get.snackbar('Payment Successful', '');
       paymentIntent = null;
    } on StripeException catch (e) {
      // If any error comes during payment
      // so payment will be cancelled
      print('Error: $e');
      Get.snackbar('Payment Cancel', '');

    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      // Validate amount input
      if (amount.isEmpty || double.tryParse(amount) == null) {
        print('Invalid amount: $amount');
        Get.snackbar("Error", "Invalid amount format.");
        return null;
      }

      int amountInCents = (double.parse(amount) * 100).toInt();

      Map<String, dynamic> body = {
        'amount': amountInCents.toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var finalSecretKey= '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';
      var secretKey = "sk_test_51QHiicK8SHIYC4JMUucf1wHwXFj8T4U4qo5V2e4Pr4nnI0jLMTdKIEk9pRF9q23WcZFuqw2fEel0tDNvwbPn9RvV00NgY69Ox9";
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $finalSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
        var decodedBody= jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('Payment Intent created: ${response.body}');
        return  decodedBody;
      } else {
        print('Failed to create Payment Intent: ${response.body}');
        Get.snackbar("Error", "Failed to create payment intent.");
        return null;
      }
    } catch (err) {
      print('Error charging user: ${err.toString()}');
      Get.snackbar("Error", "Payment Intent creation error.");
      return null;
    }
  }


   handlePayment(dynamic transactionId, String subscriberId,int amountInCent,Map<String,dynamic> stripeResponseData) async {
    String userToken = await PrefsHelper.getString('token');
   print('Stripe response data===========: $stripeResponseData');
   double amount = (amountInCent/100).toDouble();
    Map<String,dynamic> body = {
      "subscriptionId": subscriberId.toString(),
      "price": amount,
      "duration": '', //////////<================================ not give duration yet ============
      "transactionId":transactionId.toString(),
      "paymentData":stripeResponseData
    };
    Map<String,String> header={
      'Content-Type':'application/json',
      'Authorization': 'Bearer $userToken'
    };
   var request = await http.post(Uri.parse(ApiConstants.paymentSubscriptionUrl),body: jsonEncode(body),headers:header );

   var responseBody = jsonDecode(request.body);
    if (request.statusCode == 201) {
      print("Payment response: $responseBody");
      Get.dialog(
        barrierDismissible: true,
        AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text('Your payment has been processed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
               Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Get.snackbar('Failed payment record ', 'Payment record failed to add, please contact to administrator');
    }
  }
}