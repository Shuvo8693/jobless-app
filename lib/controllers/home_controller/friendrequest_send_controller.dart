import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/controllers/home_controller/search_friend_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';
import 'package:jobless/views/screen/Home/modal/comment_modal.dart';

class FriendRequestSendController extends GetxController {
  SearchFriendController? searchFriendController;

  FriendRequestSendController({this.searchFriendController});


  Rx<Profile>  profile=Profile().obs;
  RxString message = ''.obs;
  RxBool isLoading = false.obs;

  sendRequest(dynamic postId) async {
    try {
      isLoading.value = true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('POST', Uri.parse(ApiConstants.sendFriendRequestUrl(postId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 201) {
        var friendRequestMessage = responseData['data']['attributes']['message'];
        message.value = friendRequestMessage.toString();
        Get.put(GetSnackBar(
          message: friendRequestMessage.toString(),
          duration: const Duration(seconds: 2),
          ),
        );

        ///searchFriendController_area_to update model
        if (searchFriendController?.userModel.value.data?.userList != null) {
          int? friendIndex = searchFriendController?.userModel.value.data?.userList?.indexWhere((friend) => friend.sId == postId);

          if (friendIndex != null && friendIndex != -1) {
            var friend = searchFriendController?.userModel.value.data?.userList?[friendIndex];
            friend?.friendRequestStatus = friend.friendRequestStatus?.contains('pending') != true ? 'pending' : 'other';
            print(friend.toString());
            print(friend?.friendRequestStatus);
            searchFriendController?.userModel.refresh();
          }
        }

        isLoading.value = false;
      } else {
        var responseMessage = responseData['message'];
        message.value = responseMessage.toString();
        Get.put(GetSnackBar(
          message: responseMessage.toString(),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (error) {
      print(error.toString());
    } finally {
      isLoading.value = false;
    }
  }
 @override
  void onClose() {
   searchFriendController?.onClose();
    super.onClose();
  }
}
