import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';

import 'my_post_controller.dart';

class PostDeleteController extends GetxController {
  final MyPostController postController;
  PostDeleteController({required this.postController});
  RxBool isLoading = false.obs;

  Future<void> deletePost(dynamic postId, Function onPostDeleted) async {
    try {
      isLoading.value = true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      };

      var request = http.Request('DELETE', Uri.parse(ApiConstants.deletePostUrl(postId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        var responseMessage = responseData['message'];
        Get.back(); // Close the bottom sheet
        Get.showSnackbar(GetSnackBar(
          message: responseMessage,
          duration: const Duration(seconds: 2),
        ));
        onPostDeleted(); // Notify the UI about the deletion
        postController.timeLinePost.refresh();
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: 'Failed to delete post',
          duration: Duration(seconds: 2),
        ));
      }
    } catch (error) {
      Get.showSnackbar(const GetSnackBar(
        message: 'Something went wrong',
        duration: Duration(seconds: 2),
      ));
    } finally {
      isLoading.value = false;
    }
  }
}
