
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:jobless/controllers/friendlist_controller/friend_remove_controller.dart';
import 'package:jobless/controllers/friendlist_controller/friend_request_accept_controller.dart';
import 'package:jobless/controllers/notification_controller/notification_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/date_time_formation/data_age_formation.dart';
import 'package:jobless/utils/date_time_formation/difference_formation.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/screen/Notification/notification_model/notification_model.dart';

import '../../../../utils/style.dart';
import '../../../base/casess_network_image.dart';

class NotificationCart extends StatefulWidget {
  final NotificationResults notificationResults;
  final NotificationController? notificationController;
  final int index;

    NotificationCart({super.key,required this.notificationResults, this.notificationController, required this.index});

  @override
  State<NotificationCart> createState() => _NotificationCartState();
}

class _NotificationCartState extends State<NotificationCart> {
  final DataAgeFormation _dataAgeFormation=DataAgeFormation();

  final DifferenceFormation _differenceFormation=DifferenceFormation();
   final FriendRemoveController _friendRemoveController=Get.put(FriendRemoveController(),tag: 'notification');
  final FriendRequestAcceptController _requestAcceptController= Get.put(FriendRequestAcceptController(),tag: 'notification');


  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: EdgeInsets.symmetric(vertical:10.h),
      child: Container(
        child: Row(
          children: [
           /* CustomNetworkImage(
              imageUrl: "https://www.befunky.com/images/prismic/82e0e255-17f9-41e0-85f1-210163b0ea34_hero-blur-image-3.jpg?auto=avif,webp&format=jpg&width=896",
              height: 64.h,
              width: 64.w,
              borderRadius: BorderRadius.circular(10.r),
            ),*/
            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.notificationResults.title!=null? Text("${widget.notificationResults.title}",style: AppStyles.customSize(size:14,fontWeight: FontWeight.w500,family: "Schuyler",),):SizedBox.shrink(),
                        Text(_dataAgeFormation.formatContentAge(_differenceFormation.formatDifference(widget.notificationResults.createdAt!)),style: AppStyles.h6()),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${widget.notificationResults.message}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: AppStyles.h6()),
                         widget.notificationResults.type =='post'
                            ? IconButton(
                            onPressed: (){
                              Get.toNamed(AppRoutes.personalInfoScreen,arguments: {'postId': widget.notificationResults.postId});
                             // Get.toNamed(AppRoutes.homeScreen,arguments: {'postId': widget.notificationResults.postId});
                            }, icon:Icon(Icons.arrow_forward_ios_outlined,size: 12.sp,) )
                            : SizedBox.shrink()
                      ],
                    ),

                    SizedBox(height: 10.h,),

                  widget.notificationResults.type=='friendRequest'? Row(
                      children: [
                        Obx(() {
                          return CustomButton(
                            loading:_requestAcceptController.isLoading.value ,
                            onTap: () async {
                              if (widget.notificationResults.friendRequestId != null) {
                                await _requestAcceptController.sendAcceptRequest(widget.notificationResults.friendRequestId,toRemoveFromIndex: (){
                                  widget.notificationController?.notificationModel.value.data?.attributes?.results?.removeAt(widget.index);
                                  widget.notificationController?.notificationModel.refresh();
                                });

                              }
                            },
                            width: 100.w,
                            height: 40.h,
                            text: "Accept",
                          );
                        }),
                        SizedBox(width: 10.w,),
                        CustomOutlineButton(
                          onTap: () async {
                            if (widget.notificationResults.friendId != null) {
                              await _friendRemoveController.removeFriend(widget.notificationResults.friendId ,toRemoveFromIndex: (){
                                widget.notificationController?.notificationModel.value.data?.attributes?.results?.removeAt(widget.index);
                                widget.notificationController?.notificationModel.refresh();
                              });
                            }
                          },
                          width: 100.w,
                          height: 40.h,
                          text: AppString.deleteText,
                          textStyle: AppStyles.h5(),
                        ),
                    ],): SizedBox.shrink(),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
