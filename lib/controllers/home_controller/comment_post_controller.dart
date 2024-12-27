import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jobless/controllers/group_controller/group_timeline_post_controller.dart';
import 'package:jobless/controllers/home_controller/get_comment_controller.dart';
import 'package:jobless/controllers/home_controller/timeline_post_controller.dart';
import 'package:jobless/controllers/profile_controller/my_post_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/group_timeline_post_model.dart';

class CommentPostController extends GetxController {
  final CommentProviderController _commentProviderController=Get.put(CommentProviderController());
  final MyPostController? myPostController;
  final TimelinePostController? timelinePostController;
  final GroupTimelinePostController? groupTimelinePostController;
  CommentPostController( {this.groupTimelinePostController,this.myPostController,this.timelinePostController});
 RxString commentMessage=''.obs;
   sendComment(dynamic postId,String comment) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var request = http.Request('POST', Uri.parse(ApiConstants.postCommentsUrl(postId)));

    request.body = json.encode({
      "content": comment
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var responseData = jsonDecode(responseBody);
    if (response.statusCode == 201) {

     ///=====Home timeline post Comment count update========
      if(timelinePostController?.timeLinePost.value.results!=null && timelinePostController?.timeLinePost.value.results?.isNotEmpty==true){
        int? postIndex = timelinePostController?.timeLinePost.value.results?.indexWhere((result)=>result.sId==postId).toInt();
        if(postIndex !=null){
          var result = timelinePostController?.timeLinePost.value.results?[postIndex];
          if(result!=null){
            result.commentsCount= (result.commentsCount??0) + 1;
            timelinePostController?.timeLinePost.refresh();
          }
        }
      }
      ///=====Profile timeline post Comment count update========
      if(myPostController?.timeLinePost.value.results!=null && myPostController?.timeLinePost.value.results?.isNotEmpty==true){
        int? postIndex = myPostController?.timeLinePost.value.results?.indexWhere((result)=>result.sId==postId).toInt();
        if(postIndex !=null){
          var result = myPostController?.timeLinePost.value.results?[postIndex];
          if(result!=null){
            result.commentsCount= (result.commentsCount??0) + 1;
            myPostController?.timeLinePost.refresh();
          }
        }
      }
      ///=====Group timeline post Comment count update========
      List<GroupTimeLinePostResults>? groupTimelinePostResult= groupTimelinePostController?.groupTimelinePostModel.value.data?.attributes?.results;

      if(groupTimelinePostResult!=null && groupTimelinePostResult.isNotEmpty==true){
        int? postIndex = groupTimelinePostResult.indexWhere((result)=>result.sId==postId).toInt();
        if(postIndex !=null && postIndex != -1){
          var result = groupTimelinePostResult[postIndex];
          if(result!=null){
            result.commentsCount= (result.commentsCount??0) + 1;
            groupTimelinePostController?.groupTimelinePostModel.refresh();
          }
        }
      }

      commentMessage.value = responseData['message'];
      //await _commentProviderController.fetchComments(postId);
    } else {
      print('Error>>>');
      print('Error>>>${response.stream.bytesToString()}');
      commentMessage.value = 'Something went wrong';

    }
  }
  @override
  void onClose() {
    timelinePostController?.timeLinePost.value.results=[];
    myPostController?.timeLinePost.close();
    groupTimelinePostController?.groupTimelinePostModel.value.data?.attributes?.results=[];
    super.onClose();
  }
}
