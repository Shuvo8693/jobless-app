import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobless/controllers/home_controller/friendrequest_send_controller.dart';
import 'package:jobless/controllers/home_controller/search_friend_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/base/casess_network_image.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/screen/Home/modal/search_user_model.dart';

import '../../../utils/style.dart';

class FriendRequestCard extends StatefulWidget {
  final Function() viewOnTap;
  final User user;
  final SearchFriendController searchFriendController;

  const FriendRequestCard(
      {super.key,
      required this.viewOnTap,
      required this.user,
      required this.searchFriendController});

  @override
  State<FriendRequestCard> createState() => _FriendRequestCardState();
}

class _FriendRequestCardState extends State<FriendRequestCard> {
  late final FriendRequestSendController _friendRequestSendController;

  @override
  void initState() {
    super.initState();
    _friendRequestSendController = Get.put(FriendRequestSendController(searchFriendController: widget.searchFriendController));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: "${ApiConstants.imageBaseUrl}${widget.user.image}",
            height: 64.h,
            width: 64.w,
            borderRadius: BorderRadius.circular(10.r),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.user.fullName}",
                  style: AppStyles.customSize(
                    size: 14,
                    fontWeight: FontWeight.w500,
                    family: "Schuyler",
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    CustomOutlineButton(
                      onTap: widget.viewOnTap,
                      width: 110.w,
                      height: 45,
                      text: 'View Profile',
                      textStyle: AppStyles.h5(),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                   GetBuilder<FriendRequestSendController>(
                     builder: (GetxController controller) {
                       return CustomButton(
                         //loading: _requestSendController.isLoading.value,
                           onTap: widget.user.friendRequestStatus!.contains('pending') == true
                               ? () => null
                               : () async {
                             await _friendRequestSendController.sendRequest(widget.user.sId);
                             if (_friendRequestSendController.message.isNotEmpty) {
                               Get.snackbar(
                                 'Friend Request', // Title
                                 _friendRequestSendController.message.value, // Message
                                 snackPosition: SnackPosition.BOTTOM,
                                 backgroundColor: Colors.greenAccent,
                                 colorText: Colors.white,
                                 duration: const Duration(seconds: 2),
                               );
                             }
                           },
                           width: 120.w,
                           height: 50.h,
                           text: widget.user.friendRequestStatus!.contains('pending') == true
                               ? 'Pending'
                               : 'Request');
                     },
                   ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
