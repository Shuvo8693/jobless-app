

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/my_friend_controller.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/my_friend_model.dart';
import 'package:jobless/views/screen/Profile/friend_list/widgets/my_friend_card.dart';
import 'package:jobless/views/screen/Widget/member_card.dart';

import '../../../../helpers/route.dart';
import '../../Widget/friend_accept_card.dart';


class MyFriendScreen extends StatefulWidget {
  const MyFriendScreen({super.key});

  @override
  State<MyFriendScreen> createState() => _MyFriendScreenState();
}

class _MyFriendScreenState extends State<MyFriendScreen> {
  final MyFriendController _myFriendController =Get.put(MyFriendController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _myFriendController.fetchMyFriendList();
    });

  }
  @override
  Widget build(BuildContext context) {
   return Obx((){
     List<Friends>? friends= _myFriendController.myFriendModel.value.data?.attributes?.friends;
     if(friends ==null ||friends.isEmpty){
       return const Center(child: Text('No friend available'));
     }
     if(_myFriendController.isLoading.value){
       return const Center(child: CircularProgressIndicator());
     }
      return ListView.builder(
          itemCount: friends.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context,index){
           final friendIndex = friends[index];
            return MyFriendCard(
              onTab: (){
                Get.toNamed(AppRoutes.friendprofileViewcreen,arguments: {'friendID': friendIndex.id});
              }, friends: friendIndex,
            );
          });
    });

  }
}
