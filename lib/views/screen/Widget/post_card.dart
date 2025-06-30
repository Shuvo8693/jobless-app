import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/auth_controller/like_controller.dart';
import 'package:jobless/controllers/home_controller/comment_post_controller.dart';
import 'package:jobless/controllers/home_controller/get_comment_controller.dart';
import 'package:jobless/controllers/home_controller/report_controller.dart';
import 'package:jobless/controllers/home_controller/rewards/rewards_controller.dart';
import 'package:jobless/controllers/home_controller/timeline_post_controller.dart';
import 'package:jobless/controllers/subscription_controller/make_payment_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/date_time_formation/data_age_formation.dart';
import 'package:jobless/utils/date_time_formation/difference_formation.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/casess_network_image.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_text_field.dart';
import 'package:jobless/views/screen/Home/modal/comment_modal.dart';
import 'package:jobless/views/screen/Home/modal/home_timeline_post.dart';
import 'package:jobless/views/screen/Home/pdf_view_screen.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import 'custom_dropdown_field.dart';

class HomeTimeLinePostCart extends StatefulWidget {
  bool isthreeDot;
  Function()? threeDotOnTap;
  Results? results;
  final TimelinePostController timelinePostController;

  HomeTimeLinePostCart({super.key, this.isthreeDot = false, this.threeDotOnTap, this.results,required this.timelinePostController});

  @override
  State<HomeTimeLinePostCart> createState() => _HomeTimeLinePostCartState();
}

class _HomeTimeLinePostCartState extends State<HomeTimeLinePostCart> {
  late final LikeController _likeController;
  final CommentProviderController _commentProviderController = Get.put(CommentProviderController());
  final RewardsController _rewardsController=Get.put(RewardsController());

  TextEditingController commentController = TextEditingController();

 late final CommentPostController commentPostController;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeController = Get.put(LikeController(timelinePostController: widget.timelinePostController));
    commentPostController = Get.put(CommentPostController(timelinePostController: widget.timelinePostController));
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
            leading: Container(
              height: 48.h,
              width: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: widget.results?.author!.image?.isNotEmpty == true
                        ? NetworkImage(
                            '${ApiConstants.imageBaseUrl}${widget.results?.author!.image}')
                        : AssetImage(AppImage.personRound128Img)),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.results?.author?.fullName ?? '',
                  style: AppStyles.customSize(
                    size: 14,
                    fontWeight: FontWeight.w500,
                    family: "Schuyler",
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),

