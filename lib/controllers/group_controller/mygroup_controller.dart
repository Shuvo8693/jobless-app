import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';

class MyGroupController extends GetxController {
  Rx<GroupModel> groupModel = GroupModel().obs;
  RxString errorMessage = ''.obs;
  RxBool timeLineLoading = false.obs;
  RxBool isFetchingMore = false.obs;

  RxInt currentPage = 1.obs;
  RxInt limit = 8.obs;
  RxInt totalPages = 1.obs;

  Future<void> fetchMyGroupList({bool isLoadMore = false}) async {
    if (isLoadMore && isFetchingMore.value) return;  // Prevent duplicate calls

    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      timeLineLoading.value = true;
      currentPage.value=1;
    }

    try {
      String url = '${ApiConstants.myGroupListUrl}?page=${currentPage.value}&limit=${limit.value}';
      String token = await PrefsHelper.getString('token');
      var headers = {'Authorization': 'Bearer $token'};
      var response = await http.get(Uri.parse(url), headers: headers);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var attributes = responseData['data']?['attributes'] as Map<String, dynamic>? ?? {};
        var results = (attributes['results'] as List<dynamic>?) ?? [];

        if (isLoadMore) {
          // Add new items to the existing list
          groupModel.value.groupData?.groupAttributes?.groupResults?.addAll(results.map((result) => GroupResults.fromJson(result)),
          );
        } else {
          // Initial load
          groupModel.value = GroupModel.fromJson(responseData);

        }

        // Update totalPages if it's available in the response
        totalPages.value = attributes['totalPages'] ?? totalPages.value;
      } else {
        errorMessage.value = 'Failed to load data';
      }
    } catch (error) {
      errorMessage.value = 'Something went wrong';
    } finally {
      if (isLoadMore) {
        isFetchingMore.value = false;
      } else {
        timeLineLoading.value = false;
      }
    }

  }

  Future<void> loadMorePost() async {
    // Load more data only if there are more pages left
    if (currentPage.value < totalPages.value && !isFetchingMore.value) {
      currentPage.value += 1;
      await fetchMyGroupList(isLoadMore: true);
    }
  }
}
