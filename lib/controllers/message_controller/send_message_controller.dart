import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobless/controllers/message_controller/web_socket_controller.dart';

import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';

class SendMessageController extends GetxController {
  WebSocketController? webSocketController;
  SendMessageController({this.webSocketController});
  RxString commentMessage = ''.obs;
  File? selectedIFile;
  var filePath=''.obs;
  RxBool isLoading=false.obs;

 sendMessage(String? message, String filePath,dynamic receiverId,dynamic chatId) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    Map<String, String> body = {
      'message': message ?? '',
      'chatId': chatId,
      'receiverId': receiverId,
    };

    var request =  http.MultipartRequest('POST', Uri.parse(ApiConstants.sendMessageUrl));
    request.fields.addAll(body);

    File fileData = File(filePath);

    try {
      // Determine file type and add it to the request
      isLoading.value=true;
      if(fileData.path !=null && fileData.path.isNotEmpty){
        await _addFileToRequest(request, fileData);
      }

      request.headers.addAll(headers);

      // Print request body fields and files
      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files.map((file) => file.filename)}');

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        webSocketController?.initSocket();
        var responseData = jsonDecode(responseBody);
        commentMessage.value = responseData['message'];
        print("Response Success (201): $responseBody");
      } else {
        var errorData = jsonDecode(responseBody);
        commentMessage.value = errorData['message'] ?? 'Something went wrong';
        print("Response Error (${response.statusCode}): $responseBody");
        Get.snackbar('Failed', commentMessage.value);
      }
    } on Exception catch (e) {
      print(e.toString());
      commentMessage.value = 'An error occurred while uploading the file.';
      Get.snackbar('Failed', commentMessage.value);
    }finally{
      isLoading.value=false;
    }
  }

   pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    selectedIFile = File(returnImage.path);
    filePath.value=selectedIFile!.path;
    print('ImagesPath:$filePath');
    if(filePath.value.isNotEmpty){
      Get.snackbar('File selected', '');
    }
  }

  // Helper method to add file based on its type
  _addFileToRequest(http.MultipartRequest request, File file) async {
    String fileName = file.path.split('/').last;
    String fileType = fileName.split('.').last.toLowerCase();

    if (fileType == 'png') {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
        filename: fileName,
        contentType: MediaType('image', 'png'),
      ));
      debugPrint("Media type png ==== $fileName");
    } else if (fileType == 'jpg' || fileType == 'jpeg') {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
        filename: fileName,
        contentType: MediaType('image', fileType),
      ));
      debugPrint("Media type $fileType ==== $fileName");
    } else {
      debugPrint("Unsupported media type: $fileName");
      throw Exception('Unsupported file type');
    }
  }


}
