import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/comment_modal.dart';

import 'allgroup_list_controller.dart';

class GroupJoinController extends GetxController {
  final AllGroupListController allGroupListController;
  GroupJoinController({required this.allGroupListController});
  RxString errorMessage = ''.obs;
  RxMap<int,bool> isLoadingMap = <int,bool>{}.obs;

  joinGroup(dynamic postId,int index) async {
    try {
      isLoadingMap[index]=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('POST', Uri.parse(ApiConstants.groupJoinUrl(postId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        Get.snackbar(responseData['message'].toString(), '');
       int groupIndex = allGroupListController.groupResults.indexWhere((group)=>group.value.id==postId);
       if(groupIndex != -1){
        allGroupListController.groupResults.removeAt(groupIndex);
         allGroupListController.groupResults.refresh();
       }
        print(responseData['message'].toString());
      } else {
        print('Error>>>');
        errorMessage.value = 'Failed to load data';
      }
    } on Exception catch (error) {
      print(error.toString());
      errorMessage.value = 'Something wen wrong';
    }finally{
      isLoadingMap[index]=false;
    }
  }
}
