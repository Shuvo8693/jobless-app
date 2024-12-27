import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/allgroup_list_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/friend_list/friend_reques_screen.dart';
import 'package:jobless/views/screen/Profile/friend_list/my_friends_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/join_group_section/join_group_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/other_group_section/other_group_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/my_group_section/your_group_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';

class MyGroupBaseScreen extends StatefulWidget {
  const MyGroupBaseScreen({super.key});

  @override
  State<MyGroupBaseScreen> createState() => _MyGroupBaseScreenState();
}

class _MyGroupBaseScreenState extends State<MyGroupBaseScreen> {
  final List<String> tabBarList = ["Join group", "Your group", "Other group"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarList.length,
      child: Scaffold(
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
            title: Text(AppString.groupText,
                style: AppStyles.h2(
                  family: "Schuyler",
                )),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.createGroupScreen);
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Container(
                      width: 190.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8).r,
                        color: AppColors.primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcons.addIcon),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text('Create a new group',
                                style: AppStyles.h5(
                                  color: Colors.white,
                                  family: "Schuyler",
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              TabBar(
                indicatorColor: AppColors.primaryColor,
                dividerColor: Colors.transparent,
                padding: EdgeInsets.zero,
                labelStyle: AppStyles.customSize(
                  size: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
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
              const Expanded(
                child: TabBarView(
                  children: [
                    JoinGroupScreen(),
                    YourGroupScreen(),
                    OtherGroupScreen(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
