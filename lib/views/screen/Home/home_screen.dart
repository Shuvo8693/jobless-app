import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/home_controller/block_controller.dart';
import 'package:jobless/controllers/home_controller/report_controller.dart';
import 'package:jobless/controllers/home_controller/timeline_post_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/app_image.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/bottom_menu..dart';
import 'package:jobless/views/base/custom_button.dart' show CustomButton;
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/base/custom_text_field.dart';
import 'package:jobless/views/screen/Widget/custom_dropdown_field.dart';
import 'package:jobless/views/screen/Widget/post_card.dart';

import '../../../utils/app_colors.dart';
import 'modal/home_timeline_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TimelinePostController _timelinePostController = Get.put(TimelinePostController());
  final ProfileController _profileController = Get.put(ProfileController(), tag: 'homeScreen');
  final ScrollController _scrollController = ScrollController();
 String postIdFromNotification='';



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _timelinePostController.fetchTimelinePost();
      await getProfileImage();

    });

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_timelinePostController.isFetchingMore.value) {
        await _timelinePostController.loadMorePost();

      }
    });
  }

  getProfileImage() async {
    String? authorID = await PrefsHelper.getString('authorId');
    if (authorID != null && authorID.isNotEmpty) {
      await _profileController.fetchProfile(authorID);
    }
    print(_profileController.profile.value.image);
  }

  getPostIdFromNotification() {
    String? postId = Get.arguments['postId'] as String;
    if (postId.isNotEmpty) {
      postIdFromNotification = postId;
    }
  }

 /* scrollToPost(String postId) {
    int? index = _timelinePostController.timeLinePost.value.results?.indexWhere((result) => result.sId == postId).toInt();
    if (index != -1) {
      _timelinePostController;
      // _scrollController.animateTo(index ! * 100.0, duration: Duration(microseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.snackbar('', 'Post not found');
    }
  }*/
    @override
    Widget build(BuildContext context) {
      return Scaffold(
          bottomNavigationBar: const BottomMenu(0),
          appBar: AppBar(
            leadingWidth: 65,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SvgPicture.asset(
                AppImage.appIcon,
                height: 48.h,
                width: 48.w,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.searchScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SvgPicture.asset(
                    AppIcons.searchIcon,
                    height: 36.h,
                    width: 36.w,
                  ),
                ),
              ),
            ],
            title: Text(AppString.joblessText,
                style: AppStyles.customSize(
                    size: 16,
                    family: "Schuyler",
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor)),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [

              /// Profile Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.personalInfoScreen);
                    },
                    child: Obx(() {
                      return Container(
                        height: 48.h,
                        width: 48.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _profileController.profile.value.image !=
                                          null &&
                                      _profileController.profile.value.image
                                              ?.isNotEmpty ==
                                          true
                                  ? NetworkImage(
                                      '${ApiConstants.imageBaseUrl}${_profileController.profile.value.image}')
                                  : AssetImage(AppImage.personRound128Img)),
                        ),
                      );
                    }),
                  ),
                  /// Post Section
                  InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.feelpostScreen);
                      },
                      child: Container(
                        height: 46.h,
                        width: 240.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23.r),
                          color: Colors.white,
                          boxShadow: [AppStyles.boxShadow],
                        ),
                        child: Center(
                          child: Text(
                            AppString.homeSearchText,
                            style: AppStyles.customSize(
                              size: 10,
                              fontWeight: FontWeight.w400,
                              family: "Schuyler",
                              color: AppColors.dark2Color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.gelaryIcon,
                      height: 21,
                      width: 23,
                    ),
                  ],
                ),
              ),

              ///  Post View Section
              Expanded(
                child: SizedBox(
                  height: 568.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Obx(() {
                      List<Results> timeLinePostResults = _timelinePostController.timeLinePost.value.results??[];

                      if (_timelinePostController.timeLineLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                     if (timeLinePostResults.isEmpty) {
                        return const Center(child: Text('No post found'));
                      }

                    /* if (_timelinePostController.errorMessage.value.isNotEmpty) {
                        return  Center(child: Text(_timelinePostController.errorMessage.value));
                      }*/
                      return ListView.separated(
                        controller: _scrollController,
                        physics: const ScrollPhysics(),
                        itemCount: timeLinePostResults.length + (_timelinePostController.isFetchingMore.value ? 1 : 0),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          final threeDotKey = GlobalKey();
                          if (index == timeLinePostResults.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final resultIndex = timeLinePostResults[index];

                          return HomeTimeLinePostCart(
                            results: resultIndex,
                            timelinePostController: _timelinePostController,
                            isthreeDot: true,
                            threeDotOnTap: ()async{
                             await dropDownOptions(userResults: resultIndex, threeDotKey: threeDotKey);
                            }, threeDotKey: threeDotKey,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(color: Color(0xffC4D3F6));
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ));
    }

    @override
    void dispose() {
      super.dispose();
      _scrollController.dispose();
    }
    /// Dropdown options
    dropDownOptions({Results? userResults ,GlobalKey<State<StatefulWidget>>? threeDotKey} )async{
       List<String> items = ['Block','Report'];
      final RenderBox renderBox = threeDotKey!.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      final result = await showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(
          position.dx ,
          position.dy ,
          position.dx ,
          position.dy ,
        ),
        items: [
           ...List.generate(items.length, (index){
             return PopupMenuItem<String>(
               value: items[index],
               child: Text(items[index]),
             );
           })
        ],
      );

      // Handle the selected result
      if (result != null) {
        switch (result) {
          case 'Block':
          showBlockUserDialog(context, userResults: userResults);
            break;
          case 'Report':
           showReportBottomSheetGetX(context,postId: userResults?.sId??'');
            break;
        }
      }
    }

  /// GetX Bottom Sheet
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
                 ),
                ),
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
                        height: 35.h,
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

 /// Block user dialog
  void showBlockUserDialog(BuildContext context, {Results? userResults}) {
      final BlockController blockController = Get.put(BlockController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Block User'),
          content: Text('Are you sure you want to block "${userResults?.author?.fullName}"? You won\'t see their posts or be able to message them.'),
          actions: [
            CustomOutlineButton(
              width: 40.w,
              height: 30.h,
              onTap: () {
                Get.back();
              },
              text: 'Cancel',
            ),
            Obx(() {
              return CustomButton(
                width: 40.w,
                height: 30.h,
                color: Colors.red,
                loading: blockController.isLoading.value,
                onTap: () async {
                  await blockController.block(userId: userResults?.author?.sId,messageFunc: (message){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message??''),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                  Get.back();
                },
                text: 'Block',
              );
            }),
          ],
        );
      },
    );
  }

  }

