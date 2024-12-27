import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/mygroup_about_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';



class GroupChatMemberRemoveController extends GetxController {
  RxString responseMessage = ''.obs;
  RxBool isLoading = false.obs;

  removeGroupChatMember({required String memberId,required String groupId,Function()? toRemoveFromIndex}) async {
    try {
      isLoading.value = true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {
        'Content-Type':'application/json',
        'Authorization': 'Bearer $token'
      };
      Map<String,dynamic> body={
        "groupId": groupId,
        "memberId": memberId,
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.removeGroupChatMember));
      request.body= jsonEncode(body);
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        responseMessage.value = responseData['message'];
        isLoading.value = false;
        toRemoveFromIndex!();
        Get.back();
        Get.snackbar(responseMessage.value, '');

      } else {
        print('Error>>>');
        isLoading.value = false;
        responseMessage.value = responseData['message'];
      }
    } on Exception catch (error) {
      print(error.toString());
      isLoading.value = false;
      responseMessage.value = 'Something wen wrong';
    } finally {
      isLoading.value = false;
    }
  }
}
