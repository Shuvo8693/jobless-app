
import 'package:get/get.dart';

import '../helpers/prefs_helpers.dart';
import '../utils/app_constants.dart';


class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false})async{
    if(response.statusCode != 200){
      if(response.statusCode == 401) {
        // Get.put(AuthController()).clearSharedData();
        await PrefsHelper.remove(AppConstants.bearerToken);
        // Get.offAllNamed(AppRoutes.roleSelectScreen);
      }else {
        //showToastMessage.showMessage(response.statusText!,);
      }


    }


  }
}