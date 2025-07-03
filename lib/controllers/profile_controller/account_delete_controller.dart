import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';


class AccountDeleteController extends GetxController {
 TextEditingController passCtrl =TextEditingController();
  RxString responseMessage = ''.obs;
  RxBool isLoading = false.obs;

  removeAccount() async {
    final body ={
      "password": passCtrl.text.trim()
    };
    try {
      isLoading.value = true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'Application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.deleteAccountUrl));
      request.body = jsonEncode(body) ;
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        await PrefsHelper.remove('token');
        String token = await PrefsHelper.getString('token');
        if(token.isEmpty){
          Get.offAllNamed(AppRoutes.splashScreen);
        }
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
