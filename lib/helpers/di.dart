
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/auth_controller/like_controller.dart';
import 'package:jobless/controllers/auth_controller/verify_email_controller.dart';
import 'package:jobless/controllers/category_controller.dart';
import 'package:jobless/controllers/friendlist_controller/friend_request_accept_controller.dart';
import 'package:jobless/controllers/friendlist_controller/friendrequest_receive_controller.dart';
import 'package:jobless/controllers/group_controller/Leave_group_controller.dart';
import 'package:jobless/controllers/group_controller/allgroup_list_controller.dart';
import 'package:jobless/controllers/group_controller/create_group_post_controller.dart';
import 'package:jobless/controllers/group_controller/group_join_controller.dart';
import 'package:jobless/controllers/group_controller/group_post_like_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_about_controller.dart';
import 'package:jobless/controllers/group_controller/mygroup_controller.dart';
import 'package:jobless/controllers/group_controller/update_my_group_controller.dart';
import 'package:jobless/controllers/home_controller/create_post_controller.dart';
import 'package:jobless/controllers/home_controller/friendrequest_send_controller.dart';
import 'package:jobless/controllers/home_controller/get_comment_controller.dart';
import 'package:jobless/controllers/home_controller/group_join_home_controller.dart';
import 'package:jobless/controllers/home_controller/search_friend_controller.dart';
import 'package:jobless/controllers/home_controller/search_group_controller.dart';
import 'package:jobless/controllers/home_controller/timeline_post_controller.dart';
import 'package:jobless/controllers/message_controller/chat_list_controller.dart';
import 'package:jobless/controllers/message_controller/search_friend_list_controller.dart';
import 'package:jobless/controllers/message_controller/send_message_controller.dart';
import 'package:jobless/controllers/message_controller/web_socket_controller.dart';
import 'package:jobless/controllers/profile_controller/my_post_controller.dart';
import 'package:jobless/controllers/profile_controller/post_delete_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_post_like_controller.dart';
import 'package:jobless/controllers/settings_controller/about_us_controller.dart';
import 'package:jobless/controllers/settings_controller/privacy_controller.dart';
import 'package:jobless/controllers/settings_controller/support_controller.dart';
import 'package:jobless/controllers/settings_controller/term_and_condition.dart';
import 'package:jobless/controllers/subscription_controller/make_payment_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/group_controller/group_timeline_post_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/localization_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/language_model.dart';
import '../utils/app_constants.dart';


Future<Map<String, Map<String, String>>>  init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => CategoryController());
  Get.lazyPut(() => VerifyEmailController());
  Get.lazyPut(() => TimelinePostController());
  Get.lazyPut(() => LikeController(timelinePostController: Get.find()));
  Get.lazyPut(() => CommentProviderController());
  Get.lazyPut(() => PostController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => PostDeleteController(postController: Get.find<MyPostController>()));
  Get.lazyPut(() => SearchFriendController());
  Get.lazyPut(() => FriendRequestSendController());
  Get.lazyPut(() => AllGroupListController());
  Get.lazyPut(() => MyGroupController());
  Get.lazyPut(() => GroupTimelinePostController());
  Get.lazyPut(() => AllGroupAboutController());
  Get.lazyPut(() => GroupCreatePostController());
  Get.lazyPut(() => FriendRequestReceiveController());
  Get.lazyPut(() => PaymentController());
  Get.lazyPut(() => FriendRequestAcceptController());
  Get.lazyPut(() => GroupPostLikeController(groupTimelinePostController: Get.find()));
  Get.lazyPut(() => GroupJoinController(allGroupListController: Get.find()));
  Get.lazyPut(() => GroupSearchController());
  Get.lazyPut(() => ChatListController());
  Get.lazyPut(() => WebSocketController());
  Get.lazyPut(() => SendMessageController());
  Get.lazyPut(() => PrivacyController());
  Get.lazyPut(() => TermAndConditionController());
  Get.lazyPut(() => AboutUsController());
  Get.lazyPut(() => SupportController());
  Get.lazyPut(() => LeaveGroupController());
  Get.lazyPut(() => UpdateMyGroupController());
  Get.lazyPut(() => SearchMyFriendController());
  Get.lazyPut(() => ProfilePostLikeController(myPostController: Get.find<MyPostController>()));
  Get.lazyPut(() => GroupJoinHomeController(groupSearchController: Get.find<GroupSearchController>()));





  //Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }
  return _languages;
}