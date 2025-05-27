import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/s_key.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'dart:convert';

import 'package:jobless/service/api_constants.dart';



class RewardsController extends GetxController{

  Map<String, dynamic>? paymentIntent;
  RxBool isPaymentHandleSuccess=false.obs;

  Future<void> makePayment(String amount,String currency,String postId) async {
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
      await displayPaymentSheet(postId);
    } catch (e) {
      print("exception $e");

      if (e is StripeConfigException) {
        print("Stripe exception ${e.message}");
      } else {
        print("exception $e");
      }
    }
  }

  displayPaymentSheet(String postId) async {
    try {
      // "Display payment sheet";
      await Stripe.instance.presentPaymentSheet();
      // Show when payment is done
      dynamic id = paymentIntent?['id'];
      String currency = paymentIntent?['currency'];
      int amount =paymentIntent?['amount'] ;
      String purchaseToken =paymentIntent?['client_secret'];
      print(paymentIntent.toString());
      print(postId.toString());
      if(id !=null && amount != null && purchaseToken.isNotEmpty){
        await handlePayment(id,postId,amount, paymentIntent??{} );
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

      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${SKey.secretLiveKey}',
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

  /// response send to backend
  handlePayment(dynamic transactionId, String postId,int amountInCent,Map<String,dynamic> stripeResponseData) async {
    String userToken = await PrefsHelper.getString('token');
    print('Stripe response data===========: $stripeResponseData');
    double amount = (amountInCent/100).toDouble();
    Map<String,dynamic> body = {
      "postId": postId,
      "price": amount,
      "transactionId": transactionId.toString(),
      "paymentData": stripeResponseData
    };
    Map<String,String> header={
      'Content-Type':'application/json',
      'Authorization': 'Bearer $userToken'
    };

    try {
      var request = await http.post(Uri.parse(ApiConstants.rewardPaymentUrl),body: jsonEncode(body),headers:header );

      var responseBody = jsonDecode(request.body);
      if (request.statusCode == 201) {
        isPaymentHandleSuccess.value=true;
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
        isPaymentHandleSuccess.value=false;
      }
    } on Exception catch (e) {
      print('paymentHandleError:$e');
      isPaymentHandleSuccess.value=false;
    }

  }
}