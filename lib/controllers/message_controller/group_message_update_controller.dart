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

import 'chat_list_controller.dart';

class GroupMessageUpdateController extends GetxController {
  final ChatListController _chatListController=Get.put(ChatListController());

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



  updateGroupMessage({required String chatId, required String name}) async {
    try {
      isLoading.value=true;
      String token = await PrefsHelper.getString('token');
      Map<String, String> headers = {'Authorization': 'Bearer $token'};
      Map<String, String> body = {
        'name': name,
      };
      var request = http.MultipartRequest('PATCH', Uri.parse(ApiConstants.updateGroupChatUrl(chatId)));

      // Add headers and fields to the request
      request.headers.addAll(headers);
      request.fields.addAll(body);

      // Check if an image is selected for upload
      if (selectedIMage != null) {
        final mimeType = lookupMimeType(selectedIMage!.path) ?? 'image/jpeg';
        final mimeTypeData = mimeType.split('/');

        request.files.add(http.MultipartFile(
          'image', // This should match your API's expected file key
          selectedIMage!.readAsBytes().asStream(),
          selectedIMage!.lengthSync(),
          filename: selectedIMage!.path.split('/').last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),);
      }

      // Send the multipart request
      var response = await request.send();
      var responseBody= await http.Response.fromStream(response);
      final responseData = jsonDecode(responseBody.body);
      if (response.statusCode == 200) {
        await _chatListController.fetchChatList();
        responseMessage.value = responseData['message'];
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
