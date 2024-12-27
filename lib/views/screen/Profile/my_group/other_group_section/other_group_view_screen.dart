import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/group_timeline_post_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/group_timeline_post_model.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/my_group_model.dart';
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
  final GroupTimelinePostController _groupTimeLinePostController = Get.put(GroupTimelinePostController());
  final ProfileController _profileController=Get.put(ProfileController(),tag: 'otherViewGroup');

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getAllGroup();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
     await _groupTimeLinePostController.fetchMyGroupPost(groupId: _otherGroupResults.id);
     await getProfile();
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_groupTimeLinePostController.isFetchingMore.value) {
        await _groupTimeLinePostController.loadMoreGroupPost(_otherGroupResults.id);
      }
    });
  }
 getProfile()async{
   String authorId= await PrefsHelper.getString('authorId');
   if(authorId.isNotEmpty){
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
                            Text("${_otherGroupResults.members != null || _otherGroupResults.members!.isNotEmpty ? _otherGroupResults.members?.length : '0'} Member",
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
                      Get.toNamed(AppRoutes.otherGroupAboutScreen, arguments: {'groupAttributesID': _otherGroupResults.id});

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
          Obx((){
            return CustomNetworkImage(
              imageUrl:
              "${ApiConstants.imageBaseUrl}${_profileController.profile.value.image}",
              height: 48.h,
              width: 48.w,
              boxShape: BoxShape.circle,
            );
        }

          ),
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
          List<GroupTimeLinePostResults>? timeLinePostResults = _groupTimeLinePostController.groupTimelinePostModel.value.data?.attributes?.results;

          if (_groupTimeLinePostController.timeLineLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (timeLinePostResults == null || timeLinePostResults.isEmpty) {
            return const Center(child: Text('No group available'));
          }
          return SizedBox(
            height: 600.h,
            child: RefreshIndicator(
              onRefresh: () async => await _groupTimeLinePostController.fetchMyGroupPost(groupId: _otherGroupResults.id),
              child: ListView.separated(
                controller: _scrollController,
                itemCount: timeLinePostResults.length + (_groupTimeLinePostController.isFetchingMore.value ? 1 : 0),
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  if (index == timeLinePostResults.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  var groupTimelinePostIndex = timeLinePostResults[index];
                  return GroupPostCard(
                    groupTimelinePostResult: groupTimelinePostIndex, groupTimelinePostController: _groupTimeLinePostController,
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
}
