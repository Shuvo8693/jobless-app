
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
                fixedSize: WidgetStateProperty.all(Size(350.w, 60.h)),
              backgroundColor: WidgetStateProperty.all(Colors.pink[50]), // Light pink background color
              foregroundColor: WidgetStateProperty.all(Colors.red), // Red color for text and icon
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners
              )),
              padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 16)), // Padding to make it look more like the design
            ),
            onPressed: () {
              showDeleteDialog(context);
            },
            label: Text('Delete Account',style: AppStyles.h4(),),
            icon: Icon(Icons.delete),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        AccountDeleteController accountDeleteController = Get.put(AccountDeleteController());

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Form(
              key: formKey,
              child: AlertDialog(
                title: Text('Do you want to delete your account?', style: AppStyles.h3()),
                content: SingleChildScrollView(  // Add scrollable content
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:  MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'All your changes will be deleted and you will no longer be able to access them.',
                          style: AppStyles.h6(),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: accountDeleteController.passCtrl,
                          hintText: "enter your password",
                          contentPaddingVertical: 14.h,
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      Expanded(child: CustomOutlineButton(onTap: (){Get.back();}, text: 'Cancel')),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButton(
                          color: Colors.redAccent,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              // Your delete action goes here
                            }
                          },
                          text: 'Delete',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


}
