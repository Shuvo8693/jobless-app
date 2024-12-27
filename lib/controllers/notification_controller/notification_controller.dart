import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Message/model/see_all_group_member_model.dart';
import 'package:jobless/views/screen/Notification/notification_model/notification_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/invite_people_model.dart';

class NotificationController extends GetxController {
 Rx<NotificationModel> notificationModel=NotificationModel().obs;
  RxString message = ''.obs;
  RxBool isLoading=false.obs;

  fetchNotification() async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('GET', Uri.parse(ApiConstants.notificationUrl));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        print(responseData['message'].toString());
        notificationModel.value=NotificationModel.fromJson(responseData);
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
  @override
  void onClose() {
    super.onClose();
  }
}
