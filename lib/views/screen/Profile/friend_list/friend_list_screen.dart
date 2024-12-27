
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/friend_request_accept_controller.dart';
import 'package:jobless/controllers/friendlist_controller/friendrequest_receive_controller.dart';
import 'package:jobless/views/screen/Profile/friend_list/friend_reques_screen.dart';
import 'package:jobless/views/screen/Profile/friend_list/my_friends_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';
class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {

  final List<String> tabbarList = ["Friend request", "My Friends"];

  final FriendRequestReceiveController _requestReceiveController=Get.put(FriendRequestReceiveController());
  late final FriendRequestAcceptController _requestAcceptController;
  @override
  void initState() {
    super.initState();
    _requestAcceptController = Get.put(FriendRequestAcceptController(friendRequestReceiveController: _requestReceiveController));
    _requestReceiveController.fetchRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabbarList.length,
      child: Scaffold(
        appBar:  AppBar(
          centerTitle: true,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.arrow_back_ios,size: 18,color: AppColors.textColor,)),
          ),

          title: Text(AppString.friendListText,style: AppStyles.h2(
            family: "Schuyler",
          )),
          backgroundColor: Colors.transparent,

        ),
        body:Column(
          children: [
            TabBar(
              indicatorColor: AppColors.primaryColor,
              dividerColor: Colors.transparent,
              padding: EdgeInsets.zero,
              labelStyle: AppStyles.customSize(
                size: 17,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
              unselectedLabelStyle: AppStyles.customSize(
                size: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.subTextColor,
              ),
              tabs: [
                for (String tab in tabbarList) Tab(text: tab.tr),
              ],
            ),

            /// Tab Bar View
            Expanded(
              child: TabBarView(
                children: [
                  Obx(() {
                    final friendRequestAttributes = _requestReceiveController.friendRequestModel.value.friendRequestData?.friendRequestAttributes ?? [];
                    if (friendRequestAttributes.isEmpty) {
                      return const Center(child: Text("No Friend Requests"));
                    }
                    return FriendRequestScreen(friendRequestAttributes: friendRequestAttributes, friendRequestReceiveController: _requestReceiveController,);
                  }),
                  const MyFriendScreen(),

                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
