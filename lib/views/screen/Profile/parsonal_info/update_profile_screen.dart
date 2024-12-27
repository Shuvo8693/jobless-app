import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jobless/controllers/category_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_update_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_text_field.dart';
import 'package:jobless/views/base/image_dialog.dart';
import 'package:jobless/views/screen/Widget/custom_form_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());

  final ProfileUpdateController _profileUpdateCtrl = Get.put(ProfileUpdateController());
  CategoryController categoryController = Get.put(CategoryController());
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _profileUpdateCtrl.getProfileId();
    categoryController.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Obx(() => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),

                  /// Upload Picture
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ShowImagePickerRegister().showImagePickerUpdateProfileOption(context);
                              },
                              child: _profileUpdateCtrl
                                      .imagePath.value.isNotEmpty
                                  ? Container(
                                      height: 120.h,
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.r),
                                        color: const Color(0xffF9F6F1),
                                        border: Border.all(color: AppColors.primaryColor),
                                        image: DecorationImage(
                                            image: FileImage(
                                              File(_profileUpdateCtrl.imagePath.value),
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                          height: 100.h,
                                          width: 100.w,
                                          child: _profileController.profile.value.image?.isNotEmpty ==
                                                  true
                                              ? Image.network("${ApiConstants.imageBaseUrl}${_profileController.profile.value.image}",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/image/person.jpg',
                                                  fit: BoxFit.cover)),
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_profileController.profile.value.fullName}",
                                    style: AppStyles.customSize(
                                      size: 14,
                                      fontWeight: FontWeight.w500,
                                      family: "Schuyler",
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                _profileController.profile.value.jobExperience==true?  Row(
                                    children: [
                                      SvgPicture.asset(AppIcons.starIcon),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      SizedBox(
                                        width: 175.w,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_profileController.profile.value.jobLessCategory?.take(2).join(',')??'', style: AppStyles.h6()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ): SizedBox.shrink(),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text('Update profile Picture', style: AppStyles.h6()),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),

                  /// TextField Section
                  Text('${AppString.nameText} (required)', style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                      contentPaddingVertical: 12.h,
                      hintText: "Enter Name",
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SvgPicture.asset(AppIcons.profileIcon),
                      ),
                      controller: _profileUpdateCtrl.fullNameController),

                  /// Email
                  SizedBox(height: 10.h),
                  Text('${AppString.emailText} (required)', style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                      contentPaddingVertical: 12.h,
                      hintText: "Enter Email",
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SvgPicture.asset(AppIcons.emailIcon),
                      ),
                      controller: _profileUpdateCtrl.emailController),
                  ///Address
                  SizedBox(height: 10.h),
                  Text('Address',
                      style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                      contentPaddingVertical: 12.h,
                      hintText: "Enter Address",
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SvgPicture.asset(AppIcons.locationIcon),
                      ),
                      controller: _profileUpdateCtrl.addressController),

                  /// Phone Number
                  SizedBox(height: 10.h),
                  Text('${AppString.phoneText} (optional)', style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(
                    height: 10.h,
                  ),
                  IntlPhoneField(
                    controller: _profileUpdateCtrl.phoneNumberController,
                    decoration: InputDecoration(
                        hintText: "Phone Nomber",
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.h)),
                    showCountryFlag: true,
                    validator: (value) {
                      // Check if value is null or empty
                      // Check if the phone number contains only digits and has a valid length (adjust if necessary)
                      if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value!.number)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                    initialCountryCode: 'US',
                    flagsButtonMargin: EdgeInsets.only(left: 10),
                    disableLengthCheck: true,
                    dropdownIconPosition: IconPosition.trailing,
                    // Default country code
                    onChanged: (phone) {
                      print(
                          "Phpone>>>${phone.completeNumber}"); // Gets the complete phone number including the country code
                      if (phone.completeNumber.isNotEmpty) {
                        setState(() {
                          _profileUpdateCtrl.phoneNumber.value = phone.completeNumber.toString();
                        });
                      }
                    },
                  ),

                  /// Select Gender
                  SizedBox(height: 10.h),
                  Text('${AppString.genderText} (required)', style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropdownButtonFormField<String>(
                    value: _profileUpdateCtrl.gender,
                    padding: EdgeInsets.zero,
                    hint: Text("Select Gender"),
                    decoration: InputDecoration(),
                    items: _profileUpdateCtrl.genderList
                        .map((gender) => DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select your gender';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        _profileUpdateCtrl.gender = newValue;
                        print('Gender>>>${_profileUpdateCtrl.gender}');
                      });
                    },
                  ),

                  /// Select Date
                  SizedBox(height: 10.h),
                  Text(AppString.dateOfBirthText,
                      style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(() => GestureDetector(
                        onTap: () async {
                          _profileUpdateCtrl.selectDate(context);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(14.r),
                              color: AppColors.fillColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _profileUpdateCtrl.selectedDate != null
                                      ? _profileUpdateCtrl.selectedDate.value
                                      : 'Select your Date of Birth',
                                  // age(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal)
                                ),
                                SvgPicture.asset(AppIcons.calenderIcon)
                              ],
                            ),
                          ),
                        ),
                      )),

                  ///Skill
                  SizedBox(height: 10.h),
                  Text('Skill', style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                      contentPaddingVertical: 12.h,
                      hintText: "Skill",
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SvgPicture.asset(AppIcons.skillIcon),
                      ),
                      controller: _profileUpdateCtrl.skillsController),
                   /// Past experiance
                  SizedBox(height: 10.h),
                  Text("Past Experience", style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    contentPaddingVertical: 25.h,
                    maxLine: 3,
                    hintText: "Past Experience",
                    controller: _profileUpdateCtrl.pastExperienceCtrl,
                  ),
                  /// Future plan
                  SizedBox(height: 10.h),
                  Text("Future Plan", style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    contentPaddingVertical: 25.h,
                    maxLine: 3,
                    hintText: "Future Plan",
                    controller: _profileUpdateCtrl.futurePlanCtrl,
                  ),
                   ///About
                  SizedBox(height: 10.h),
                  Text("About", style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    contentPaddingVertical: 25.h,
                    maxLine: 3,
                    hintText: "about",
                    controller: _profileUpdateCtrl.aboutCtrl,
                  ),
                   /// Bio
                  SizedBox(height: 10.h),
                  Text("Bio", style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    contentPaddingVertical: 25.h,
                    maxLine: 3,
                    hintText: "Bio",
                    controller: _profileUpdateCtrl.bioController,
                  ),
                  /// Jobless category
                   SizedBox(height: 10.h),
                  Text("Job less category", style: AppStyles.h4(family: "Schuyler")),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 250.h,
                    child: Obx(() {
                      if (categoryController.categoryAttributes.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return AlignedGridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        itemCount: categoryController.categoryAttributes.length,
                        crossAxisSpacing: 14,
                        itemBuilder: (context, index) {
                          final categoryIndex = categoryController.categoryAttributes[index];

                          bool isSelect = _profileUpdateCtrl.categoriList.contains(categoryIndex.status);
                          return InkWell(
                            onTap: () {
                              if (isSelect) {
                                _profileUpdateCtrl.categoriList.remove(categoryIndex.status);
                                print("CategoliList>>>${_profileUpdateCtrl.categoriList}");
                              } else {
                                _profileUpdateCtrl.categoriList.add(categoryIndex.status!);
                                print("CategoliList>>>${_profileUpdateCtrl.categoriList}");
                              }
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelect
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(color: AppColors.primaryColor)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                    child: Text(categoryIndex.status ?? '',
                                      style: AppStyles.h6(
                                        color:
                                        isSelect ? Colors.white : AppColors.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                /*  CustomTextField(
                    contentPaddingVertical: 25.h,
                    maxLine: 4,
                    hintText: "Job less category",
                    controller: _profileUpdateCtrl.jobLessCategoryCtrl,
                  ),*/

                  SizedBox(height: 16.h),

                  ///==============Action Button========
                  Obx((){
                    return  CustomButton(
                        loading: _profileUpdateCtrl.registerLoading.value,
                        onTap: () async {
                          await _profileUpdateCtrl.updateProfile();
                        },
                        text: AppString.updateProfileText);
                  }

                  ),

                  SizedBox(
                    height: 25.h,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
