import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/controllers/home_controller/search_group_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/comment_modal.dart';


class GroupJoinHomeController extends GetxController {
  GroupSearchController groupSearchController;

  GroupJoinHomeController({required this.groupSearchController});
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  joinHomeGroup(dynamic postId) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('POST', Uri.parse(ApiConstants.groupJoinUrl(postId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        isLoading.value=false;
        Get.snackbar(responseData['message'].toString(), '');
        int? groupIndex = groupSearchController.groupSearchResultModel.value.data?.attributes?.results?.indexWhere((group)=>group.sId == postId);
        if(groupIndex != null && groupIndex != -1 ){
          var group = groupSearchController.groupSearchResultModel.value.data?.attributes?.results?[groupIndex];
          group?.joined = !(group.joined??false);
          groupSearchController.groupSearchResultModel.refresh();
        }
        print(responseData['message'].toString());
      } else {
        print('Error>>>');
        isLoading.value=false;
        errorMessage.value = 'Failed to load data';
      }
    } on Exception catch (error) {
      print(error.toString());
      isLoading.value=false;
      errorMessage.value = 'Something wen wrong';
    }finally{
      isLoading.value=false;
    }
  }
}
