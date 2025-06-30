
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/profile_controller/account_delete_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/base/custom_text_field.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';
import '../../Widget/customListtile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:  AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.arrow_back_ios,size: 18,color: AppColors.textColor,)),
        ),

        title: Text(AppString.settionText,style: AppStyles.h2(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),

      body: Column(
        children: [
          /// Change Password
          SizedBox(height: 16.h),
          Customlisttile(
            title:AppString.changePasswordText,
            icon: AppIcons.passwordIcon,
            onTap: (){
              Get.toNamed(AppRoutes.passwordChangeScreen,arguments: {'email':Get.arguments['email']});
            },
          ),
         /// Privacy setting
          SizedBox(height: 16.h),
          Customlisttile(
            title:AppString.privacyText,
            icon: AppIcons.privaciIcon,
            onTap: (){
              Get.toNamed(AppRoutes.privacyScreen);
            },
          ),
          /// Term & Condition
          SizedBox(height: 16.h),
          Customlisttile(
            title:AppString.termConditionText,
            icon: AppIcons.termIcon,
            onTap: (){
              Get.toNamed(AppRoutes.termsScreen);
            },
          ),
          /// about screen
          SizedBox(height: 16.h),
          Customlisttile(
            title:AppString.aboutusText,
            icon: AppIcons.aboutIcon,
            onTap: (){
              Get.toNamed(AppRoutes.aboutsScreen);
            },
          ),
         /// support screen
          SizedBox(height: 16.h),
          Customlisttile(
            title:AppString.supportText,
            icon: AppIcons.supportIcon,
            onTap: (){
              Get.toNamed(AppRoutes.supportScreen);
            },
          ),
         Spacer(),

          /// Delete Account
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
                fixedSize: WidgetStateProperty.all(Size(350.w, 50.h)),
              backgroundColor: WidgetStateProperty.all(Colors.pink[50]), // Light pink background color
              foregroundColor: WidgetStateProperty.all(Colors.red), // Red color for text and icon
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners
              )),
              padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 16)), // Padding to make it look more like the design
            ),
            onPressed: () {
              showDeleteBottomSheet(context);
            },
            label: Text('Delete Account',style: AppStyles.h4(),),
            icon: Icon(Icons.delete),
          ),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }

  // Bottom Sheet Function
  void showDeleteBottomSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AccountDeleteController accountDeleteController = Get.put(AccountDeleteController());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            padding: EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Warning Icon and Title
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Delete Account',
                          style: AppStyles.h3().copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Description
                  Text(
                    'All your changes will be deleted and you will no longer be able to access them.',
                    style: AppStyles.h6().copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Password Field Label
                  Text(
                    'Enter your password to confirm',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Password Field
                  CustomTextField(
                      contentPaddingVertical: 14.h,
                      isPassword: true,
                      isObscureText: true,
                      suffixIcon: Icon(Icons.lock_outline),
                      controller: accountDeleteController.passCtrl),
                  SizedBox(height: 24.h),

                  // Action Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: CustomOutlineButton(onTap: (){
                          Get.back();
                        }, text: 'Cancel'),
                      ),
                      SizedBox(width: 12.w),

                      // Delete Button
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: CustomButton(
                              onTap: (){
                                if(accountDeleteController.passCtrl.text.isNotEmpty){

                                }else{
                                  Get.snackbar('Empty Field', ' Please write your password');
                                }
                              }, text: 'Delete'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
