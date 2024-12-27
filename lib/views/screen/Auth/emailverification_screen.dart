import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/auth_controller/verify_email_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_image.dart';
import 'package:jobless/views/base/custom_button.dart';

import '../../../utils/app_icons.dart';
import '../../../utils/app_string.dart';
import '../../../utils/style.dart';
import '../../base/custom_text_field.dart';

class EmailVerificationScreen extends StatefulWidget {
   EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final VerifyEmailController _verifyEmailController = Get.put(VerifyEmailController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isResetPassword=false;
   @override
  void initState() {
    super.initState();
    if(Get.arguments !=null && Get.arguments['isResetPassword'] !=null){
      getResetPass();
    }

  }
  getResetPass(){
    var isResetPass= Get.arguments['isResetPassword'];
    if(isResetPass){
      isResetPassword=isResetPass;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 21,)) ,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 55.h),

              Text(AppString.forgotPasswordText,
                  style: AppStyles.h1(family: "Schuyler")),
              Text(AppString.subforgotPassword, style: AppStyles.h5()),
              SizedBox(height: 30.h),
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
                controller: _verifyEmailController.emailCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your mail';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              /// Send OTP Button
              Obx(() {
                return CustomButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate() && !_verifyEmailController.isLoading.value) {
                      await _verifyEmailController.sendMail(isResetPassword);
                    }
                  },
                  text: _verifyEmailController.isLoading.value
                      ? 'Sending...'
                      : AppString.sentOtpTExt,
                  // Disable button if loading
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
