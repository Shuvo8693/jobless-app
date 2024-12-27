import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/friendrequest_model.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/my_friend_model.dart';

class MyFriendController extends GetxController {
  Rx<MyFriendModel> myFriendModel=MyFriendModel().obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;
  fetchMyFriendList() async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('GET', Uri.parse(ApiConstants.myFriendLIstUrl));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        myFriendModel.value=MyFriendModel.fromJson(responseData);
        isLoading.value=false;

      } else {
        print('Error>>>');
        isLoading.value=false;
        errorMessage.value = 'Failed to load data';

      }
    } on Exception catch (error) {
      print(error.toString());
      isLoading.value=false;
      errorMessage.value = 'Something wen wrong';

    }finally {
      isLoading.value=false;

    }
  }
}
