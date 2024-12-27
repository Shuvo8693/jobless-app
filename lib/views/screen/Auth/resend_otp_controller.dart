import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:http/http.dart' as http;

class ResendOtpController extends GetxController {

  var isLoading = false.obs; // Observable loading state

  Future<void> sendMail(bool? isResetPass) async {


    if (isLoading.value) {
      return; // Prevent multiple taps
    }

    isLoading.value = true; // Start loading
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      'email': Get.arguments['email'].toString(),
    };

    print('Request URL: ${ApiConstants.emailSendUrl}');
    print('Request Headers: ${headers.toString()}');
    print('Request Body: ${jsonEncode(body)}');

    try {
      final url = Uri.parse(ApiConstants.emailSendUrl);
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = jsonEncode(body);

      // Send the request and get the streamed response
      final streamedResponse = await request.send();

      // Convert streamed response to a regular response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Response Data: $responseData');
      } else {
        print('Error: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      print('Error during API call: $e');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
