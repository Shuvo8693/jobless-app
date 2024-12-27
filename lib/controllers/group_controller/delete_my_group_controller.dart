import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/invite_people_model.dart';

class DeleteMyGroupController extends GetxController {
  RxString message = ''.obs;
  RxBool isLoading=false.obs;

  deleteGroup(dynamic groupId) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('DELETE', Uri.parse(ApiConstants.deleteGroupUrl(groupId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        print(responseData['message'].toString());
        message.value=responseData['message'] as String;
        Get.offNamed(AppRoutes.homeScreen);
        Get.snackbar(message.value.toString(), '');
      } else {
        print('Error>>>');
        message.value=responseData['message'] as String;
        Get.snackbar(message.value.toString(), '');
      }
    } on Exception catch (error) {
      print(error.toString());
      message.value = 'Something went wrong';
      Get.snackbar(message.value.toString(), '');
    }finally{
      isLoading.value=false;
    }
  }
}
