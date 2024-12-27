import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_button.dart';

import '../../../controllers/auth_controller/signup_controller.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_string.dart';
import '../../../utils/style.dart';
import '../../base/custom_text_field.dart';
import '../../base/image_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignupController _signUpCtrl = Get.put(SignupController());

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) {
      if ((Get.arguments['categoryList'] as List).isNotEmpty == true &&
          (Get.arguments['jobExperience'] as bool) != null) {
        _initialArgument();
      }
      if ((Get.arguments['address'] as String).isNotEmpty) {
        _initialAddressArgument();
      }
    });
  }

  _initialArgument() {
    if (Get.arguments['categoryList'] != null &&
        Get.arguments['jobExperience'] != null) {
      _signUpCtrl.categoriList.value =
          List<String>.from(Get.arguments['categoryList']);
      _signUpCtrl.isJobExperience.value = Get.arguments['jobExperience'];
    }
  }

  _initialAddressArgument() {
    _signUpCtrl.address.value = Get.arguments['address'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Obx(() => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 55.h,
                    ),
                    Text(AppString.creareAccountText, style: AppStyles.h1()),
                    Text(AppString.subCreateText, style: AppStyles.h5()),

                    const SizedBox(
                      height: 20,
                    ),

                    /// Upload Picture
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              ShowImagePickerRegister().showImagePickerOption(context);
                            },
                            child: _signUpCtrl.imagePath.isNotEmpty
                                ? Container(
                                    height: 120.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: Color(0xffF9F6F1),
                                      border: Border.all(
                                          color: AppColors.primaryColor),
                                      image: DecorationImage(
                                          image: FileImage(
                                            File(_signUpCtrl.imagePath.value),
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  )
                                : Container(
                                    height: 120.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: Color(0xffF9F6F1),
                                      border: Border.all(
                                          color: AppColors.primaryColor),
                                    ),
                                    child: Center(
                                        child: SvgPicture.asset(
                                      AppIcons.cameraIcon,
                                      height: 48.h,
                                      width: 48.w,
                                    )),
                                  ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(AppString.uploadProfilePictureText,
                              style: AppStyles.h5()),
                        ],
                      ),
                    ),

                    /// TextField Section
                    Text(AppString.nameText,
                        style: AppStyles.h4(family: "Schuyler")),
                    SizedBox(height: 10.h),
                    CustomTextField(
                        contentPaddingVertical: 12.h,
                        hintText: "Enter Name",
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SvgPicture.asset(AppIcons.profileIcon),
                        ),
                        controller: _signUpCtrl.nameCtlr),

                    /// Email
                    SizedBox(
                      height: 10.h
                    ),
                    Text(AppString.emailText,
                        style: AppStyles.h4(family: "Schuyler")),
                    SizedBox(height: 10.h),
                    CustomTextField(
                        contentPaddingVertical: 12.h,
                        hintText: "Enter Email",
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SvgPicture.asset(AppIcons.emailIcon),
                        ),
                        controller: _signUpCtrl.emailCtlr),

                    /// Phone Number
                    SizedBox(height: 10.h),
                    Text('${AppString.phoneText} (optional)',
                        style: AppStyles.h4(family: "Schuyler")),
                    SizedBox(
                      height: 10.h
                    ),
                    IntlPhoneField(
                      decoration: InputDecoration(
                          hintText: "Phone Number",
                          contentPadding: EdgeInsets.symmetric(horizontal: 15.h)),
                      showCountryFlag: true,
                      validator: (value) {
                        /* if (value == null || value.number.isEmpty) {
                              return 'Enter your Phone Number';
                            }*/
                        // Check if the phone number contains only digits and has a valid length (adjust if necessary)
                        if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value?.number ?? '')) {
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
                        setState(() {
                          _signUpCtrl.phoneNumber.value =
                              phone.completeNumber.isNotEmpty
                                  ? phone.completeNumber.toString()
                                  : '';
                        });
                      },
                    ),

                    /// Select Gender
                    SizedBox(height: 10.h),
                    Text(AppString.genderText,
                        style: AppStyles.h4(family: "Schuyler")),
                    SizedBox(
                      height: 10.h,
                    ),
                    DropdownButtonFormField<String>(
                      /// Dropdown button field======================<<<<<<<<
                      value: _signUpCtrl.gender,
                      padding: EdgeInsets.zero,
                      hint: Text("Select Gender"),
                      decoration: InputDecoration(),
                      items: _signUpCtrl.genderList
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
                          _signUpCtrl.gender = newValue;
                          print('Gender>>>${_signUpCtrl.gender}');
                        });
                      },
                    ),

                    /// Select Date
                    SizedBox(height: 10.h),
                    Text(AppString.dateOfBirthText, style: AppStyles.h4(family: "Schuyler")),
                    SizedBox(height: 10.h),
                    Obx(() => GestureDetector(
                          onTap: () async {
                            _signUpCtrl.selectDate(context);
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Get.theme.primaryColor.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(14.r),
                                color: AppColors.fillColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _signUpCtrl.selectedDate != null
                                        ? _signUpCtrl.selectedDate.value
                                        : 'Select your Date of Birth',
                                    // age(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal)
                                  ),
                                  SvgPicture.asset(AppIcons.calenderIcon)
                                ],
                              ),
                            ),
                          ),
                        )),

                    SizedBox(height: 10.h),
                    Text(AppString.passawordText,
                        style: AppStyles.h4(family: "Schuyler")),
                    SizedBox(height: 10.h),
                    CustomTextField(
                        contentPaddingVertical: 12.h,
                        hintText: "Password",
                        isPassword: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SvgPicture.asset(AppIcons.passwordIcon),
                        ),
                        controller: _signUpCtrl.passWordCtlr),

                    SizedBox(
                      height: 10.h,
                    ),
                    Text("Confirm Password",
                        style: AppStyles.h4(family: "Schuyler")),
                    SizedBox(height: 10.h),
                    CustomTextField(
                        contentPaddingVertical: 12.h,
                        hintText: "Confirm Password",
                        isPassword: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SvgPicture.asset(AppIcons.passwordIcon),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your confirm password';
                          } else if (value != _signUpCtrl.passWordCtlr.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        controller: _signUpCtrl.confirmPassCtlr),

                    SizedBox(height: 16.h),

                    /// Condition Check Box
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _signUpCtrl.isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _signUpCtrl.isChecked = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            AppString.signUoConditionText,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.h6(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    ///==============Action Button========
                    Obx(() {
                      return CustomButton(
                          loading: _signUpCtrl.registerLoading.value,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await _signUpCtrl.createRegistration();
                            }
                          },
                          text: AppString.signupText);
                    }),

                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.loginScreen);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Already have an account? ",
                              style: AppStyles.customSize(
                                  size: 14,
                                  family: "Schuyler",
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subTextColor)),
                          Text("Login",
                              style: AppStyles.customSize(
                                  size: 15,
                                  family: "Schuyler",
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor)),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 25.h,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
