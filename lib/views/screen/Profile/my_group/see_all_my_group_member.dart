import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/member/member_remove_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_about_controller.dart';
import 'package:jobless/views/screen/Profile/friend_list/widgets/my_friend_card.dart';
import 'package:jobless/views/screen/Profile/my_group/widgets/group_member_card.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';
import '../../Widget/member_card.dart';
import 'group_model/all_group_model.dart';
import 'group_model/single_post_group_modal.dart';

class SeeAllMyGroupMember extends StatefulWidget {
  const SeeAllMyGroupMember({super.key});

  @override
  State<SeeAllMyGroupMember> createState() => _SeeAllMyGroupMemberState();
}

class _SeeAllMyGroupMemberState extends State<SeeAllMyGroupMember> {
  final MemberRemoveController memberRemoveController = Get.put(MemberRemoveController());
 late final AllGroupAboutController _allGroupAboutController;
  String myGroupID = '';

  void getGroupMember() {
    var groupAboutController = Get.arguments['groupAboutController'] as AllGroupAboutController;
    var myGroupId = Get.arguments['groupId'];
    if(groupAboutController !=null){
      _allGroupAboutController = groupAboutController;
    }
    if (myGroupId != null) {
      myGroupID = myGroupId;
    }
  }

  @override
  void initState() {
    super.initState();
    getGroupMember();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      getGroupMember();
      if(myGroupID.isNotEmpty){
       await _allGroupAboutController.fetchGroupAbout(myGroupID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () async {
            if(myGroupID.isNotEmpty){
              await _allGroupAboutController.fetchGroupAbout(myGroupID);
            }
            Get.back();

          },
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: AppColors.textColor,
            ),
          ),
        ),
        title: Text(
          AppString.memberText,
          style: AppStyles.h2(
            family: "Schuyler",
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        List<GroupMembers> members=_allGroupAboutController.groupResults.value.members??[];
        if(_allGroupAboutController.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }
        if(members.isEmpty){
          return const Center(child: Text('No member available'));
        }
             return ListView.builder(
                itemCount: members.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  final memberIndex = members[index];
                  return MemberCard(
                    onTab: () {
                      showPopup(context, memberIndex, index);
                    },
                    buttonTitle: 'View',
                    icon: AppIcons.starIcon,
                    members: memberIndex,
                    isThreeDot: true,
                  );
                },
              );
            }
      ),
    );
  }

  void showPopup(BuildContext context, GroupMembers member, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
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
                  // Remove Button
                  TextButton(
                    onPressed: () async {
                      await memberRemoveController.removeMember(
                        friendId: member.userId?.id ?? '',
                        groupId: myGroupID,
                        toRemoveFromIndex: () {
                          _allGroupAboutController.groupResults.value.members?.removeAt(index);
                          _allGroupAboutController.groupResults.refresh(); // Reassign all members
                        },
                      );
                      //Navigator.of(context).pop(); // Close the popup
                    },
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
