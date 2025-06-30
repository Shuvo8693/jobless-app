import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/service/api_constants.dart';


class DeleteAccountController extends GetxController {
  RxString errorMessage = ''.obs;
  RxString content = ''.obs;
  RxBool isLoading = false.obs;
  delete() async {
    try {
      isLoading.value=true;
      var request = http.Request('POST', Uri.parse(ApiConstants.aboutUsUrl));
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        List<dynamic> contentMapData= responseData['data']['attributes'];

        print(content.value);
      } else {
        print('Error>>>');
        Get.snackbar('Failed', 'Failed to delete your account');
      }
    } on Exception catch (error) {
      print(error.toString());
      errorMessage.value = 'Something went wrong';
    }finally {
      isLoading.value=false;
    }
  }
}
