import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/group_timeline_post_controller.dart';
import 'package:jobless/controllers/home_controller/block_controller.dart';
import 'package:jobless/controllers/home_controller/report_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/base/custom_text_field.dart' show CustomTextField;
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/group_timeline_post_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/my_group_model.dart';
import 'package:jobless/views/screen/Widget/custom_dropdown_field.dart';
import 'package:jobless/views/screen/Widget/group_post_card.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/style.dart';
import '../../../../base/casess_network_image.dart';
import '../../../Widget/post_card.dart';
import '../group_model/other_group_model.dart';

class OtherViewGroupScreen extends StatefulWidget {
  const OtherViewGroupScreen({super.key});

  @override
  State<OtherViewGroupScreen> createState() => _OtherViewGroupScreenState();
}

class _OtherViewGroupScreenState extends State<OtherViewGroupScreen> {
  OtherGroupResults _otherGroupResults = OtherGroupResults();
  final GroupTimelinePostController _groupTimeLinePostController =
      Get.put(GroupTimelinePostController());
  final ProfileController _profileController =
      Get.put(ProfileController(), tag: 'otherViewGroup');

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getAllGroup();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _groupTimeLinePostController.fetchMyGroupPost(
          groupId: _otherGroupResults.id);
      await getProfile();
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_groupTimeLinePostController.isFetchingMore.value) {
        await _groupTimeLinePostController
            .loadMoreGroupPost(_otherGroupResults.id);
      }
    });
  }

  getProfile() async {
    String authorId = await PrefsHelper.getString('authorId');
    if (authorId.isNotEmpty) {
      await _profileController.fetchProfile(authorId);
    }
  }

  getAllGroup() {
    var allGroupResults = Get.arguments['otherGroupIndex'];
    if (allGroupResults is OtherGroupResults) {
      _otherGroupResults = allGroupResults;
    }
    print(_otherGroupResults.toString());
    print(_groupTimeLinePostController.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: AppColors.textColor,
              )),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          /// Group Hader
          groupHadder(),
          SizedBox(height: 16.h),

          /// Search Section
          searchSection(),

          /// post Section
          postCartSection()
        ],
      ),
    );
  }

  /// =========Other group screen header,include coverImage, name and About button========
  groupHadder() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl:
                "${ApiConstants.imageBaseUrl}${_otherGroupResults.coverImage}",
            height: 64.h,
            width: 64.w,
            borderRadius: BorderRadius.circular(10.r),
          ),
          Expanded(
            // Added Expanded here
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_otherGroupResults.name}",
                          style: AppStyles.customSize(
                            size: 14,
                            fontWeight: FontWeight.w500,
                            family: "Schuyler",
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AppIcons.friendlistIcon),
                            SizedBox(width: 5.w),
                            Text(
                              "${_otherGroupResults.members != null || _otherGroupResults.members!.isNotEmpty ? _otherGroupResults.members?.length : '0'} Member",
                              style: AppStyles.h6(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30.w),

                  /// Aboute Button

                  CustomButton(
                    height: 30.h,
                    width: 30.w,
                    onTap: () {
                      Get.toNamed(AppRoutes.otherGroupAboutScreen, arguments: {
                        'groupAttributesID': _otherGroupResults.id
                      });
                    },
                    text: AppString.aboutText,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///==========create post section=======
  searchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return CustomNetworkImage(
              imageUrl:
                  "${ApiConstants.imageBaseUrl}${_profileController.profile.value.image}",
              height: 48.h,
              width: 48.w,
              boxShape: BoxShape.circle,
            );
          }),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.feelGroupPostScreen,
                  arguments: {'myGroupID': _otherGroupResults.id});
            },
            child: Container(
              height: 46.h,
              width: 240.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23).r,
                  color: Colors.white,
                  boxShadow: [AppStyles.boxShadow]),
              child: Center(
                  child: Text(
                AppString.homeSearchText,
                style: AppStyles.customSize(
                    size: 10,
                    fontWeight: FontWeight.w400,
                    family: "Schuyler",
                    color: AppColors.dark2Color),
              )),
            ),
          ),
          SvgPicture.asset(
            AppIcons.gelaryIcon,
            height: 21,
            width: 23,
          )
        ],
      ),
    );
  }

  ///========Other group timeline postList=====
  postCartSection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Obx(() {
          List<GroupTimeLinePostResults>? timeLinePostResults =
              _groupTimeLinePostController
                  .groupTimelinePostModel.value.data?.attributes?.results;

          if (_groupTimeLinePostController.timeLineLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (timeLinePostResults == null || timeLinePostResults.isEmpty) {
            return const Center(child: Text('No group available'));
          }
          return SizedBox(
            height: 600.h,
            child: RefreshIndicator(
              onRefresh: () async => await _groupTimeLinePostController
                  .fetchMyGroupPost(groupId: _otherGroupResults.id),
              child: ListView.separated(
                controller: _scrollController,
                itemCount: timeLinePostResults.length +
                    (_groupTimeLinePostController.isFetchingMore.value ? 1 : 0),
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
                  var groupTimelinePostIndex = timeLinePostResults[index];
                  return GroupPostCard(
                    groupTimelinePostResult: groupTimelinePostIndex,
                    groupTimelinePostController: _groupTimeLinePostController,
                    isthreeDot: true,
                    threeDotKey: threeDotKey,
                    threeDotOnTap: ()async{
                      await dropDownOptions(userResults: groupTimelinePostIndex,threeDotKey: threeDotKey);
                    },

                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: Color(0xffC4D3F6));
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Dropdown options
  dropDownOptions({GroupTimeLinePostResults? userResults ,GlobalKey<State<StatefulWidget>>? threeDotKey} )async{
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
  void showBlockUserDialog(BuildContext context, {GroupTimeLinePostResults? userResults}) {
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
