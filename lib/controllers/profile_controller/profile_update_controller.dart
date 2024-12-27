import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_check.dart';
import 'package:jobless/service/api_client.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class ProfileUpdateController extends GetxController {
  final ProfileController profileController = Get.put(ProfileController());
  final ProfileController _profileControllerForBioScreen=Get.put(ProfileController(),tag: 'bio_screen');
  final ProfileController _profileControllerForPersonalInfo = Get.put(ProfileController(),tag: 'personalInfoScreen');
  final ProfileController _profileControllerForMyProfile= Get.put(ProfileController(),tag: 'myProfile');

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController jobExperienceCtrl = TextEditingController();
  final TextEditingController jobLessCategoryCtrl = TextEditingController();
  final TextEditingController pastExperienceCtrl = TextEditingController();
  final TextEditingController futurePlanCtrl = TextEditingController();
  final TextEditingController aboutCtrl = TextEditingController();

  // Fetch and populate the profile details
  Future<void> getProfileId() async {
    String? authorId = await PrefsHelper.getString('authorId');
    await profileController.fetchProfile(authorId);

    // Populate controllers after fetching profile
    fullNameController.text = profileController.profile.value.fullName ?? '';
    emailController.text = profileController.profile.value.email ?? '';
    phoneNumberController.text = profileController.profile.value.phoneNumber ?? '';
    genderController.text = profileController.profile.value.gender ?? '';
    dateOfBirthController.text = profileController.profile.value.dataOfBirth ?? '';
    addressController.text = profileController.profile.value.address ?? '';
    skillsController.text = profileController.profile.value.skills ?? '';
    bioController.text = profileController.profile.value.bio ?? '';
    pastExperienceCtrl.text = profileController.profile.value.pastExperiences ?? '';
    futurePlanCtrl.text = profileController.profile.value.futurePlan ?? '';
    jobLessCategoryCtrl.text = profileController.profile.value.jobLessCategory.toString();
    jobExperienceCtrl.text = profileController.profile.value.jobExperience.toString();
    aboutCtrl.text = profileController.profile.value.about.toString();
  }

  RxString phoneNumber = ''.obs;
  RxString address = ''.obs;
  String? gender;
  bool isChecked = false;
  List<String> genderList = ['Male', 'Female', 'Other'];

  RxList<String> categoriList = <String>[].obs;
  RxString selectedDate = 'Select Date Time'.obs;
  String responseMessage = '';
  File? selectedImage;
  var imagePath = ''.obs;

  // Image picker method for camera
  Future<void> pickImageFromCameraToUpdateProfile(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);

    if (returnImage == null) return;

    selectedImage = File(returnImage.path);
    imagePath.value = selectedImage!.path;

    update(); // Updates the UI
    print('ImagePath: ${imagePath.value}');
    Get.back(); // Dismiss the image picker dialog
  }

  // Date selection logic
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1725),
        lastDate: DateTime(2050));

    if (picked != null && picked.toString() != selectedDate.value) {
      selectedDate.value = DateFormat('dd/MM/yyyy').format(picked);
      print('Selected Date: ${selectedDate.value}');
      update();
    }
  }

  var registerLoading = false.obs;

  Future<void> updateProfile() async {
    try {
      registerLoading.value= true;
      String token = await PrefsHelper.getString('token');
      String authorId = await PrefsHelper.getString('authorId');

      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data'
      };

      Map<String, String> body = {
        'fullName': fullNameController.text,
        'email': emailController.text,
        'role': 'user',
        'phoneNumber': phoneNumber.value,
        'dataOfBirth': selectedDate.value,
        'gender': gender ?? '',
       if(categoriList.isNotEmpty) 'jobLessCategory': jsonEncode(categoriList),
        'address': addressController.text,
        'bio': bioController.text,
        'skills': skillsController.text,
        'pastExperiences': pastExperienceCtrl.text,
        'futurePlan': futurePlanCtrl.text,
        'about': aboutCtrl.text,
      };

      // Create a MultipartRequest for the profile update
      var request = http.MultipartRequest('PATCH', Uri.parse(ApiConstants.updateProfileUrl(authorId)));

      // Add headers and fields to the request
      request.headers.addAll(headers);
      request.fields.addAll(body);

      // Check if an image is selected for upload
      if (selectedImage != null) {
        final mimeType = lookupMimeType(selectedImage!.path) ?? 'image/jpeg';
        final mimeTypeData = mimeType.split('/');

        request.files.add(http.MultipartFile(
          'image', // This should match your API's expected file key
          selectedImage!.readAsBytes().asStream(),
          selectedImage!.lengthSync(),
          filename: selectedImage!.path.split('/').last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }


      var response = await request.send();

      if (response.statusCode == 200 ) {
        await _profileControllerForBioScreen.fetchProfile(authorId);
        await _profileControllerForPersonalInfo.fetchProfile(authorId);
        await _profileControllerForMyProfile.fetchProfile(authorId);
        var responseBody = await http.Response.fromStream(response);
        print('Profile updated successfully: ${responseBody.body}');
         var decodedBody=jsonDecode(responseBody.body);
        Get.showSnackbar(GetSnackBar(message:decodedBody['message'].toString() ,duration: const Duration(seconds: 2),snackPosition: SnackPosition.TOP,maxWidth: 330.w,borderRadius: 15,));
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in updating profile: $e');
      registerLoading(false);
    }finally{
      registerLoading.value= false;
    }
  }
}
