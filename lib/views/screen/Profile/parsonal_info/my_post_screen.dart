

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/profile_controller/my_post_controller.dart';
import 'package:jobless/controllers/profile_controller/post_delete_controller.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/screen/Home/modal/home_timeline_post.dart';
import 'package:jobless/views/screen/Widget/profile_post_card.dart';

class MyPostScreen extends StatefulWidget {
 final String postReward;
  const MyPostScreen({super.key,required this.postReward});


  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  final MyPostController _myPostController= Get.put(MyPostController());
  final ScrollController scrollController = ScrollController();
  String postIdFromNotification='';
 late final PostDeleteController _postDeleteController;
  @override
  void initState() {
    super.initState();
    _postDeleteController=Get.put(PostDeleteController(postController: _myPostController));
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _myPostController.fetchMyPost();
    });
    scrollController.addListener(()async {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 && !_myPostController.isFetchingMore.value) {
        await _myPostController.loadMorePost();
      }
    });
  }

  getPostIdFromNotification(){
    String? postId= Get.arguments['postId'] as String;
    if(postId.isNotEmpty){
      postIdFromNotification=postId;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Results> timeLinePostResults = _myPostController.timeLinePost.value.results??[];
      if (_myPostController.myPostLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (timeLinePostResults == null || timeLinePostResults.isEmpty) {
        return const Center(child: Text('No post available'));
      }
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: 24.w),
          child: ListView.separated(
            controller: scrollController,
            itemCount: timeLinePostResults.length + (_myPostController.isFetchingMore.value? 1:0),
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context,index){
              if(index==timeLinePostResults.length){
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final timeLineResultIndex = timeLinePostResults[index];
              return  ProfilePostCard(
                isthreeDot: true,
                results:timeLineResultIndex,
                threeDotOnTap: (){
                  showBottomSheet(context,timeLineResultIndex,index);
                }, myPostController: _myPostController,
              );
            },
            separatorBuilder: (context,index){
              return const Divider(
                  color: Color(0xffC4D3F6)
              );
            },
          ),
        );
      },
    );
  }

  showBottomSheet(BuildContext context,Results result,int index){
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Text(
                'Delete Post',
                style:AppStyles.h2(),
              ),
              const SizedBox(height: 6.0),
              Text(
                'Are you Sure you want to delete the post',
                style:AppStyles.h5(color: AppColors.subTextColor),
              ),
              const SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomOutlineButton(
                    height: 50.h,
                     width: 140.w,
                      color: AppColors.secendryColor,
                      onTap: ()=> Get.back(),
                      text: 'Cancel'),
                 // SizedBox(width: 10.w,),
                  CustomButton(
                      height: 50.h,
                      width: 140.w,
                      onTap: ()async{
                        await _postDeleteController.deletePost(result.sId,(){
                         _myPostController.removePostAt(index);
                        });
                      }, text: AppString.yesText)
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
