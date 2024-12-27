
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/member/friend_invite_controller.dart';
import 'package:jobless/controllers/group_controller/member/invite_friend_get_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_about_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_constants.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/invite_people_model.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/style.dart';
import '../../../../base/casess_network_image.dart';
import '../../../../base/custom_button.dart';

class InvitingPeopleScreen extends StatefulWidget {
  const InvitingPeopleScreen({super.key});

  @override
  State<InvitingPeopleScreen> createState() => _InvitingPeopleScreenState();
}

class _InvitingPeopleScreenState extends State<InvitingPeopleScreen> {
  final InviteFriendGetController _inviteFriendController= Get.put(InviteFriendGetController());
  final FriendInviteController _friendInviteController=Get.put(FriendInviteController());
  final AllGroupAboutController _allGroupAboutController = Get.put(AllGroupAboutController());
  String myGroupId = '';


  @override
  void initState() {
    super.initState();
    getGroupId();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _inviteFriendController.fetchFriends(myGroupId);
    });
  }

  getGroupId() {
    var myGroupID = Get.arguments['groupId'];
      if (myGroupID != null) {
        myGroupId = myGroupID;
      }

    print('My group ID $myGroupId');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: ()async{
            await _allGroupAboutController.fetchGroupAbout(myGroupId);
            Get.back();
          },
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.arrow_back_ios,size: 18,color: AppColors.textColor,)),

        ),
        title: Text('Inviting People',style: AppStyles.h2(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),
      body: Obx((){
        List<InvitePeopleListData>? invitePeopleList= _inviteFriendController.invitePeopleListModel.value.data??[];
         if(_inviteFriendController.isLoading.value){
           return  const Center(child: CircularProgressIndicator());
         }
         if(invitePeopleList.isEmpty){
           return const Center(child: Text('Your friends are not available for invitation '));
         }
           return  ListView.builder(
               itemCount: invitePeopleList.length,
               shrinkWrap: true,
               primary: false,
               itemBuilder: (context,index){
                final invitePeopleIndex = invitePeopleList[index];
                 return Padding(
                   padding:  EdgeInsets.symmetric(vertical: 10.h),
                   child: ListTile(

                     title: Text("${invitePeopleIndex.fullName}",style: AppStyles.customSize(size:14,fontWeight: FontWeight.w500,family: "Schuyler",),),
                     leading: CustomNetworkImage(
                       imageUrl: "${ApiConstants.imageBaseUrl}${invitePeopleIndex.image}",
                       height: 64.h,
                       width: 64.w,
                       boxShape: BoxShape.circle,
                     ),
                     trailing: CustomButton(
                       loading: _friendInviteController.isLoading.value,
                         onTap: ()async{
                         if(invitePeopleIndex.id!.isNotEmpty && myGroupId.isNotEmpty){
                          await _friendInviteController.inviteFriend(friendId: invitePeopleIndex.id??'', groupId: myGroupId,toRemoveFromIndex: (){
                            _inviteFriendController.invitePeopleListModel.value.data?.removeAt(index);
                            _inviteFriendController.invitePeopleListModel.refresh();
                          });
                           }
                         },
                         width:120.w,
                         height:32.h,
                         text: 'Invite'),
                   ),
                 );
               });
          }

      )
    );
  }
}
