import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/group_timeline_post_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/comment_modal.dart';

class CommentProviderController extends GetxController {
  Rx<CommentModel> commentModel = CommentModel().obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  fetchComments(dynamic postId) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('GET', Uri.parse(ApiConstants.getCommentsUrl(postId)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        commentModel.value.comments?.clear();
        if ((responseData['comments'] as List).isEmpty) {
          errorMessage.value = 'comments are empty';
        } else {
          commentModel.value = CommentModel.fromJson(responseData);
        }

        isLoading.value=false;
        print(commentModel.value.comments.toString());
      } else {
        print('Error>>>');
        errorMessage.value = 'Failed to load data';
      }
    } on Exception catch (error) {
      print(error.toString());
      errorMessage.value = 'Something wen wrong';
    }finally{
      isLoading.value=false;
    }
  }
  @override
  void onClose() {
    commentModel.close();
    super.onClose();
  }
}
