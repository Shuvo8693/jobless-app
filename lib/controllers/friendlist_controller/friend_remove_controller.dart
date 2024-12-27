import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';

import 'friendrequest_receive_controller.dart';

class FriendRemoveController extends GetxController {
  final FriendRequestReceiveController? friendRequestReceiveController;
  FriendRemoveController({this.friendRequestReceiveController});
  RxString responseMessage = ''.obs;
  RxBool isLoading = false.obs;

  removeFriend(dynamic friendId,{Function()? toRemoveFromIndex}) async {
    try {
      isLoading.value = true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('POST', Uri.parse(ApiConstants.removeFriendUrl(friendId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        responseMessage.value = responseData['message'];
        Get.snackbar(responseMessage.value.toString(), '');
        isLoading.value = false;
        toRemoveFromIndex!();
        friendRequestReceiveController?.friendRequestModel.refresh();

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
