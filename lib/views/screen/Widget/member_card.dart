import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/my_friend_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/single_post_group_modal.dart';

import '../../../utils/style.dart';
import '../../base/casess_network_image.dart';
class MemberCard extends StatefulWidget {
  final Function() onTab;
   String? buttonTitle;
   String? icon;
   bool? isThreeDot;
   GroupMembers? members;
   SinglePostGroupCreatedBy? createdBy;
  MemberCard({super.key,required this.onTab,this.buttonTitle,this.icon,this.members,this.createdBy,this.isThreeDot});

  @override
  State<MemberCard> createState() => _MyFriendCardState();
}

class _MyFriendCardState extends State<MemberCard> {
 /* final ProfileController _profileController=Get.put(ProfileController(),tag: 'memberCard');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
     await _profileController.fetchProfile(widget.members?.userId?.id);
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.h),
      minVerticalPadding: 8.0.h,
      minLeadingWidth: 0,
      leading: CustomNetworkImage(
        imageUrl: "${ApiConstants.imageBaseUrl}${widget.members?.userId?.image}",
        height: 70.h,
        width: 64.w,
        borderRadius: BorderRadius.circular(10.r),
      ),
      title: Text("${widget.members?.userId?.fullName}",style: AppStyles.customSize(size:14,fontWeight: FontWeight.w500,family: "Schuyler",),),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           widget.members?.userId?.jobLessCategory!= null && widget.members?.userId?.jobLessCategory?.isNotEmpty==true
                ? Row(
              children: [
                SvgPicture.asset(widget.icon ??AppIcons.starIcon),
                const SizedBox(width: 5,),
                SizedBox(
                  width: 120.w,
                    child: Text( widget.members?.userId?.jobLessCategory?.take(1).join(',')??'',overflow: TextOverflow.ellipsis,style: AppStyles.h6(color: AppColors.subTextColor))),
              ],
            ): const SizedBox.shrink(),
                widget.isThreeDot==true
                    ? IconButton(onPressed: widget.onTab, icon: SvgPicture.asset(AppIcons.threeDotIcon))
                    :CustomButton(
                       width: 76.w,
                        height: 30.h,
                         onTap: widget.onTab, text: widget.buttonTitle ??'View')
          ],
        )

    );
  }
  @override
  void dispose() {
    widget.members=null;
    super.dispose();
  }
}
