
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/style.dart';
class Customlisttile extends StatelessWidget {

  final String? icon;
  final String? title;
  final VoidCallback onTap;
   Customlisttile({super.key,this.icon, this.title,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor,width: 1),
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(16).r
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          onTap: onTap,
          leading: SvgPicture.asset(icon!),
          title:Text(title!,style:  AppStyles.customSize(
            size: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.subTextColor,
            family: "Schuyler",
          )),
          trailing: Icon(Icons.arrow_forward_ios,size: 18,color: AppColors.dark2Color,),

        ),
      ),
    );
  }
}
