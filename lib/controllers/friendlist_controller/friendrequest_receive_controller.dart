import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/friendrequest_model.dart';

class FriendRequestReceiveController extends GetxController {
  Rx<FriendRequestModel> friendRequestModel=FriendRequestModel().obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;
  fetchRequestList() async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('GET', Uri.parse(ApiConstants.friendRequestListUrl));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        friendRequestModel.value=FriendRequestModel.fromJson(responseData);
        isLoading.value=false;
        update();
      } else {
        print('Error>>>');
        isLoading.value=false;
        errorMessage.value = 'Failed to load data';
        update();
      }
    } on Exception catch (error) {
      print(error.toString());
      isLoading.value=false;
      errorMessage.value = 'Something wen wrong';
      update();
    }
  }
}
