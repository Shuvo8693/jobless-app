import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_image.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_gradientcolor.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';

class JobConfiramScreen extends StatelessWidget {
  const JobConfiramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:CustomGradientcolor(
          chiled: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    Get.toNamed(AppRoutes.jobCategoriScreen);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:  EdgeInsets.only(top: 51.h),
                      child: Text(AppString.skipText,
                          style: AppStyles.customSize(size: 20,fontWeight: FontWeight.w500,underline: TextDecoration.underline)),
                    ),
                  ),
                ),
                SizedBox(height: 30.h,),
                Image.asset(AppImage.onbordingImage2,height: 284.h,width: 285.w,),
                SizedBox(height:32.h),
                Text(AppString.jobConfiramTitleText,style: AppStyles.h1(fontWeight: FontWeight.w500,family: "Schuyler")),
                 SizedBox(height:20.h,),
                 Text(AppString.subjobConfiramTitleText,textAlign: TextAlign.center,),
                SizedBox(height: 88.h,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    CustomOutlineButton(
                        width: 165.w,
                        color: Colors.white,
                        onTap: (){
                         Get.toNamed(AppRoutes.locationSelectorScreen);
                        },
                        text: AppString.noText),
                    CustomButton(
                        width: 165.w,
                        onTap: (){
                          Get.toNamed(AppRoutes.jobCategoriScreen);
                        },
                        text: AppString.yesText),
                  ],
                )


              ],
            ),
          )
      ),
    );

  }
}
