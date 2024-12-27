import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/my_group_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/other_group_model.dart';

import '../../../utils/style.dart';
import '../../base/casess_network_image.dart';
class OtherGroupRequestCard extends StatelessWidget {
  final Function() onTab;
  String? buttonTitle;
  String? icon;
  OtherGroupResults otherGroupResults;
  OtherGroupRequestCard({super.key,required this.onTab,this.buttonTitle,this.icon,required this.otherGroupResults,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.h),
      minVerticalPadding: 8.0.h,
      minLeadingWidth: 0,
      leading:CustomNetworkImage(
        imageUrl: "${ApiConstants.imageBaseUrl}${otherGroupResults.coverImage}",
        height: 70.h,
        width: 64.w,
        borderRadius: BorderRadius.circular(10.r),
      ),
      title: Text("${otherGroupResults.name}",style: AppStyles.customSize(size:14,fontWeight: FontWeight.w500,family: "Schuyler",),),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon ??AppIcons.starIcon),
              const SizedBox(width: 5,),
              Text('${otherGroupResults.privacy}',style: AppStyles.h6(color: AppColors.subTextColor)),
            ],
          ),
          CustomButton(
              width: 76.w,
              height: 30.h,
              onTap: onTab, text: buttonTitle ??'View')
        ],
      ),
    );
  }
}
