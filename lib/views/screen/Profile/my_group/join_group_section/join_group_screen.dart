import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/allgroup_list_controller.dart';
import 'package:jobless/controllers/group_controller/group_join_controller.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Widget/all_group_request_card.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final AllGroupListController _allGroupListController = Get.put(AllGroupListController());
  final ScrollController _scrollController = ScrollController();
  late final GroupJoinController _groupJoinController;

  @override
  void initState() {
    super.initState();
    _allGroupListController.fetchGroupList();
    _groupJoinController = Get.put(GroupJoinController(allGroupListController: _allGroupListController));
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent - 200 &&
          !_allGroupListController.isFetchingMore.value) {
        await _allGroupListController.loadMorePost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Rx<GroupResults>>? groupResult = _allGroupListController.groupResults;
      if (groupResult == null || groupResult.isEmpty) {
        return const Center(child: Text('No group available'));
      }
      if (_allGroupListController.timeLineLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        controller: _scrollController,
        itemCount: groupResult.length + (_allGroupListController.isFetchingMore.value ? 1 : 0),
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          if (index == groupResult.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          var groupIndex = groupResult[index];
          return Obx(() {
            return AllGroupRequestCard(
              loading: _groupJoinController.isLoadingMap[index] ?? false,
              onTab: () async {
                //Get.toNamed(AppRoutes.viewGroupScreen);
                await _groupJoinController.joinGroup(groupIndex.value.id,index);
              },
              buttonTitle: 'Join',
              icon: AppIcons.friendlistIcon,
              groupResults: groupIndex.value,
            );
          });
        },
      );
    });
  }
}
