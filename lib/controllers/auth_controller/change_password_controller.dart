import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';

class ChangePasswordController extends GetxController {
  TextEditingController newPassCtrl = TextEditingController();
  TextEditingController oldPassCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();

  Future<Either<String,bool>> resetPassword() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
   String email= Get.arguments['email'];
    var body = {
      'email':email ,
      'password': confirmPassCtrl.text
    };

    Response response = await ApiClient.postData(ApiConstants.resetPasswordUrl, body:  jsonEncode(body), headers: headers);
    final responseData = response.body;
    if (response.statusCode == 200) {
      print(responseData.toString());
      update();
      return Right(response.statusCode==200);
    } else {
      print('Error>>>');
      print('Error>>>${response.body}');
      ApiChecker.checkApi(response);
      update();
      return Left(responseData['message']);
    }
  }

  @override
  void onClose() {
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.onClose();
  }
}
