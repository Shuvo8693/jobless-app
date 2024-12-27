import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jobless/controllers/home_controller/timeline_post_controller.dart';
import 'package:jobless/controllers/profile_controller/my_post_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/home_timeline_post.dart';

class ProfilePostLikeController extends GetxController {
  final MyPostController myPostController;

  ProfilePostLikeController({required this.myPostController});
  RxString likeMessage = ''.obs;

  Future<void> sendLike(dynamic postId) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.likeUrl(postId)));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);
        likeMessage.value = responseData['message'];

        // Locate the post within the controller's post list by ID
        var postIndex = myPostController.timeLinePost.value.results?.indexWhere((post) => post.sId == postId); // find the post index
        print(postIndex.toString());

        if (postIndex != null && postIndex != -1) {
          var post = myPostController.timeLinePost.value.results?[postIndex];

          if (post != null) {
            // Toggle the like status and update the like count
            post.isLiked = !(post.isLiked ?? false);
            post.likesCount = (post.likesCount ?? 0) + (post.isLiked! ? 1 : -1);

            // Notify the UI to refresh and reflect the new like status and count
            myPostController.timeLinePost.refresh();

            /*Get.snackbar('Success', likeMessage.value,
                duration: const Duration(seconds: 2));*/
          }
        }
      } else {
        likeMessage.value = 'Failed to update like status.';
        Get.snackbar(
            'Error', likeMessage.value, duration: const Duration(seconds: 2));
      }
    } catch (e) {
      // Handle any exceptions or errors
      likeMessage.value = 'Error occurred while liking the post.';
      Get.snackbar(
          'Error', likeMessage.value, duration: const Duration(seconds: 2));
    }
  }
}
