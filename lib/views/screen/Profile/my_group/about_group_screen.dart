import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/base/custom_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/style.dart';
import '../../../base/casess_network_image.dart';
import '../../Widget/member_card.dart';
import '../friend_list/widgets/my_friend_card.dart';

class AboutGroupScreen extends StatelessWidget {
  const AboutGroupScreen({super.key});

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
        backgroundColor: Colors.transparent,

      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Hader
          groupHadder(),
          SizedBox(height: 16.h,),

          /// Descriptions
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppString.descriptionsText,style: AppStyles.h4(family: 'Schuyler'),),
                SizedBox(height: 10.h,),
                Text('will be distracted by the readable content of a page when looking at its layout. Normal distribution of letters, as opposed to using Content herewill be distracted by the readable content of a page when looking at its layout. Normal distribution of letters, as opposed to using Content here',
                  style:AppStyles.h5(),)
              ],
            ),
          ),

          SizedBox(height: 16.h,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppString.memberText,style: AppStyles.h4(family: 'Schuyler'),),
                InkWell(
                  onTap: (){
                    Get.toNamed(AppRoutes.seeALlMemberScreen);
                  },
                    child: Text(AppString.seeALlText,style: AppStyles.h5(family: 'Schuyler'),)),
              ],
            ),
          ),

        /// Member List
        Expanded(

          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context,insdex){
              return MyFriendCard(
                onTab: (){
          
                  //Get.toNamed(AppRoutes.viewGroupScreen);
          
                },
                buttonTitle: 'View',
                icon: AppIcons.starIcon,
              );
            }),
        ),
          /// Button
          
          CustomButton(
            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 15.h),
              onTap: (){}, text: AppString.leaveGroupText)
        ],
      ),
    );

  }
  /// Hader
  groupHadder(){
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: "https://www.befunky.com/images/prismic/82e0e255-17f9-41e0-85f1-210163b0ea34_hero-blur-image-3.jpg?auto=avif,webp&format=jpg&width=896",
            height: 64.h,
            width: 64.w,
            borderRadius: BorderRadius.circular(10.r),
          ),
          Expanded( // Added Expanded here
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jobless Community",
                          style: AppStyles.customSize(
                            size: 14,
                            fontWeight: FontWeight.w500,
                            family: "Schuyler",
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AppIcons.friendlistIcon),
                            SizedBox(width: 5.w),
                            Text(
                              "1k Member",
                              style: AppStyles.h6(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30.w),

                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
