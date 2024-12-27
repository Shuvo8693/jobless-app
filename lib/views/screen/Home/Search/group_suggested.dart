import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/group_controller/allgroup_list_controller.dart';
import 'package:jobless/controllers/group_controller/group_join_controller.dart';
import 'package:jobless/controllers/home_controller/group_join_home_controller.dart';
import 'package:jobless/controllers/home_controller/search_group_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Home/modal/group_search_result_model.dart';

import '../../../../utils/style.dart';
import '../../../base/casess_network_image.dart';
import '../../../base/custom_button.dart';
class GroupSuggested extends StatefulWidget {
  const GroupSuggested({super.key, required this.groupSearchController, required this.scrollController});
  final GroupSearchController groupSearchController ;
  final ScrollController scrollController;

  @override
  State<GroupSuggested> createState() => _GroupSuggestedState();
}

class _GroupSuggestedState extends State<GroupSuggested> {
 late final GroupJoinHomeController _groupJoinHomeController;
 //final GroupJoinController _groupJoinController=Get.put(GroupJoinController(allGroupListController: Get.find<AllGroupListController>()));
@override
  void initState() {
    super.initState();
    _groupJoinHomeController=Get.put(GroupJoinHomeController(groupSearchController: widget.groupSearchController));
  }
  @override
  Widget build(BuildContext context) {

    return Obx((){
      List<GroupSearchResult>? groupSearchResults = widget.groupSearchController.groupSearchResultModel.value.data?.attributes?.results;

      if (widget.groupSearchController.timeLineLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (groupSearchResults == null || groupSearchResults.isEmpty) {
        return const Center(child: Text('No group available'));
      }
      return ListView.builder(
        controller: widget.scrollController,
          itemCount: groupSearchResults.length + (widget.groupSearchController.isFetchingMore.value? 1:0),
          padding: EdgeInsets.symmetric(vertical:10.h),
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context,index){
          if(index==groupSearchResults.length){
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final groupSearchIndex = groupSearchResults[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              ///group cover image
              leading: CustomNetworkImage(
                imageUrl: "${ApiConstants.imageBaseUrl}${groupSearchIndex.coverImage}",
                height: 64.h,
                width: 64.w,
                borderRadius: BorderRadius.circular(10.r),
              ),
              /// group name
              title: Text("${groupSearchIndex.name}",style: AppStyles.customSize(size:14,fontWeight: FontWeight.w500,family: "Schuyler",),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Group description
                  Text("${groupSearchIndex.description}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: AppStyles.customSize(size:12,fontWeight: FontWeight.w400,),),
                  SizedBox(height: 10.h,),
                  CustomButton(
                      height: 40.h,
                      width: 217.w,
                      textStyle: AppStyles.h4(family: "Schuyler",color: Colors.white),
                      onTap:groupSearchIndex.joined ==true
                          ? ()=> null
                          :()async{
                            await _groupJoinHomeController.joinHomeGroup(groupSearchIndex.sId);

                      }, text: groupSearchIndex.joined==true ? "Joined":"Join Group")
                ],
              ),
            );
          });
    }

    );
  }
}
