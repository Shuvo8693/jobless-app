import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController{
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  var selectedReason = ''.obs;
  RxBool isLoading = false.obs;

  final List<String> reportReasons = [
    "Spam",
    "Harassment",
    "Inappropriate Content",
    "False Information",
    "Other",
  ];

  submitReport({String? postId})async{

    String token = await PrefsHelper.getString('token');
    String authorId = await PrefsHelper.getString('authorId');

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      "postId": postId??'',
      "reason": selectedReason.value, // optional enum: ["Spam", "Harassment", "Inappropriate Content", "False Information", "Other",],
      "description": descriptionCtrl.text.trim()   // optional
    };

    try {

      isLoading.value=true;

      var request = http.Request('POST', Uri.parse(ApiConstants.reportAccountUrl));
         request.body = jsonEncode(body);
         request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 201) {
        String message = responseData['message'];
        print(message);
        Get.snackbar('Successfully', message);
        selectedReason.value= '';
        descriptionCtrl.text ='';
      } else {
        print('Error>>>');
        Get.snackbar('Failed', 'Failed to report this account');
      }
    } on Exception catch (error) {
      print(error.toString());
    }finally {
      isLoading.value=false;
    }
  }
}