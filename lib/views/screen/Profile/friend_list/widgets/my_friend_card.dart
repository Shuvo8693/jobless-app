import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/my_friend_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/single_post_group_modal.dart';

import '../../../../base/casess_network_image.dart';
class MyFriendCard extends StatelessWidget {
  final Function() onTab;
  String? buttonTitle;
  String? icon;
  Friends? friends;
  MyFriendCard({super.key,required this.onTab,this.buttonTitle,this.icon, this.friends});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.h),
      minVerticalPadding: 8.0.h,
      minLeadingWidth: 0,
      leading: CustomNetworkImage(
        imageUrl: "${ApiConstants.imageBaseUrl}${friends?.image}",
        height: 70.h,
        width: 64.w,
        borderRadius: BorderRadius.circular(10.r),
      ),
      title: Text("${friends?.fullName}",style: AppStyles.customSize(size:14,fontWeight: FontWeight.w500,family: "Schuyler",),),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            friends?.jobLessCategory!= null && friends?.jobLessCategory?.isNotEmpty==true
                ? Row(
              children: [
                SvgPicture.asset(icon ??AppIcons.starIcon),
                const SizedBox(width: 5,),
                Text(friends?.jobLessCategory?.first??'',style: AppStyles.h6(color: AppColors.subTextColor)),
              ],
            ): const SizedBox.shrink(),
            CustomButton(
                width: 76.w,
                height: 30.h,
                onTap: onTab, text: buttonTitle ??'View')
          ],
        )
    );
  }
}
