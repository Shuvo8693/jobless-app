import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/home_controller/friendrequest_send_controller.dart';
import 'package:jobless/controllers/home_controller/search_friend_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/views/screen/Home/modal/search_user_model.dart';

import '../../Widget/friend_request_card.dart';

class FriendSuggested extends StatelessWidget {
  const FriendSuggested({super.key, required this.searchFriendController});
  final SearchFriendController searchFriendController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<User> userList = searchFriendController.userModel.value.data?.userList??[];
      return ListView.builder(
        itemCount: userList.length,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          var userIndex = userList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: FriendRequestCard(
              viewOnTap: () {
                Get.toNamed(AppRoutes.viewFriendScreen, arguments: {'user': userIndex});
              },
              user: userIndex, searchFriendController: searchFriendController,
            ),
          );
        },
      );
    });
  }
}
