import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/auth_controller/verify_otp_email_controller.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/views/screen/Auth/resend_otp_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/app_string.dart';
import '../../../utils/style.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  VerifyOtpEmailController verifyOtpEmailController = Get.put(VerifyOtpEmailController());
  ResendOtpController resendOtpController=Get.put(ResendOtpController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _start = 150;
  Timer _timer = Timer(Duration(seconds: 1), () {});

  startTimer() {
    print("Start Time$_start");
    print("Start Time$_timer");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  bool isResetPassword=false;
  @override
  void initState() {
    super.initState();
    startTimer();
    if(Get.arguments !=null && Get.arguments['isPassreset'] !=null){
      getResetPass();
    }
  }

  getResetPass(){
    var isResetPass= Get.arguments['isPassreset'];
    if(isResetPass){
      isResetPassword=isResetPass;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 55.h,
              ),
              Text(AppString.verifyEmailTExt, style: AppStyles.h1(family: "Schuyler")),
              Text(AppString.subverifyEmailTExt, style: AppStyles.h5()),
              SizedBox(
                height: 30.h,
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PinCodeTextField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    controller: verifyOtpEmailController.otpCtrl,
                    autoDisposeControllers: false,
                    enablePinAutofill: true,
                    appContext: (context),
                    autoFocus: true,
                    textStyle: const TextStyle(),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(4).r,
                      fieldHeight: 58.h,
                      fieldWidth: 45.w,
                      activeFillColor: AppColors.fillColor.withOpacity(0.1),
                      selectedFillColor: Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      borderWidth: 0.5,
                      errorBorderColor: Colors.red,
                      activeBorderWidth: 0.5,
                      selectedColor: Get.theme.primaryColor,
                      inactiveColor: AppColors.fillColor,
                    ),
                    length: 6,
                    enableActiveFill: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your pin code';
                        }
                        return null;
                      },
                  ),
                  SizedBox(height: 20.h),

                  Text(timerText, style: AppStyles.h4(color: AppColors.primaryColor)),

                  SizedBox(height: 20.h),

                  ///======Action Button======
                  Obx((){
                    return  CustomButton(
                        loading: verifyOtpEmailController.verifyLoading.value,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await verifyOtpEmailController.sendOtp(isResetPassword);
                          }
                        },
                        text: AppString.sentOtpTExt);
                  }

                  ),

                  SizedBox(height: 20.h),

                  /// Resent Button
                  timerText == "00:00"
                      ? InkWell(
                          onTap: (){
                            resendOtpController.sendMail(false);
                            _start = 150;
                            startTimer();
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Didn’t receive code? ",
                                  style: AppStyles.customSize(
                                      size: 14,
                                      family: "Schuyler",
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subTextColor)),
                              Text("Resend it",
                                  style: AppStyles.customSize(
                                      size: 15,
                                      family: "Schuyler",
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor)),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
  /*Obx(
  () {
  return CustomButton(
  loading: verifyOtpEmailController.verifyLoading.value,
  onTap: () async {
  if (_formKey.currentState!.validate()) {
  await verifyOtpEmailController.sendOtp();
  }
  },
  text: AppString.sentOtpTExt);
  },
  ),*/
}
