
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/friend_remove_controller.dart';
import 'package:jobless/controllers/friendlist_controller/friend_request_accept_controller.dart';
import 'package:jobless/controllers/friendlist_controller/friendrequest_receive_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/date_time_formation/data_age_formation.dart';
import 'package:jobless/utils/date_time_formation/difference_formation.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/friendrequest_model.dart';

import '../../../utils/style.dart';
import '../../base/casess_network_image.dart';
import '../../base/custom_button.dart';
import '../../base/custom_outlinebutton.dart';

class FriendAcceptCard extends StatefulWidget {
  const FriendAcceptCard({super.key, required this.profile,required this.index, required this.friendRequestAttributes, required this.friendRequestReceiveController,});
 final Profile profile;
 final FriendRequestAttributes friendRequestAttributes;
  final FriendRequestReceiveController friendRequestReceiveController;
 final int index;

  @override
  State<FriendAcceptCard> createState() => _FriendAcceptCardState();
}

class _FriendAcceptCardState extends State<FriendAcceptCard> {
  final DataAgeFormation _dataAge=DataAgeFormation();
  final DifferenceFormation _timeDifference= DifferenceFormation();
  late final FriendRemoveController _friendRemoveController;
  final FriendRequestAcceptController _requestAcceptController= Get.find();

  @override
  void initState() {
    super.initState();
    _friendRemoveController=Get.put(FriendRemoveController(friendRequestReceiveController: widget.friendRequestReceiveController),tag: 'from friendList');
  }

  @override
  Widget build(BuildContext context) {

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 8.h,
      leading:InkWell(
        onTap: (){
          Get.toNamed(AppRoutes.friendprofileViewcreen);
        },
        child: CustomNetworkImage(
          imageUrl: "${ApiConstants.imageBaseUrl}${widget.profile.image}",
          height: 66.h,
          width: 64.w,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${widget.profile.fullName}",style: AppStyles.customSize(size:14,fontWeight: FontWeight.w500,family: "Schuyler",),),
          Text(_dataAge.formatContentAge(_timeDifference.formatDifference(widget.friendRequestAttributes.createdAt??DateTime.now() )),style: AppStyles.h6()),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Obx(() {
            return CustomButton(
              loading:_requestAcceptController.isLoading[widget.index]??false ,
              onTap: () async {
                if (widget.friendRequestAttributes.sId != null) {
                  await _requestAcceptController.sendAcceptRequest(widget.friendRequestAttributes.sId,widget.index);

                }
              },
              width: 120.w,
              height: 32.h,
              text: "Accept",
            );
          }),

          CustomOutlineButton(
            onTap: () async {
              if (widget.profile.id != null) {
               await _friendRemoveController.removeFriend(widget.profile.id,toRemoveFromIndex: (){
                  widget.friendRequestReceiveController.friendRequestModel.value.friendRequestData?.friendRequestAttributes?.removeAt(widget.index);
                });
              }
            },
            width: 110.w,
            height: 30.h,
            text: AppString.deleteText,
            textStyle: AppStyles.h5(),
          ),
        ],
      ),
    );
  }
}
