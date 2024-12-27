import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:mime/mime.dart';


class SendPersonalMessageController extends GetxController {
  RxString responseMessage = ''.obs;
  RxBool isLoading = false.obs;
  File? selectedIMage;
  var imagePath=''.obs;

 /* Future pickImageFromCamera(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedIMage = File(returnImage.path);
    imagePath.value=selectedIMage!.path;
    //  image = File(returnImage.path).readAsBytesSync();
    update();
    print('ImagesPath:$imagePath');
    Get.back();
  }*/


  sendPersonalMessage({required String profileId }) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      Map<String, String> body = {
        'profileId': profileId,
        'type': 'personal',
      };
      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.createChatUrl));

      // Add headers and fields to the request
      request.headers.addAll(headers);
      request.fields.addAll(body);

      // Check if an image is selected for upload
     /* if (selectedIMage != null) {
        final mimeType = lookupMimeType(selectedIMage!.path) ?? 'image/jpeg';
        final mimeTypeData = mimeType.split('/');

        request.files.add(http.MultipartFile(
          'coverImage', // This should match your API's expected file key
          selectedIMage!.readAsBytes().asStream(),
          selectedIMage!.lengthSync(),
          filename: selectedIMage!.path.split('/').last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }*/

      var response = await request.send();
      var responseBody= await http.Response.fromStream(response);
      final responseData = jsonDecode(responseBody.body);
      if (response.statusCode == 201) {
        responseMessage.value = responseData['message'];
        Get.offNamed(AppRoutes.messageScreen);
      } else {
        print('Error>>>');
        responseMessage.value = responseData['message'];
        Get.snackbar('success', responseMessage.value);
      }
    } on Exception catch (error) {
      print(error.toString());
      responseMessage.value = 'Something wen wrong';
      Get.snackbar('success', responseMessage.value);
    }finally{
      isLoading.value=false;
    }
  }
}
