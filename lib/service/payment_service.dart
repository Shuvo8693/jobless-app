//
// import 'dart:convert';
//
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
//
//
// class PaymentService{
//
//   var paymentIntent;
//
//   Future<void> makePayment(BuildContext context) async {
//     try {
//
//        paymentIntent = await createPaymentIntent('25', 'USD');
//
//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret: paymentIntent!['client_secret'],
//               customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
//               //Gotten from payment intent
//               style: ThemeMode.dark,
//               merchantDisplayName: 'Ikay'))
//           .then((value) {});
//
//       //STEP 3: Display Payment sheet
//       displayPaymentSheet(context);
//
//
//     } catch (err) {
//       debugPrint('PaymentError>>>$err');
//       throw Exception(err);
//     }
//   }
//
//   displayPaymentSheet(BuildContext context) async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//
//         showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.check_circle,
//                     color: Colors.green,
//                     size: 100.0,
//                   ),
//                   SizedBox(height: 10.0),
//                   Text("Payment Successful!"),
//                 ],
//               ),
//             ));
//
//         paymentIntent = null;
//
//       }).onError((error, stackTrace) {
//         throw Exception(error);
//       });
//
//     } on StripeException catch (e) {
//       print('Error is:---> $e');
//       AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: const [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.red,
//                 ),
//                 Text("Payment Failed"),
//               ],
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print('$e');
//     }
//   }
//
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       print('TokenCheck>>${dotenv.env['STRIPE_SECRET_KEY']}');
//       //Request body
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'automatic_payment_methods[enabled]': 'true',
//       };
//
//
//       //Make post request to Stripe
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       var data=json.decode(response.body);
//       print('paymentCheck>>$data');
//       return json.decode(response.body);
//
//     } catch (err) {
//       print('Error>>>>$err');
//       throw Exception(err.toString());
//     }
//   }
//
//   calculateAmount(String amount) {
//     final calculatedAmout = (int.parse(amount)) * 100;
//     return calculatedAmout.toString();
//   }
//
// }

// import 'dart:convert';
// import 'package:aidaly/views/base/show_toast.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// import '../Utils/app_constants.dart';
// import '../controllers/Role/Shopper_Controllar/add_to_card_controllar.dart';
// import '../helpers/prefs_helper.dart';
// import '../models/Role/ShopperModel/product_details_model.dart';
//
// class PaymentService {
//  final AddToCartControllar addCartCtrl=Get.put(AddToCartControllar());
//
//   Future createPaymentIntent(
//       {required String amount, required String currency})async{
//     try {
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         body: {
//           "amount": "${amount}00",
//           "currency": currency,
//           "payment_method_types[]": "card"
//         },
//
//         headers: {
//           'Authorization': 'Bearer sk_test_51NJDjwIu2LkK2RA4JKgv1NjXyb7pqeMUYbLpVslE4WbPLKqNT1SvhKUOZZsDYwreTu5OtgWTmnjFjTUDWBvHcvVS00AyKnOi3I',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//       );
//       print("Payment Intent body ${response.body}");
//       debugPrint("Payment Intent body ${response.body}");
//
//       return jsonDecode(response.body);
//     } catch (error) {
//       Get.snackbar("Error", error.toString());
//     }
//   }
//
//   ///========================= Make Payment =========================
//
//   Future<void> makePayment({
//     required int amount,
//     required String currency,
//     required String packageID,
//     required String paymentType,
//   }) async {
//    // var total=amount+amount*20~/100;
//     Map<String, dynamic>? paymentIntentData;
//     try {
//       paymentIntentData =
//       await createPaymentIntent(amount: amount.toString(), currency: currency);
//       print('===========-------------------------${paymentIntentData}');
//       print('===========---------------========----------====-----=-----=---=----${paymentIntentData!["id"]}');
//
//       if (paymentIntentData != null) {
//         print('Payment Check>>>${paymentIntentData["client_secret"]}');
//         await Stripe.instance.initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//               merchantDisplayName: 'Rafsan Hossain',
//               paymentIntentClientSecret: paymentIntentData["client_secret"],
//               allowsDelayedPaymentMethods: true,
//               style: ThemeMode.light,
//             ));
//            await Stripe.instance.presentPaymentSheet();
//
//         /// >>   <><><><><><<><><><><><><> Send response in server <><><><><><><><><><<><><><><><>  <<
//
//         // requiterSubscription(
//         //   packageID: packageID,
//         //   currency: currency,
//         //   transactionId: paymentIntentData["id"],
//         //   amount:total.toString(),
//         //   email:homeController.profileModel.value.data!.email.toString(),
//         //   name:homeController.profileModel.value.data!.fullName.toString(),
//         //   paymentType:paymentType,
//         //   status:"successful",
//         // );
//
//         addCartCtrl.orderComplete();
//         showToastMessage.showMessage("Payment Successful");
//         print("this is payable  amount ${amount}");
//       }
//     } catch (e) {
//       debugPrint("Error ================>>>>>>>>>>>>>${e.toString()}");
//       showToastMessage.showMessage( "Error $e");
//     }
//   }
//
//   ///============================ Send Response to server ==============================
//
//
//
// }

