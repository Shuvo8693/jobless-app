import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/friendrequest_receive_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';

class FriendRequestAcceptController extends GetxController {
  FriendRequestReceiveController? friendRequestReceiveController;
  FriendRequestAcceptController({this.friendRequestReceiveController});
  RxString responseMessage = ''.obs;
  RxMap<int,bool> isLoading = <int,bool>{}.obs;
  sendAcceptRequest(dynamic requestId, int index, {Function()? toRemoveFromIndex}) async {
    try {
      isLoading[index]=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('POST', Uri.parse(ApiConstants.acceptFriendRequestUrl(requestId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        responseMessage.value= responseData['message'];
        await friendRequestReceiveController?.fetchRequestList();
        toRemoveFromIndex!();
        Get.snackbar(responseMessage.value, 'Please refresh the screen');
        update();
      } else {
        print('Error>>>');
        responseMessage.value= responseData['message'];
        Get.snackbar(responseMessage.value, '');
        update();
      }
    } on Exception catch (error) {
      print(error.toString());
      responseMessage.value= 'Something wen wrong';
      update();
    }finally{
      isLoading[index]=false;
    }
  }
}
