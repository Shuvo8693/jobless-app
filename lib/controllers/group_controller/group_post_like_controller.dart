import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/group_timeline_post_model.dart';
import 'group_timeline_post_controller.dart';

class GroupPostLikeController extends GetxController {
  final GroupTimelinePostController groupTimelinePostController;

  RxString likeMessage = ''.obs;

  GroupPostLikeController({required this.groupTimelinePostController});

  Future<void> sendLike(dynamic postId, dynamic groupId) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };


    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.likeUrl(postId)));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody);
      if (response.statusCode == 201 || response.statusCode == 200) {

        likeMessage.value = responseData['message'];

        var postIndex = groupTimelinePostController.groupTimelinePostModel.value.data?.attributes?.results?.indexWhere((post) => post.sId == postId); // find the post index
        print(postIndex.toString());

        if (postIndex != null && postIndex != -1) {
          var post = groupTimelinePostController.groupTimelinePostModel.value.data?.attributes?.results?[postIndex];

          if (post != null) {
            // Toggle the like status and update the like count
            post.isLiked = !(post.isLiked ?? false);
            post.likesCount = (post.likesCount ?? 0) + (post.isLiked! ? 1 : -1);

            groupTimelinePostController.groupTimelinePostModel.refresh();

          }
        }
      } else {
        likeMessage.value = 'Failed to update like status.';
        Get.snackbar('Error', likeMessage.value, duration: const Duration(seconds: 2));
      }
    } catch (e) {
      // Handle any exceptions or errors
      likeMessage.value = 'Error occurred while liking the post.';
      Get.snackbar('Error', likeMessage.value, duration: const Duration(seconds: 2));
    }
  }
}
