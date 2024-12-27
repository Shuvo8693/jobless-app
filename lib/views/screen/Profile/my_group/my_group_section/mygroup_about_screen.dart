import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/delete_my_group_controller.dart';
import 'package:jobless/controllers/group_controller/member/member_remove_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_about_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/screen/Profile/friend_list/widgets/my_friend_card.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/single_post_group_modal.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/style.dart';
import '../../../../base/casess_network_image.dart';
import '../../../Widget/member_card.dart';

class MyGroupAboutScreen extends StatefulWidget {
  const MyGroupAboutScreen({super.key});

  @override
  State<MyGroupAboutScreen> createState() => _MyGroupAboutScreenState();
}

class _MyGroupAboutScreenState extends State<MyGroupAboutScreen> {
  final AllGroupAboutController _allGroupAboutController = Get.put(AllGroupAboutController());
  final MemberRemoveController memberRemoveController=Get.put(MemberRemoveController());
  final  DeleteMyGroupController _deleteMyGroupController=Get.put(DeleteMyGroupController());
  String myGroupId = '';
  String authorId = '';

  @override
  void initState() {
    super.initState();
    getGroupAbout();

    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _allGroupAboutController.fetchGroupAbout(myGroupId);
      await getAuthorId();
    });

  }

  getGroupAbout() {
    var myGroupID = Get.arguments['groupAttributesID'];
    setState(() {
      if (myGroupID != null) {
        myGroupId = myGroupID;
      }
    });
    print('My group ID $myGroupId');
  }

  getAuthorId()async{
   String authorIds= await PrefsHelper.getString('authorId');
   if(authorIds.isNotEmpty){
     authorId=authorIds;
   }
   print(authorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: AppColors.textColor,
              )),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///=== Group Header Constructor====
              groupHadder(),
              SizedBox(height: 16.h),

              /// Descriptions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.descriptionsText,
                      style: AppStyles.h4(family: 'Schuyler'),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      '${_allGroupAboutController.groupResults.value.description}',
                      style: AppStyles.h5(),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 16.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppString.memberText,
                      style: AppStyles.h4(family: 'Schuyler'),
                    ),
                    InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.seeAllMyGroupMemberScreen,arguments: {'groupAboutController':  _allGroupAboutController,'groupId':myGroupId});
                        },
                        child: Text(
                          AppString.seeALlText,
                          style: AppStyles.h5(family: 'Schuyler'),
                        )),
                  ],
                ),
              ),

              /// Member List with Remove & make admin
              SizedBox(
                height: 320.h,
                child: Obx(() {
                 List<GroupMembers> members = _allGroupAboutController.groupResults.value.members??[];
                  return ListView.builder(
                      itemCount: members.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                       final memberIndex = members[index];
                        return MemberCard(
                          onTab: () {
                             showPopup(context, memberIndex,index);
                          },
                          buttonTitle: 'admin',
                          icon: AppIcons.starIcon,
                          members: memberIndex,
                          isThreeDot: true,
                        );
                      });
                }),
              ),

              /// Button
              _allGroupAboutController.groupResults.value.createdBy?.id==authorId
                  ?  Column(
                children: [
                  CustomButton(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      onTap: () {
                        if(myGroupId.isNotEmpty){
                          Get.toNamed(AppRoutes.invitePeopleScreen,arguments: {'groupId':myGroupId});
                        }
                      },
                      text: 'inviting people'),
                    SizedBox(height: 10.h),
                    CustomOutlineButton(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      onTap: () {
                        Get.toNamed(AppRoutes.updateGroupScreen,arguments: {'myGroupId':myGroupId});
                      },
                      text: 'Edit Group'),
                  SizedBox(height: 10.h),
                     CustomOutlineButton(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      onTap: () async{
                        if(myGroupId.isNotEmpty){
                          await _deleteMyGroupController.deleteGroup(myGroupId);
                        }
                      },
                      text: 'Delete Group'),
                  SizedBox(
                    height: 25.h,
                  ),
                ],
              )
                  : const SizedBox.shrink(),
            ],
          );
        }),
      ),
    );
  }

  ///=== Group Header at about screen====
  groupHadder() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl:
                "${ApiConstants.imageBaseUrl}${_allGroupAboutController.groupResults.value.coverImage}",
            height: 64.h,
            width: 64.w,
            borderRadius: BorderRadius.circular(10.r),
          ),
          Expanded(
            // Added Expanded here
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_allGroupAboutController.groupResults.value.name}",
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
                              "${_allGroupAboutController.groupResults.value.members?.length ?? 0} Member",
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
  void showPopup(BuildContext context, GroupMembers member,int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding:  EdgeInsets.all(8.0.sp),
            child: Container(
              width: 200.w,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// member_Remove_button
                  TextButton(
                    onPressed: () async {
                       await memberRemoveController.removeMember(friendId: member.userId?.id??'', groupId: myGroupId,toRemoveFromIndex: (){
                          _allGroupAboutController.groupResults.value.members?.removeAt(index);
                          _allGroupAboutController.groupResults.refresh();
                        } );
                      //Navigator.of(context).pop(); // Close the popup
                    },
                    child: const Text('Remove'),
                  ),
                  /// Member_Make_admin button
                /*  TextButton(
                    onPressed: () {

                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: const Text('Make Admin'),
                  ),*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }


}
