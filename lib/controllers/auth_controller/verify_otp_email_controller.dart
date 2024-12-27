import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';

class VerifyOtpEmailController extends GetxController {
  TextEditingController otpCtrl = TextEditingController();
  ProfileAttributes profileAttributes = ProfileAttributes();
   RxString otpErrorMessage=''.obs;
  var verifyLoading = false.obs;

  Future<void> sendOtp(bool? isResetPass) async {
    Map<String,String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      verifyLoading.value=true;
      var body = {'email': Get.arguments['email'].toString() ,'oneTimeCode':otpCtrl.text };
      Response response = await ApiClient.postData(ApiConstants.verifyEmailWithOtpUrl, body:  jsonEncode(body),headers: headers);
      final responseData = response.body;
      if (response.statusCode == 200) {
        profileAttributes= ProfileAttributes.fromJson(responseData['data']['attributes']);
        print(profileAttributes.toString());
        await PrefsHelper.setString('token', profileAttributes.tokens!.access?.token);
        String token = await PrefsHelper.getString('token');
        print(token);

        if(isResetPass==true){
          Get.toNamed(AppRoutes.passwordChangeScreen,arguments: {'email': Get.arguments['email']});
        }else{
          Get.toNamed(AppRoutes.loginScreen);
        }

      } else {
        print('Error>>>');
        print('Error>>>${response.body}');
        ApiChecker.checkApi(response);
        otpErrorMessage.value = responseData['message'];
        Get.snackbar(otpErrorMessage.value.toString(), '');
      }
    } on Exception catch (e) {
      otpErrorMessage.value='$e';
      Get.snackbar(otpErrorMessage.value.toString(), '');
    }finally{
      verifyLoading.value=false;
    }
  }
  @override
  void onClose() {
    otpCtrl.dispose();
    super.onClose();
  }
}
