import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';

class PostController extends GetxController {
  RxString commentMessage = ''.obs;
 RxBool isLoading=false.obs;
  createPost(String? content, String filePath,String privacy) async {
    String token = await PrefsHelper.getString('token');
    String authorId = await PrefsHelper.getString('authorId');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    Map<String, String> body = {
      'content': content ?? '',
      'author': authorId,
      'privacy': privacy
    };



    try {
      isLoading.value = true;
      var request =  http.MultipartRequest('POST', Uri.parse(ApiConstants.createPostUrl));
      request.fields.addAll(body);

      File fileData = File(filePath);
      if(fileData.path.isNotEmpty ){
        await _addFileToRequest(request, fileData);
      }

      request.headers.addAll(headers);

      // Print request body fields and files
      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files.map((file) => file.filename)}');

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        var responseData = jsonDecode(responseBody);
        commentMessage.value = responseData['message'];
        print("Response Success (201): $responseBody");
        Get.offNamed(AppRoutes.homeScreen);
        Get.snackbar('Success', commentMessage.value);
      } else {
        var errorData = jsonDecode(responseBody);
        commentMessage.value = errorData['message'] ?? 'Something went wrong';
        print("Response Error (${response.statusCode}): $responseBody");
        Get.snackbar('Failed', commentMessage.value);
      }
      update();
    } on Exception catch (e) {
      print(e.toString());
      commentMessage.value = 'An error occurred while uploading the file.';
      Get.snackbar('Failed', commentMessage.value);
    }finally{
      isLoading.value=false;
    }
  }

  // Helper method to add file based on its type
   _addFileToRequest(http.MultipartRequest request, File file) async {
    String fileName = file.path.split('/').last;
    String fileType = fileName.split('.').last.toLowerCase();
    if (fileType == 'pdf') {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      ));
      debugPrint("Media type pdf ==== $fileName");
    } else if (fileType == 'mp4') {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
        filename: fileName,
        contentType: MediaType('video', 'mp4'),
      ));
      debugPrint("Media type mp4 ==== $fileName");
    } else if (fileType == 'png') {
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
