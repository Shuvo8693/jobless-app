import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/member/member_remove_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_about_controller.dart';
import 'package:jobless/controllers/message_controller/all_group_chat_member_list_controller.dart';
import 'package:jobless/controllers/message_controller/group_chat_member_remove_controller.dart';
import 'package:jobless/views/base/custom_text_field.dart';
import 'package:jobless/views/screen/Message/widget/group_chat_member_card.dart';
import 'package:jobless/views/screen/Profile/friend_list/widgets/my_friend_card.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/single_post_group_modal.dart';
import 'package:jobless/views/screen/Profile/my_group/widgets/group_member_card.dart';
import 'package:jobless/views/screen/Widget/member_card.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';
import 'model/chat_list_model.dart';
import 'model/see_all_group_member_model.dart';

class SeeAllMyGroupMemberScreen extends StatefulWidget {
  const SeeAllMyGroupMemberScreen({super.key});

  @override
  State<SeeAllMyGroupMemberScreen> createState() => _SeeAllMyGroupMemberScreenState();
}

class _SeeAllMyGroupMemberScreenState extends State<SeeAllMyGroupMemberScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final GroupChatMemberRemoveController groupChatMemberRemoveController = Get.put(GroupChatMemberRemoveController());
  final AllGroupChatMemberListController _allGroupChatMemberListController = Get.put(AllGroupChatMemberListController());


  OtherParticipant? otherParticipant;

  @override
  void initState() {
    super.initState();
    participantInfo();

  }

  participantInfo(){
    var otherParticipantInfo= Get.arguments['otherParticipant'] as OtherParticipant;
    if(otherParticipantInfo !=null){
      otherParticipant = otherParticipantInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () async {
            _allGroupChatMemberListController.allGroupMessageMember.value.data?.attributes?.participants=[];
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
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(10.0.sp),
            child: CustomTextField(
              contentPaddingVertical: 15.h,
              hintText: "search".tr,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SvgPicture.asset(
                  AppIcons.searchIcon,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
              controller: _searchCtrl,
              onChange: (value)async{
                if(value!=null){
                  if(otherParticipant?.id?.isNotEmpty==true && _searchCtrl.text.isNotEmpty){}
                 await _allGroupChatMemberListController.fetchMemberList(otherParticipant?.id??'', _searchCtrl.text);
                }
              },
            ),
          ),
          SizedBox(height: 18.h,),
          Expanded(
            child: Obx(() {
              List<AllGroupChatParticipants> memberList=_allGroupChatMemberListController.allGroupMessageMember.value.data?.attributes?.participants??[];
            /*  if(_allGroupChatMemberListController.isLoading.value){
                return const Center(child: CircularProgressIndicator());
              }
              if(memberList.isEmpty){
                return const Center(child: Text('No member available'));
              }*/
              return ListView.builder(
                itemCount: memberList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  final memberIndex = memberList[index];
                  return GroupChatMemberCard(
                    onTab: () {
                      showPopup(context, memberIndex, index);
                    },
                    buttonTitle: 'View',
                    icon: AppIcons.starIcon,
                    allGroupChatParticipants: memberIndex,
                    isThreeDot: true,
                  );
                },
              );
            }
            ),
          ),
        ],
      ),
    );
  }

  void showPopup(BuildContext context, AllGroupChatParticipants member, int index) {
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
                      await groupChatMemberRemoveController.removeGroupChatMember(
                        memberId: member.id ?? '',
                        groupId: otherParticipant?.id??'',
                        toRemoveFromIndex: () {
                          _allGroupChatMemberListController.allGroupMessageMember.value.data?.attributes?.participants?.removeAt(index);
                          _allGroupChatMemberListController.allGroupMessageMember.refresh(); // Reassign all members
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
  @override
  void dispose() {
    _allGroupChatMemberListController.dispose();
    _allGroupChatMemberListController.allGroupMessageMember.value.data?.attributes?.participants=[];
    super.dispose();
  }
}
