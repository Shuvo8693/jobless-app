import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_timelinePostController.isFetchingMore.value) {
        await _timelinePostController.loadMorePost();

      }
    });
  }

  getProfileImage() async {
    String authorID = await PrefsHelper.getString('authorId');
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

              /// Search Section
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
                                        ?.isNotEmpty == true
                                    ? NetworkImage('${ApiConstants
                                    .imageBaseUrl}${_profileController.profile
                                    .value.image}')
                                    : AssetImage(AppImage.personRound128Img)),
                          ),
                        );
                      }

                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.feelpostScreen);
                      },
                      child: Container(
                        height: 46.h,
                        width: 240.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius
                              .circular(23)
                              .r,
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

              /// Job Post Section
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
                          if (index == timeLinePostResults.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final resultIndex = timeLinePostResults[index];

                          return HomeTimeLinePostCart(results: resultIndex, timelinePostController: _timelinePostController,);
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
  }

