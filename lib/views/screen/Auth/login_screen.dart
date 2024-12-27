import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/auth_controller/login_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/app_image.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController _loginController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(AppString.loginText, style: AppStyles.h1()),
              Text(AppString.subLoginText, style: AppStyles.h5()),

              SizedBox(height: 30.h),

              Text(AppString.emailText,
                  style: AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h),
              CustomTextField(
                isEmail: true,
                contentPaddingVertical: 15.h,
                hintText: "Enter Email",
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SvgPicture.asset(AppIcons.emailIcon),
                ),
                controller: _loginController.emailCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),
              Text(AppString.passawordText,
                  style: AppStyles.h4(family: "Schuyler")),

              SizedBox(height: 10.h),

              CustomTextField(
                contentPaddingVertical: 15.h,
                hintText: "Enter Password",
                isObscureText: true,
                obscure: '*',
                isPassword: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SvgPicture.asset(AppIcons.passwordIcon),
                ),
                controller: _loginController.passCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              /// Forgot passwort

              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: ()async{
                      Get.toNamed(AppRoutes.emailveryfaiScreen,arguments: {'isResetPassword':true});
                    },
                    child: Text("Forgot Password?",
                        style: AppStyles.customSize(
                            size: 14,
                            family: "Schuyler",
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor)),
                  )),

              /// Login Button

              SizedBox(height: 20.h),
              Obx((){
                return CustomButton(
                  loading: _loginController.verifyLoading.value,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await _loginController.login();
                      }
                    },
                    text: AppString.loginText);
              }

              ),

              /// Route SignUpScreen
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.locationSelectorScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don’t have an account? ",
                        style: AppStyles.customSize(
                            size: 14,
                            family: "Schuyler",
                            fontWeight: FontWeight.w500,
                            color: AppColors.subTextColor)),
                    Text("Sign up",
                        style: AppStyles.customSize(
                            size: 15,
                            family: "Schuyler",
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
