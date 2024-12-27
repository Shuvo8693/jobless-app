import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/auth_controller/like_controller.dart';
import 'package:jobless/controllers/group_controller/group_post_like_controller.dart';
import 'package:jobless/controllers/group_controller/group_timeline_post_controller.dart';
import 'package:jobless/controllers/home_controller/comment_post_controller.dart';
import 'package:jobless/controllers/home_controller/get_comment_controller.dart';
import 'package:jobless/controllers/home_controller/timeline_post_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/date_time_formation/data_age_formation.dart';
import 'package:jobless/utils/date_time_formation/difference_formation.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/casess_network_image.dart';
import 'package:jobless/views/screen/Home/modal/comment_modal.dart';
import 'package:jobless/views/screen/Home/modal/home_timeline_post.dart';
import 'package:jobless/views/screen/Home/pdf_view_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/group_timeline_post_model.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';

class GroupPostCard extends StatefulWidget {
  bool isthreeDot;
  Function()? threeDotOnTap;
  GroupTimeLinePostResults? groupTimelinePostResult;
  final GroupTimelinePostController groupTimelinePostController;

  GroupPostCard(
      {super.key,
      this.isthreeDot = false,
      this.threeDotOnTap,
      this.groupTimelinePostResult,
      required this.groupTimelinePostController});

  @override
  State<GroupPostCard> createState() => _GroupPostCardState();
}

class _GroupPostCardState extends State<GroupPostCard> {
  final CommentProviderController _commentProviderController =
      Get.put(CommentProviderController());
  late final GroupPostLikeController _groupPostLikeController;
  late final CommentPostController commentPostController;

