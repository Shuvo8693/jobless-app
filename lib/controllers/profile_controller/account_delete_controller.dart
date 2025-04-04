import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';


class AccountDeleteController extends GetxController {
 TextEditingController passCtrl =TextEditingController();
  RxString responseMessage = ''.obs;
  RxBool isLoading = false.obs;

  removeAccount(dynamic friendId,{Function()? toRemoveFromIndex}) async {
    try {
      isLoading.value = true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('POST', Uri.parse(ApiConstants.deleteAccountUrl));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        responseMessage.value = responseData['message'];
        Get.snackbar(responseMessage.value.toString(), '');
      } else {
        print('Error>>>');
        responseMessage.value = responseData['message'];
      }
    } on Exception catch (error) {
      print(error.toString());
      responseMessage.value = 'Something wen wrong';
    } finally {
      isLoading.value = false;
    }
  }
}
