import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/auth_controller/change_password_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:lottie/lottie.dart' ;

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';
import '../../../base/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
 const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController _changePasswordController = ChangePasswordController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String email='';
@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__){
      getEmail();
    });

  }
  getEmail(){
    String mail=Get.arguments['email'];
    if(mail.isNotEmpty){
      email=mail;
    }
    print(email);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: AppColors.textColor,
              )),
        ),
        title: Text(AppString.changePasswordText,
            style: AppStyles.h2(
              family: "Schuyler",
            )),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /* /// Old Password
                SizedBox(
                  height: 10.h,
                ),
                Text('Old Password (Optional)', style: AppStyles.h4(family: "Schuyler")),
                SizedBox(height: 10.h),
                CustomTextField(
                  contentPaddingVertical: 12.h,
                  hintText: "Enter Old Password",
                  // isPassword: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SvgPicture.asset(AppIcons.passwordIcon),
                  ),
                  controller: _changePasswordController.oldPassCtrl,
                  validator: (value){
                    if(value){}
                  },
                ),*/

                /// New Password
                SizedBox(height: 10.h),
                Text('New Password', style: AppStyles.h4(family: "Schuyler")),
                SizedBox(height: 10.h),
                CustomTextField(
                  contentPaddingVertical: 12.h,
                  hintText: "Enter New Password",
                  isPassword: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SvgPicture.asset(AppIcons.passwordIcon),
                  ),
                  controller: _changePasswordController.newPassCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter new password';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: 10.h,
                ),
                Text('Confirm Password', style: AppStyles.h4(family: "Schuyler")),
                SizedBox(height: 10.h),
                CustomTextField(
                  contentPaddingVertical: 12.h,
                  hintText: "Confirm your Password",
                  isPassword: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SvgPicture.asset(AppIcons.passwordIcon),
                  ),
                  controller: _changePasswordController.confirmPassCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your password';
                    } else if (value != _changePasswordController.newPassCtrl.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 55.h),

                /// Button
                CustomButton(
                    onTap: () async {
                       if (_formKey.currentState!.validate()) {
                        final result = await _changePasswordController.resetPassword();
                        result.fold((failureMessage) {
                          Get.snackbar('Failure', failureMessage);
                        }, (is200) {
                          showStatusOnChangePasswordResponse(context);
                        });
                      }
                    },
                    text: AppString.changePasswordText)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showStatusOnChangePasswordResponse(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.sp)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
             SizedBox(
               height: 170.h,
                 child: Lottie.asset('assets/lotti/success_lotti.json')),
               SizedBox(height: 20.h),
              // Text
              Text(
                AppString.passwordChangedText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
               SizedBox(height: 10.h),
              Text(
                AppString.returnToTheLoginPageText,textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
              SizedBox(height: 20.h),
              // Elevated Button
              Padding(
                padding:  EdgeInsets.only(bottom: 20.h),
                child: CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.loginScreen);
                    }, text: 'Back To Login'),
              )
            ],
          ),
        );
      },
    );
  }
}
