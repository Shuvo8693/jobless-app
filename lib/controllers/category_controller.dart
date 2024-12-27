
import 'package:get/get.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/onboarding_screen/model/category_model.dart';

class CategoryController extends GetxController {
  var registerLoading = false.obs;

  RxList<Attribute> categoryAttributes = <Attribute>[].obs;

  Future<void> fetchCategory() async {
    var headers = {
      'Content-Type': 'application/json',
    };
    Response response = await ApiClient.getData(ApiConstants.categoryUrl, headers: headers);
    if (response.statusCode == 200) {
      var responseData = response.body;

      var attributeList = responseData['data']['attributes'] as List;

      categoryAttributes.assignAll(attributeList.map((e) => Attribute.fromJson(e)).toList());

      print(categoryAttributes);
      update();
    } else {
      print('Error>>>');
      print('Error>>>${response.body}');
      ApiChecker.checkApi(response);
      registerLoading(false);
      update();
    }
  }
}
