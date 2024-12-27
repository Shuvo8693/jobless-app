import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/settings_controller/about_us_controller.dart';
import 'package:jobless/controllers/settings_controller/support_controller.dart';
import 'package:jobless/utils/html_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  SupportController supportController=Get.put(SupportController());
  @override
  void initState() {
    super.initState();
    supportController.fetchSupport();
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

        title: Text(AppString.supportText,style: AppStyles.h2(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),
      body: Column(
        children: [
          Obx((){
            String aboutContent= supportController.content.value;
            if(supportController.isLoading.value){
              return const Center(child: CircularProgressIndicator());
            }
            return   Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 20.w),
              child:HTMLView(htmlData: aboutContent),
            );
          }

          ),
        ],
      ),
    );
  }
}
