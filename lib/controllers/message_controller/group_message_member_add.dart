import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/controllers/message_controller/chat_list_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';

class GroupMessageMemberAddController extends GetxController {
  final ChatListController _chatListController=Get.put(ChatListController());
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  addGroupMember(String groupId,List<String> userId) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token','Content-Type':'application/json'};
      Map<String,dynamic> body={
        "groupId":groupId,
        "newMember": userId
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.addGroupChatMember));
      request.body= jsonEncode(body);
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
       await _chatListController.fetchChatList();
        print(responseData['message']);
        Get.offAllNamed(AppRoutes.messageScreen);
        Get.snackbar('', responseData['message'].toString());
      } else {
        print('Error>>>');
        isLoading.value=false;
        errorMessage.value = 'Failed to load data';
        Get.snackbar('', responseData['message'].toString());
      }
    } on Exception catch (error) {
      print(error.toString());
      isLoading.value=false;
      errorMessage.value = 'Something wen wrong';
    }
  }
}
