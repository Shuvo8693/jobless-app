import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';

import 'model/my_friend_search_model.dart';

class SearchMyFriendController extends GetxController {
  Rx<MyFriendSearchModel> myFriendSearchModel=MyFriendSearchModel().obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;
 /* RxList<bool> isSelected = <bool>[].obs; // Observable list for selections
  RxList<Friends> selectedUsers = <Friends>[].obs; // List to store selected users
   initializeSelection(int length){
     print('length>>>>$length');
    return isSelected.value = List.filled(length, false);
  }
  void toggleUserSelection(int index,Friends friends){
    isSelected[index]=!isSelected[index];
    if(isSelected[index]){
      selectedUsers.add(friends);
    }else{
      selectedUsers.remove(friends);
    }
    print(selectedUsers);
  }*/
  fetchMyFiendList(String name) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      var request = http.Request('GET', Uri.parse(ApiConstants.searchMyFriendListUrl(name)));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        myFriendSearchModel.value = MyFriendSearchModel.fromJson(responseData);
        print(myFriendSearchModel.value.toString());
      } else {
        print('Error>>>');
        isLoading.value=false;
        errorMessage.value = 'Failed to load data';
      }
    } on Exception catch (error) {
      print(error.toString());
      isLoading.value=false;
      errorMessage.value = 'Something wen wrong';
    }
  }
  @override
  void onClose() {
    myFriendSearchModel.close();
    super.onClose();
  }
}
