import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:http/http.dart' as http;

class BlockController extends GetxController{
  RxBool isLoading = false.obs;

  block({String? userId, Function(String? messageValue)? messageFunc} )async{

    String token = await PrefsHelper.getString('token');
    String authorId = await PrefsHelper.getString('authorId');

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      "blockId": userId??''
    };

    try {

      isLoading.value=true;

      var request = http.Request('POST', Uri.parse(ApiConstants.blockUserUrl));
      request.body = jsonEncode(body);
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        String message = responseData['message'];
        print(message);
        messageFunc!(message);

      } else {
        print('Error>>>');
        Get.snackbar('Failed', 'Failed to block this account');
      }
    } on Exception catch (error) {
      print(error.toString());
    }finally {
      isLoading.value=false;
    }
  }
}