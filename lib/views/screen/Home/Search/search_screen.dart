import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/home_controller/search_friend_controller.dart';
import 'package:jobless/controllers/home_controller/search_group_controller.dart';
import 'package:jobless/controllers/home_controller/timeline_post_controller.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/screen/Home/Search/friend_suggested.dart';
import 'package:jobless/views/screen/Home/Search/group_suggested.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text_field.dart';
import '../../Widget/friend_request_card.dart';

class SearchScreen extends StatefulWidget {
 const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
   final SearchFriendController _searchFriendController=Get.put(SearchFriendController());
   final GroupSearchController _groupSearchController =Get.put(GroupSearchController());
  final TimelinePostController _timelinePostController = Get.put(TimelinePostController());
  final ScrollController _scrollController = ScrollController();

  final List<String> tabBarList = ["Friends", "Group"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarList.length, // Ensuring TabController knows the correct number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: ()async {
              await _timelinePostController.fetchTimelinePost();
              Get.back();
            },
            child: CircleAvatar(
              radius: 20,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.arrow_back_ios,color: AppColors.textColor,)),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: GetBuilder<SearchFriendController>(
          builder: (GetxController controller) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Search Field

                   CustomTextField(
                      contentPaddingVertical: 15.h,
                      hintText: "search".tr,
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SvgPicture.asset(
                          AppIcons.searchIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      controller: _searchCtrl,
                      onChange: (value)async{
                        if(value!=null){
                          await _searchFriendController.fetchUserList(value);
                          if(tabBarList[1].isNotEmpty){
                           await _groupSearchController.searchGroup(name: value);
                            _scrollController.addListener(() async {
                              if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_groupSearchController.isFetchingMore.value) {
                                await _groupSearchController.loadMoreGroupPost(value);
                              }
                            });
                          }

                        }
                      },
                  ),
                  SizedBox(height: 16.h),

                  /// Tab Bar
                  TabBar(
                    indicatorColor: AppColors.primaryColor,
                    dividerColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    labelStyle: AppStyles.customSize(
                      size: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                    unselectedLabelStyle: AppStyles.customSize(
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subTextColor,
                    ),
                    tabs: [
                      for (String tab in tabBarList) Tab(text: tab.tr),
                    ],
                  ),

                  /// Tab Bar View
                   Expanded(
                    child: TabBarView(
                      children: [
                         FriendSuggested(searchFriendController: _searchFriendController,),

                        GroupSuggested(groupSearchController: _groupSearchController, scrollController: _scrollController,),
                      ],
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
