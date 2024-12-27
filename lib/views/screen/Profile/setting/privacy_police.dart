
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/settings_controller/privacy_controller.dart';
import 'package:jobless/utils/html_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';

class PrivacyPoliceScreen extends StatefulWidget {
  const PrivacyPoliceScreen({super.key});

  @override
  State<PrivacyPoliceScreen> createState() => _PrivacyPoliceScreenState();
}

class _PrivacyPoliceScreenState extends State<PrivacyPoliceScreen> {
  PrivacyController privacyController=Get.put(PrivacyController());
  @override
  void initState() {
    super.initState();
    privacyController.fetchPrivacy();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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

        title: Text(AppString.privacyText,style: AppStyles.h2(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),

      body: Column(
        children: [
          Obx((){
            String privacyContent= privacyController.content.value;
            if(privacyController.isLoading.value){
              return const Center(child: CircularProgressIndicator());
            }
            return   Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.w),
              child: HTMLView(htmlData: privacyContent),
            );
           }

          ),
        ],
      ),
    );

  }
}
