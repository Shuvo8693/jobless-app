

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/home_controller/search_friend_controller.dart';
import 'package:jobless/controllers/home_controller/search_group_controller.dart';
import 'package:jobless/controllers/message_controller/group_message_member_add.dart';
import 'package:jobless/controllers/message_controller/model/my_friend_search_model.dart';
import 'package:jobless/controllers/message_controller/search_friend_list_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_text_field.dart';
import 'package:jobless/views/screen/Home/modal/search_user_model.dart';
import 'package:jobless/views/screen/Message/model/chat_list_model.dart';

import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/style.dart';
import '../../base/casess_network_image.dart';
import '../../base/custom_button.dart';

class GroupCreateFriendChoiceScreen extends StatefulWidget {
  const GroupCreateFriendChoiceScreen({super.key});

  @override
  State<GroupCreateFriendChoiceScreen> createState() => _GroupCreateFriendChoiceScreenState();
}

class _GroupCreateFriendChoiceScreenState extends State<GroupCreateFriendChoiceScreen> {
  final SearchMyFriendController _searchMyFriendController=Get.put(SearchMyFriendController());
  final GroupMessageMemberAddController _groupMessageMemberAddController=Get.put(GroupMessageMemberAddController());
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  OtherParticipant? otherParticipant;

  List<String> selectedUsers = <String>[];
  List<bool> isSelected = [];
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
        title: Text('Create Group message',style: AppStyles.h3(
          family: "Schuyler",
        )),
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
                  await _searchMyFriendController.fetchMyFiendList(value);
                  /// This need for search time initialization for isSelected index
                  final myFriendList = _searchMyFriendController.myFriendSearchModel.value.data?.attributes?.friends ?? [];
                    isSelected = List.filled(myFriendList.length, false);
                }
              },
            ),
          ),

        const SizedBox(height: 16.0),
        Expanded(
          child: Obx((){
            final List<Friends> myFriendList = _searchMyFriendController.myFriendSearchModel.value.data?.attributes?.friends??[];
            if (isSelected.length != myFriendList.length) {
              isSelected = List.filled(myFriendList.length, false);
            }
            return  ListView.builder(
              controller: _scrollController,
              itemCount: myFriendList.length,
              itemBuilder: (context, index) {
                var myFriendIndex = myFriendList[index];

                return ListTile(
                  leading: CustomNetworkImage(
                    imageUrl: "${ApiConstants.imageBaseUrl}${myFriendIndex.image}",
                    height: 54.h,
                    width: 54.w,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: Text('${myFriendIndex.fullName}'),
                  trailing: Radio<bool>(
                    value: true,
                    onChanged: (bool? value) {
                      print('on Changed value : $value');
                      setState(() {
                        bool selectedValue = value ?? false;
                        if(selectedValue==true){
                          isSelected[index] = selectedValue;
                          print(isSelected[index].toString());
                        }
                      });
                      if(isSelected[index]){
                        selectedUsers.add(myFriendIndex.id!);
                      }else{
                        selectedUsers.remove(myFriendIndex.id!);
                      }
                      print(selectedUsers);

                    },
                    groupValue:isSelected[index],

                  ),
                );
              },
            );
          }

          ),
        ),

        Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              padding: EdgeInsets.symmetric(horizontal: 24.h,vertical: 10),
                onTap: ()async{
                 if(otherParticipant?.id!.isNotEmpty==true && selectedUsers.isNotEmpty){
                  await _groupMessageMemberAddController.addGroupMember(otherParticipant?.id??'', selectedUsers);
                 }


            }, text: 'Create Group Message'))
      ],),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchMyFriendController.myFriendSearchModel.value.data?.attributes?.friends=[];
    selectedUsers.clear();
    isSelected.clear();
  }
}
