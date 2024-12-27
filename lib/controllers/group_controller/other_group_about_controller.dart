import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';

class OtherGroupAboutController extends GetxController {
  Rx<GroupResults> groupResults=GroupResults().obs;

  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  fetchOtherGroupAbout(dynamic groupId) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('GET', Uri.parse(ApiConstants.groupAboutUrl(groupId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        groupResults.value= GroupResults.fromJson(responseData['data']['attributes']);
        print(groupResults.value.toString());
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
