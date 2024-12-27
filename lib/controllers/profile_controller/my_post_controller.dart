import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/home_timeline_post.dart';
import 'package:http/http.dart' as http;

class MyPostController extends GetxController {
  RxString message=''.obs;
  RxBool myPostLoading = false.obs;
  RxBool isFetchingMore = false.obs;
  Rx<TimelinePost> timeLinePost =TimelinePost().obs;

  RxInt currentPage = 1.obs;
  RxInt limit = 3.obs;
  RxInt totalPages = 1.obs;

  Future<void> fetchMyPost( {bool isLoadMore=false }) async {
    if (isLoadMore && isFetchingMore.value) return;
    if(isLoadMore){
      isFetchingMore.value= true;
    }else{
      myPostLoading.value=true;
      currentPage.value = 1;
    }

    try {
      String url= '${ApiConstants.myPostUrl}?page=${currentPage.value}&limit=${limit.value}&sortBy=createdAt:desc';
      String token = await PrefsHelper.getString('token');
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(url),headers: headers);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var attributes = responseData['data']?['attributes'] as Map<String, dynamic>? ??{};
        var results = (attributes['results'] as List<dynamic>?) ?? [];
        if(isLoadMore){
          timeLinePost.value.results?.addAll(results.map((result) => Results.fromJson(result)));
        }else{
          timeLinePost.value.results = results.map((result) => Results.fromJson(result)).toList();
        }
        totalPages.value = attributes['totalPages'] ?? totalPages.value;
        print('Check timeline post: ${timeLinePost.value.results}');
        print('Check timeline post: $results');
      } else {
        print('Error>>>');
        print('Error>>>${response.body}');
        message.value= responseData['message'];
      }
    } on Exception catch (e) {
      message.value='Something went wrong';
    }finally{
      if(isLoadMore){
        isFetchingMore.value= false;
      }else{
        myPostLoading.value=false;
      }
      update();
    }

  }
  void removePostAt(int index) {
    if (index >= 0 && index < (timeLinePost.value.results?.length ?? 0)) {
      timeLinePost.value.results?.removeAt(index);
      update(); // Notify listeners about the change
    }
  }

  loadMorePost()async{
    if(currentPage.value <= totalPages.value && !isFetchingMore.value){
      currentPage.value += 1;
      await fetchMyPost(isLoadMore: true);
    }
  }
}
