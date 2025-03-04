import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/home_timeline_post.dart';

class TimelinePostController extends GetxController {
  RxBool timeLineLoading = false.obs;
  RxBool isFetchingMore = false.obs;
  Rx<TimelinePost> timeLinePost = TimelinePost().obs;
  RxString errorMessage = ''.obs;

  RxInt currentPage = 1.obs;
  RxInt limit = 5.obs;
  RxInt totalPages = 1.obs;

  Future<void> fetchTimelinePost( {bool isLoadMore=false }) async {
    if (isLoadMore && isFetchingMore.value) return;
    if(isLoadMore){
      isFetchingMore.value= true;
    }else{
      timeLineLoading.value=true;
      currentPage.value = 1;
    }

    try {
      String url= '${ApiConstants.timelinePostUrl}?page=${currentPage.value}&limit=${limit.value}&sortBy=createdAt:desc';
      String token = await PrefsHelper.getString('token');
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token'
      };
      Response response = await ApiClient.getData(url, headers: headers);
      if (response.statusCode == 200) {
        var responseData = response.body;
        var attributes = responseData['data']?['attributes'] as Map<String, dynamic>? ??{};
        var results = (attributes['results'] as List<dynamic>?) ?? [];
        if(isLoadMore){
          timeLinePost.value.results?.addAll(results.map((result) => Results.fromJson(result)));
        }else{
          timeLinePost.value.results = results.map((result) => Results.fromJson(result)).toList();
        }
        totalPages.value = attributes['totalPages'] ?? totalPages.value;
        print('Check timeline post: $results');
        print('Check timeline post result: ${timeLinePost.value.results}');

      } else {
        print('Error>>>');
        print('Error>>>${response.body}');
        ApiChecker.checkApi(response);
        errorMessage.value = 'Failed to load data';
      }
    } on Exception catch (error) {
      errorMessage.value = 'Something went wrong';
    }finally{
      if (isLoadMore) {

      } else {
        timeLineLoading.value = false;
      }
    }

  }

   loadMorePost()async{
    if(currentPage.value <= totalPages.value && !isFetchingMore.value){
      currentPage.value += 1;
     await fetchTimelinePost(isLoadMore: true);
    }
  }
}
