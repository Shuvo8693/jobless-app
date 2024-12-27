import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/other_group_controller.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/other_group_model.dart';
import 'package:jobless/views/screen/Widget/other_group_request_card.dart';

import '../../../../../helpers/route.dart';


class OtherGroupScreen extends StatefulWidget {
  const OtherGroupScreen({super.key});

  @override
  State<OtherGroupScreen> createState() => _OtherGroupScreenState();
}

class _OtherGroupScreenState extends State<OtherGroupScreen> {
  final OtherGroupListController _otherGroupListController=Get.put(OtherGroupListController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _otherGroupListController.fetchOtherGroupList();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent - 200 && !_otherGroupListController.isFetchingMore.value) {
          await _otherGroupListController.loadMorePost();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ///=======Other Group list screen (Joined in group)======
    return Obx(() {
      List<Rx<OtherGroupResults>>? otherGroupResult = _otherGroupListController.otherGroupResults;
      if (otherGroupResult == null || otherGroupResult.isEmpty) {
        return const Center(child: Text('No group available'));
      }
      if (_otherGroupListController.timeLineLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: otherGroupResult.length + (_otherGroupListController.isFetchingMore.value ? 1 : 0),
        controller: _scrollController,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          if (index == otherGroupResult.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          var otherGroupIndex = otherGroupResult[index];
          return OtherGroupRequestCard(
            onTab: () {
              Get.toNamed(AppRoutes.otherViewGroupScreen, arguments: {'otherGroupIndex':otherGroupIndex.value});
            },
            buttonTitle: 'View',
            icon: AppIcons.friendlistIcon,
            otherGroupResults: otherGroupIndex.value,
          );
        },
      );
    });
  }
}