  TextEditingController commentCtrl = TextEditingController();

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _groupPostLikeController = Get.put(GroupPostLikeController(
        groupTimelinePostController: widget.groupTimelinePostController));
    commentPostController = Get.put(CommentPostController(
        groupTimelinePostController: widget.groupTimelinePostController));
  }

  @override
  Widget build(BuildContext context) {
    DifferenceFormation differenceFormation = DifferenceFormation();
    DataAgeFormation dataAgeFormation = DataAgeFormation();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile Picture
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CustomNetworkImage(
              imageUrl:
                  "${ApiConstants.imageBaseUrl}${widget.groupTimelinePostResult?.author!.image}",
              height: 48.h,
              width: 48.w,
              boxShape: BoxShape.circle,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.groupTimelinePostResult?.author?.fullName ?? '',
                  style: AppStyles.customSize(
                    size: 14,
                    fontWeight: FontWeight.w500,
                    family: "Schuyler",
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                // SvgPicture.asset(AppIcons.tikmarkIcon)
              ],
            ),
            subtitle: Row(
              children: [
                ///post age
                Text(
                  dataAgeFormation
                      .formatContentAge(differenceFormation.formatDifference(
                          widget.groupTimelinePostResult!.createdAt ??
                              DateTime.now()))
                      .toString(),
                  style: AppStyles.h6(color: AppColors.subTextColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('\u2022'),
                ),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    widget.groupTimelinePostResult?.author?.address ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.h6(color: AppColors.subTextColor),
                  ),
                ),
              ],
            ),
            trailing: widget.isthreeDot
                ? InkWell(
                    onTap: widget.threeDotOnTap,
                    child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(AppIcons.threeDotIcon)),
                  )
                : const SizedBox(),
          ),

          /// Post Image and post Text Section
          Column(children: [
            Text(
              widget.groupTimelinePostResult?.content ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 26,
              textAlign: TextAlign.justify,
              style: AppStyles.h5(color: AppColors.subTextColor),
            ),
            SizedBox(height: 10.h),

            /// here image and pdf condition will apply
            widget.groupTimelinePostResult?.image != null &&
                    widget.groupTimelinePostResult?.image!.isNotEmpty == true
                ? widget.groupTimelinePostResult?.image!.contains('.pdf') ==
                        true
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerScreen(
                                  pdfUrl:
                                      '${ApiConstants.imageBaseUrl}${widget.groupTimelinePostResult?.image}'),
                            ),
                          );
                          print(
                              '${ApiConstants.imageBaseUrl}${widget.groupTimelinePostResult?.image}');
                        },
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color:
                                Colors.grey[300], // PDF placeholder background
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.picture_as_pdf,
                                    size: 50, color: Colors.red),
                                Text('View PDF'),
                              ],
                            ),
                          ),
                        ),
                      )
                    : CustomNetworkImage(
                        imageUrl:
                            '${ApiConstants.imageBaseUrl}${widget.groupTimelinePostResult?.image}',
                        height: 180.h,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(15.r),
                      )
                : const SizedBox.shrink()
          ]),

          /// Like and comment icon
          SizedBox(height: 18.h),

          ///==============================
          Row(
            children: [
              GetBuilder<GroupPostLikeController>(
                builder: (GetxController controller) {
                  return InkWell(
                      onTap: () async {
                        if (widget.groupTimelinePostResult?.author?.sId !=
                            null) {
                          await _groupPostLikeController.sendLike(
                              widget.groupTimelinePostResult?.sId,
                              widget.groupTimelinePostResult?.groupId,
                          );
                        }
                      },
                      child: widget.groupTimelinePostResult?.isLiked == true
                          ? SvgPicture.asset(
                              'assets/icons/like.svg',
                              height: 25.h,
                              width: 25.w,
                            )
                          : SvgPicture.asset(
                              AppIcons.likeIcon,
                            ));
                },
              ),
              SizedBox(width: 24.w),
              InkWell(
                onTap: () async {
                  if(widget.groupTimelinePostResult?.sId?.isNotEmpty==true){
                    await _commentProviderController.fetchComments(widget.groupTimelinePostResult?.sId);
                  }
                  showCommentsBottomSheet(context);
                },
                child: SvgPicture.asset(
                  AppIcons.massageIcon,
                  color: AppColors.subTextColor,
                  height: 18.h,
                  width: 22.w,
                ),
              ),
              SizedBox(width: 24.w),
              /*   Row(
                children: [
                  Text("${widget.groupTimelinePostResult?.sharesCount ?? ''}",
                      style: AppStyles.h4(color: AppColors.primaryColor)),
                  SvgPicture.asset(AppIcons.rewordIcon),
                ],
              ),*/
            ],
          ),
          SizedBox(
            height: 18.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.primaryColor,
                      child: Center(
                          child: SvgPicture.asset(
                        AppIcons.likeIcon,
                        height: 8,
                        color: Colors.white,
                      ))),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${widget.groupTimelinePostResult?.likesCount ?? ''}",
                    style: AppStyles.customSize(
                        size: 10, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              Row(
                children: [
                  Text("${widget.groupTimelinePostResult?.commentsCount ?? ''}",
                      style: AppStyles.customSize(
                          size: 10, fontWeight: FontWeight.w400)),
                  SizedBox(
                    width: 5.h,
                  ),
                  Text("Comment",
                      style: AppStyles.customSize(
                          size: 10, fontWeight: FontWeight.w400)),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

  void showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                height: 8,
                width: 70,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12)),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: 500.h,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Display comments
                      Expanded(
                        child: GetBuilder<CommentProviderController>(
                          builder: (GetxController controller) {
                            if (_commentProviderController.isLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (_commentProviderController
                                    .commentModel.value.comments ==
                                null) {
                              return Center(
                                  child: Text(_commentProviderController
                                      .errorMessage.value));
                            }
                            List<Comments>? commentList = _commentProviderController.commentModel.value.comments;
                            return ListView.builder(
                              itemCount: commentList?.length,
                              itemBuilder: (context, index) {
                                final commentIndex = commentList![index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: ListTile(
                                      leading: CustomNetworkImage(
                                        imageUrl:
                                            "${ApiConstants.imageBaseUrl}${commentIndex.userId?.image}",
                                        height: 48.h,
                                        width: 48.w,
                                        boxShape: BoxShape.circle,
                                      ),
                                      title: Text(
                                          commentIndex.userId?.fullName ?? ''),
                                      subtitle:
                                          Text(commentIndex.content ?? ''),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // Input area for writing and sending a comment
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentCtrl,
                              decoration: InputDecoration(
                                hintText: 'Write a comment...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          IconButton(
                            icon:
                                Icon(Icons.send, color: AppColors.primaryColor),
                            onPressed: () async {
                              if (commentCtrl.text.trim().isNotEmpty) {
                                String newComment = commentCtrl.text.trim();
                                await commentPostController.sendComment(widget.groupTimelinePostResult?.sId, newComment);
                                //Get.snackbar('', commentPostController.commentMessage.toString());
                                commentCtrl.clear();
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