                /// here premium mark icon
                widget.results?.author?.paymentStatus=='paid'? SvgPicture.asset(AppIcons.tikmarkIcon):SizedBox.shrink()
              ],
            ),
            subtitle: Row(
              children: [
                ///post age
                Text(
                  dataAgeFormation.formatContentAge(differenceFormation.formatDifference(
                          widget.results!.createdAt ?? DateTime.now())).toString(),
                  style: AppStyles.h6(color: AppColors.subTextColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('\u2022'),
                ),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    widget.results?.author?.address ?? '',
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
                  ) : const SizedBox(),
          ),

          /// Post Image and post Text Section
          Column(children: [
            Text(
              widget.results?.content ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 26,
              textAlign: TextAlign.justify,
              style: AppStyles.h5(color: AppColors.subTextColor),
            ),
            SizedBox(height: 10.h),

            /// here image and pdf condition will apply
            widget.results?.image != null && widget.results?.image!.isNotEmpty == true
                ? widget.results?.image!.contains('.pdf') == true
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerScreen(
                                  pdfUrl:
                                      '${ApiConstants.imageBaseUrl}${widget.results?.image}'),
                            ),
                          );
                          print(
                              '${ApiConstants.imageBaseUrl}${widget.results?.image}');
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
                        imageUrl: '${ApiConstants.imageBaseUrl}${widget.results?.image}',
                        height: 180.h,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(15.r),
                      )
                : const SizedBox.shrink()
          ]),

          /// Like and comment icon
          SizedBox(height: 18.h),
          Row(
            children: [
              /// Like section
              GetBuilder<LikeController>(
                builder: (GetxController controller) {
                  return InkWell(
                      onTap: () async {
                        if (widget.results?.sId != null) {
                          await _likeController.sendLike(widget.results?.sId);
                        }
                      },
                      child: widget.results!.isLiked == true
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
              ///Comment section
              SizedBox(width: 24.w),
              InkWell(
                onTap: () async{
                  if(widget.results?.sId?.isNotEmpty==true){
                  await _commentProviderController.fetchComments(widget.results?.sId);
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

              /// Reward_section
              widget.results?.author?.paymentStatus=='paid'? Row(
                children: [
                  Text("${widget.results?.rewardCount ?? ''}", style: AppStyles.h4(color: AppColors.primaryColor)),
                  InkWell(
                    onTap: (){
                      if(widget.results?.sId!.isNotEmpty==true){
                        showGiftAmountBottomSheet(context,widget.results?.sId??'');
                      }
                    },
                      child: SvgPicture.asset(AppIcons.rewordIcon)),
                ],
              ):SizedBox.shrink(),
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
                  const SizedBox(width: 5),

                  /// like_count
                  Text(
                    "${widget.results?.likesCount ?? ''}",
                    style: AppStyles.customSize(
                        size: 10, fontWeight: FontWeight.w400),
                  )
                ],
              ),

              /// Comment_count
              Row(
                children: [
                  Text("${widget.results?.commentsCount ?? ''}",
                      style: AppStyles.customSize(
                          size: 10, fontWeight: FontWeight.w400)),
                  SizedBox(
                    width: 5.h,
                  ),
                  Text("Comment",
                      style: AppStyles.customSize(
                          size: 10, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 18.w,),

                  InkWell(
                    onTap: (){
                     showReportBottomSheetGetX(context , postId: widget.results?.sId);
                    },
                    child: Text("Report",
                        style: AppStyles.customSize(
                            size: 15, fontWeight: FontWeight.w400),
                    ),
                  ),

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

  void showGiftAmountBottomSheet(BuildContext context,String postId) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to resize with the keyboard
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjusts for the keyboard
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text("Enter Amount",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // TextFormField for amount input
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an amount";
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Action button
               CustomButton(
                      onTap:()async {
                        if (formKey.currentState!.validate()) {
                          // Do something with the entered amount
                          final amount = amountController.text;
                          if(amount.isNotEmpty && postId.isNotEmpty){
                            Navigator.pop(context);
                            await _rewardsController.makePayment(amount, 'USD', postId);
                            if(_rewardsController.isPaymentHandleSuccess.value){
                             int? resultIndex= widget.timelinePostController.timeLinePost.value.results?.indexWhere((result)=>result.sId==postId);
                             if(resultIndex!=-1){
                              var result= widget.timelinePostController.timeLinePost.value.results?[resultIndex!];
                              result?.rewardCount= (result.rewardCount??0) + 1;
                              widget.timelinePostController.timeLinePost.refresh();
                             }
                            }

                          }
                          print("Entered amount: $amount");
                        }
                      }, text: 'Submit'),

                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  /// GetX Bottom Sheet Version (Alternative)
  void showReportBottomSheetGetX(BuildContext context, {String? postId}) {
    final formKey = GlobalKey<FormState>();
    ReportController reportController = Get.put(ReportController());

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.report_gmailerrorred_rounded,
                        color: Colors.orange[600],
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Report Post',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Obx(() => CustomDropdownField(
                  labelText: 'Reason for Report',
                  hintText: 'Select a reason',
                  value: reportController.selectedReason.value,
                  items: reportController.reportReasons,
                  prefixIcon: Icon(Icons.warning_amber_rounded, color: Colors.grey[400], size: 20),
                  onChanged: (String? newValue) {
                    reportController.selectedReason.value = newValue ?? '';
                  },
                )),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: reportController.descriptionCtrl,
                  labelText: 'Description',
                  hintText: 'Provide details about why you\'re reporting this post...',
                  maxLine: 4,
                  contentPaddingVertical: 12,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 24.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: Obx(() => CustomButton(
                        loading: reportController.isLoading.value,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await reportController.submitReport(postId: postId);
                          }
                        },
                        text: 'Submit Report',
                      ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

 /// ============ Comment bottom sheet ============
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
                            } else if (_commentProviderController.commentModel.value.comments ==
                                null) {
                              return Center(
                                  child: Text(_commentProviderController.errorMessage.value));
                            }
                            List<Comments>? commentList =
                                _commentProviderController.commentModel.value.comments;
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
                                      leading: CircleAvatar(
                                        backgroundImage: commentIndex
                                                    .userId?.image?.isEmpty ==
                                                true
                                            ? AssetImage(AppImage.personImg)
                                            : NetworkImage(
                                                '${ApiConstants.imageBaseUrl}${commentIndex.userId?.image}'
                                                ''),
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
                              controller: commentController,
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
                              if (commentController.text.trim().isNotEmpty) {String newComment = commentController.text.trim();
                                await commentPostController.sendComment(widget.results?.sId, newComment);
                                Get.snackbar('', commentPostController.commentMessage.toString());
                                commentController.clear();
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
