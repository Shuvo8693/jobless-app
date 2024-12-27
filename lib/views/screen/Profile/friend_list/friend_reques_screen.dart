import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/friendrequest_receive_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';
import 'package:jobless/views/screen/Profile/friend_list/model/friendrequest_model.dart';

import '../../Widget/friend_accept_card.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key,
      required this.friendRequestAttributes,
      required this.friendRequestReceiveController});

  final List<FriendRequestAttributes> friendRequestAttributes;
  final FriendRequestReceiveController friendRequestReceiveController;

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  final ProfileController _profileController = Get.put(ProfileController(), tag: 'friendRequest');
  final List<Profile> _profile = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await getProfileFromFriendRequest();
    });
  }

  getProfileFromFriendRequest() async {
    List<String> senderId = widget.friendRequestAttributes.map((friendRequest) {
          return friendRequest.sender;
        })
        .whereType<String>()
        .toList();
    print(senderId);

    for (String senderId in senderId) {
      await _profileController.fetchProfile(senderId);
      setState(() {
        _profile.add(_profileController.profile.value);
      });
    }
    print(_profile);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _profile.length < widget.friendRequestAttributes.length ? _profile.length : widget.friendRequestAttributes.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          final profileIndex = _profile[index];
          final friendRequestAttribute = widget.friendRequestAttributes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FriendAcceptCard(
              index: index,
              profile: profileIndex,
              friendRequestAttributes: friendRequestAttribute,
              friendRequestReceiveController: widget.friendRequestReceiveController,
            ),
          );
        });
  }
}
