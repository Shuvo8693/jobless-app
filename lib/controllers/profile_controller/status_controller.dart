import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:http/http.dart' as http;

class StatusController extends GetxController {
  final ProfileController profileController = Get.put(ProfileController());
  final ProfileController _profileControllerForPersonalScreen = Get.put(ProfileController(),tag: 'personalInfoScreen');

  RxBool isJobExperience = false.obs;

  // Fetch and populate the profile details
  Future<void> getProfileId() async {
    String? authorId = await PrefsHelper.getString('authorId');
    await profileController.fetchProfile(authorId);
    isJobExperience.value =
        profileController.profile.value.jobExperience ?? false;
  }

  Future<void> updateStatus() async {
    try {
      String token = await PrefsHelper.getString('token');
      String authorId = await PrefsHelper.getString('authorId');

      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data'
      };

      Map<String, String> body = {
        'jobExperience': isJobExperience.value.toString(),
      };

      // Create a MultipartRequest for the profile update
      var request = http.MultipartRequest(
          'PATCH', Uri.parse(ApiConstants.updateProfileUrl(authorId)));

      request.headers.addAll(headers);
      request.fields.addAll(body);

      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        var responseBody = await http.Response.fromStream(response);
        print('Status updated successfully: ${responseBody.body}');
        var decodedBody = jsonDecode(responseBody.body);
        isJobExperience.value = decodedBody['data']['attributes']['jobExperience'] as bool;
        await _profileControllerForPersonalScreen.fetchProfile(authorId);
        Get.showSnackbar(GetSnackBar(
          message: 'Your Job status is ${isJobExperience.value == true ? 'Active' : 'Inactive'}',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          padding:  const EdgeInsets.all(10),
          maxWidth: 300,
        ));

      } else {
        print('Error: ${response.statusCode}');

      }
    } catch (e) {
      print('Exception in updating profile: $e');
    }
  }
}
