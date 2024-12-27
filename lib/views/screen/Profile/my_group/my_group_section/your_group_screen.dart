import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/mygroup_controller.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/screen/Profile/my_group/group_model/all_group_model.dart';
import 'package:jobless/views/screen/Widget/all_group_request_card.dart';

import '../../../../../helpers/route.dart';

class YourGroupScreen extends StatefulWidget {
  const YourGroupScreen({super.key});

  @override
  State<YourGroupScreen> createState() => _YourGroupScreenState();
}

class _YourGroupScreenState extends State<YourGroupScreen> {
  final MyGroupController _myGroupController = Get.put(MyGroupController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
     await _myGroupController.fetchMyGroupList();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
            !_myGroupController.isFetchingMore.value) {
          await _myGroupController.loadMorePost();
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    ///========My group List Screen======
    return Obx(() {
      List<GroupResults>? groupResult = _myGroupController.groupModel.value.groupData?.groupAttributes?.groupResults;

      if (_myGroupController.timeLineLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (groupResult == null || groupResult.isEmpty) {
        return const Center(child: Text('No group available'));
      }

      return ListView.builder(
        itemCount: groupResult.length + (_myGroupController.isFetchingMore.value ? 1 : 0),
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index == groupResult.length) {
            // Display a loading indicator at the bottom of the list when fetching more
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          var myGroupIndex = groupResult[index];
          return AllGroupRequestCard(
            onTab: () {
              Get.toNamed(AppRoutes.viewGroupScreen, arguments: {'myGroupAttributes': myGroupIndex});
            },
            buttonTitle: 'View',
            icon: AppIcons.friendlistIcon,
            groupResults: myGroupIndex,
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the scroll controller when done
    super.dispose();
  }
}
