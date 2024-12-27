import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/settings_controller/about_us_controller.dart';
import 'package:jobless/utils/html_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  AboutUsController aboutUsController=Get.put(AboutUsController());

  @override
  void initState() {
    super.initState();
    aboutUsController.fetchAboutUs();
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

        title: Text(AppString.aboutusText,style: AppStyles.h2(family: "Schuyler",)),
        backgroundColor: Colors.transparent,

      ),
      body: Column(
        children: [
          Obx((){
            String aboutContent= aboutUsController.content.value;
            if(aboutUsController.isLoading.value){
              return const Center(child: CircularProgressIndicator());
            }
            return   Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.w),
              child: HTMLView(htmlData: aboutContent),
            );
           }

          ),
        ],
      ),
    );
  }
}
