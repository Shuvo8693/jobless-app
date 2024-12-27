import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/Leave_group_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_about_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/single_post_group_modal.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/style.dart';
import '../../../../base/casess_network_image.dart';
import '../../../Widget/member_card.dart';

class OtherGroupAboutScreen extends StatefulWidget {
  const OtherGroupAboutScreen({super.key});

  @override
  State<OtherGroupAboutScreen> createState() => _OtherGroupAboutScreenState();
}

class _OtherGroupAboutScreenState extends State<OtherGroupAboutScreen> {
  final AllGroupAboutController _allGroupAboutController= Get.put(AllGroupAboutController());
   final LeaveGroupController _leaveGroupController=Get.put(LeaveGroupController());
  dynamic groupId='';
  String authorId='';
  @override
  void initState() {
    super.initState();
    getGroupAbout();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
     await getAuthorId();
      await _allGroupAboutController.fetchGroupAbout(groupId);
    });
  }
 getAuthorId()async{
   String authorIds = await  PrefsHelper.getString('authorId');
   if(authorIds.isNotEmpty){
     authorId = authorIds;
   }
 print(authorId);
 }
  getGroupAbout() {
    var myGroupID = Get.arguments['groupAttributesID'];
    setState((){
      if (myGroupID!=null) {
        groupId=myGroupID;
      }
    });
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
        backgroundColor: Colors.transparent,

      ),
      body: SingleChildScrollView(

        child: Obx((){
          return Column(
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
                    Text('${_allGroupAboutController.groupResults.value.description}',
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
                          Get.toNamed(AppRoutes.seeALlMemberScreen,arguments: {'GroupMembers':_allGroupAboutController.groupResults.value.members??[]});
                        },
                        child: Text(AppString.seeALlText,style: AppStyles.h5(family: 'Schuyler'),)),
                  ],
                ),
              ),

              /// Member List with View button
              SizedBox(
                height: 400.h,
                child: Obx(() {
                  List<GroupMembers> members= _allGroupAboutController.groupResults.value.members??[];
                  return ListView.builder(
                      itemCount: members.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        final memberIndex = members[index];
                        return MemberCard(
                          onTab: () {
                            Get.toNamed(AppRoutes.viewMemberProfileScreen,arguments: {'membersUserId':memberIndex.userId?.id});
                          },
                          buttonTitle: 'View',
                          icon: AppIcons.starIcon,
                          members: memberIndex,
                        );
                      });
                }),
              ),


              /// Button
              Column(
                children: [
                  Obx((){
                    List<GroupMembers> members= _allGroupAboutController.groupResults.value.members??[];
                    return  CustomButton(
                        loading: _leaveGroupController.isLoading.value,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        onTap: ()async{
                          if(groupId !=null){
                            await _leaveGroupController.leaveGroup(groupId,(){
                             int? memberIndex= members.indexWhere((member)=>member.userId?.id == authorId).toInt();
                             if(memberIndex != null){
                                _allGroupAboutController.groupResults.value.members?.removeAt(memberIndex);
                                _allGroupAboutController.groupResults.refresh();
                             }
                            });
                          }
                        }, text:'Leave Group');
                   }

                  ),
                  SizedBox(height:25.h,),
                ],
              )
            ],
          );
        }
        ),
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
            imageUrl: "${ApiConstants.imageBaseUrl}${_allGroupAboutController.groupResults.value.coverImage}",
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
                            Text("${_allGroupAboutController.groupResults.value.members?.length??0} Member",
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
