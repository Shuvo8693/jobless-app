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

import 'group_timeline_post_controller.dart';
import 'mygroup_about_controller.dart';

class UpdateMyGroupController extends GetxController {
  final AllGroupAboutController _allGroupAboutController = Get.put(AllGroupAboutController());
  final GroupTimelinePostController _groupTimeLinePostController = Get.put(GroupTimelinePostController());
  RxString responseMessage = ''.obs;
  RxBool isLoading = false.obs;
  File? selectedIMage;
  var imagePath=''.obs;

  Future pickImageFromCamera(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedIMage = File(returnImage.path);
    imagePath.value=selectedIMage!.path;
    //  image = File(returnImage.path).readAsBytesSync();
    update();
    print('ImagesPath:$imagePath');
    Get.back();
  }



  updateGroup({required String groupId,required String name,required String description,bool? isNavigateToCreateGroupMessageScreen=false }) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      Map<String, String> body = {
        'name': name,
        'description': description,
      };
      var request = http.MultipartRequest('PATCH', Uri.parse(ApiConstants.updateGroupUrl(groupId)));

      // Add headers and fields to the request
      request.headers.addAll(headers);
      request.fields.addAll(body);

      // Check if an image is selected for upload
      if (selectedIMage != null) {
        final mimeType = lookupMimeType(selectedIMage!.path) ?? 'image/jpeg';
        final mimeTypeData = mimeType.split('/');

        request.files.add(http.MultipartFile(
          'coverImage', // This should match your API's expected file key
          selectedIMage!.readAsBytes().asStream(),
          selectedIMage!.lengthSync(),
          filename: selectedIMage!.path.split('/').last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }

      // Send the multipart request
      var response = await request.send();
      var responseBody= await http.Response.fromStream(response);
      final responseData = jsonDecode(responseBody.body);
      if (response.statusCode == 200) {
        responseMessage.value = responseData['message'];
        isLoading.value=false;
       await _allGroupAboutController.fetchGroupAbout(groupId);
       await _groupTimeLinePostController.fetchMyGroupPost(groupId: groupId);
        Get.snackbar('success', responseMessage.value);

      } else {
        print('Error>>>');
        responseMessage.value = responseData['message'];
      }
    } on Exception catch (error) {
      print(error.toString());
      responseMessage.value = 'Something wen wrong';
    }finally{
      isLoading.value=false;
    }
  }
}
