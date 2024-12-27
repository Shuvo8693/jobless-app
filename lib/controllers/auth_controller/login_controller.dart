import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';

class LoginController extends GetxController {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  ProfileAttributes profileAttributes = ProfileAttributes();
  RxBool verifyLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> login() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var body = {'email': emailCtrl.text.trim(), 'password': passCtrl.text};

    try {
      verifyLoading.value= true;
      Response response = await ApiClient.postData(ApiConstants.logInUrl, body:  jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final responseData = response.body;
        profileAttributes= ProfileAttributes.fromJson(responseData['data']['attributes']);
        print(profileAttributes.toString());
       await PrefsHelper.setString('token', profileAttributes.tokens!.access?.token);
       await PrefsHelper.setString('authorId', profileAttributes.profile?.id);
       await PrefsHelper.setString('profileImage', profileAttributes.profile?.image);
        String token = await PrefsHelper.getString('token');
        print(token);
        Get.toNamed(AppRoutes.homeScreen);
      } else {
        print('Error>>>');
        print('Error>>>${response.body}');
        ApiChecker.checkApi(response);
        errorMessage.value= 'Login failed';
        Get.snackbar('', "${response.body['message']}");
      }
    } on Exception catch (e) {
      errorMessage.value= 'Something went wrong';
    }finally{
      verifyLoading.value= false;
    }

  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }
}
