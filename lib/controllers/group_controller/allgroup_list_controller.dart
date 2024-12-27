import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/comment_modal.dart';
import 'package:jobless/views/screen/Home/modal/search_user_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';

class AllGroupListController extends GetxController {
 RxList<Rx<GroupResults>> groupResults= <Rx<GroupResults>>[].obs;
  RxString errorMessage = ''.obs;

 RxBool timeLineLoading = false.obs;
 RxBool isFetchingMore = false.obs;

 RxInt currentPage = 1.obs;
 RxInt limit = 10.obs;
 RxInt totalPages = 1.obs;

 Future<void> fetchGroupList( {bool isLoadMore=false }) async {
   if (isLoadMore && isFetchingMore.value) return;
   if(isLoadMore){
     isFetchingMore.value= true;
   }else{
     timeLineLoading.value=true;
     currentPage.value = 1;
   }

   try {
     String url= '${ApiConstants.allGroupListUrl}?page=${currentPage.value}&limit=${limit.value}';
     String token = await PrefsHelper.getString('token');
     var headers = {'Authorization': 'Bearer $token'};
     var request = http.Request('GET', Uri.parse(url));
     request.headers.addAll(headers);
     var response = await request.send();
     var responseBody = await response.stream.bytesToString();
     final responseData = jsonDecode(responseBody);
     if (response.statusCode == 200) {

       var attributes = responseData['data']['attributes'] as Map<String, dynamic>? ??{};
       var results = (attributes['results'] as List<dynamic>?) ?? [];
       if(isLoadMore){
         groupResults.addAll(results.map((result) => GroupResults.fromJson(result).obs));
       }else{
         groupResults.assignAll(results.map((result) => GroupResults.fromJson(result).obs).toList());
       }
       totalPages.value = attributes['totalPages'] ?? totalPages.value;
       print(groupResults);
       print('Check timeline post: $results');
       print('Check timeline post: $groupResults');

     } else {
       errorMessage.value = 'Failed to load data';
     }
   } catch (e) {
     errorMessage.value = 'Something went wrong';
   }finally{
     if(isLoadMore){
       isFetchingMore.value= false;
     }else{
       timeLineLoading.value=false;
     }
   }

 }
 loadMorePost()async{
   print('Total Pages: ${totalPages.value}');
   print('Current Page: ${currentPage.value}');
   if(currentPage.value <= totalPages.value && !isFetchingMore.value){
     currentPage.value += 1;
     await fetchGroupList(isLoadMore: true);
   }
 }
}
