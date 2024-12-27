
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class SeeAllMember extends StatefulWidget {
  const SeeAllMember({super.key});

  @override
  State<SeeAllMember> createState() => _SeeAllMemberState();
}

class _SeeAllMemberState extends State<SeeAllMember> {
  List<GroupMembers> members=[];

  getGroupMember(){
     var groupMembers = Get.arguments['GroupMembers'];
     if(groupMembers !=null){
       members= groupMembers;
     }
     print(members);
  }
  @override
  void initState() {
    super.initState();
    getGroupMember();
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
        title: Text(AppString.memberText,style: AppStyles.h2(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),

      body: ListView.builder(
          itemCount: members.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context,index){
            final memberIndex= members[index];
            return MemberCard(
              onTab: (){
                Get.toNamed(AppRoutes.viewMemberProfileScreen,arguments: {'membersUserId':memberIndex.userId?.id});
              },
              buttonTitle: 'View',
              icon: AppIcons.starIcon,
              members: memberIndex ,
            );
          })
    );
  }
}
