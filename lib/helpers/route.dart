import 'package:get/get.dart';
import 'package:jobless/views/screen/Auth/emailverification_screen.dart';
import 'package:jobless/views/screen/Auth/location_selector_screen.dart';
import 'package:jobless/views/screen/Auth/login_screen.dart';
import 'package:jobless/views/screen/Auth/otp_screen.dart';
import 'package:jobless/views/screen/Auth/signup_screen.dart';
import 'package:jobless/views/screen/Home/feeling_post_screen.dart';
import 'package:jobless/views/screen/Home/home_screen.dart';
import 'package:jobless/views/screen/Home/Search/search_screen.dart';
import 'package:jobless/views/screen/Message/group_inbox_screen.dart';
import 'package:jobless/views/screen/Message/inbox_screen.dart';
import 'package:jobless/views/screen/Message/see_all_message_group_member_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/create_group.dart';
import 'package:jobless/views/screen/Profile/my_group/feeling_group_post_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/invite_people_section/inviting_people_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/my_group_section/mygroup_about_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/other_group_section/other_group_about_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/other_group_section/other_group_view_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/see_all_my_group_member.dart';
import 'package:jobless/views/screen/Profile/my_group/view_member_profile_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/update_group.dart';
import 'package:jobless/views/screen/Profile/parsonal_info/status_screen.dart';
import 'package:jobless/views/screen/Profile/parsonal_info/update_profile_screen.dart';
import 'package:jobless/views/screen/Profile/payment/subscription_screen.dart';
import 'package:jobless/views/screen/Profile/setting/support_screen.dart';
import 'package:jobless/views/screen/Widget/friend_profile_view.dart';
import 'package:jobless/views/screen/Profile/friend_list/my_friends_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/about_group_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/group_base_screen.dart';
import 'package:jobless/views/screen/Profile/my_group/see_all_member.dart';
import 'package:jobless/views/screen/Profile/my_group/my_group_section/my_group_view_screen.dart';
import 'package:jobless/views/screen/Profile/parsonal_info/personal_info_screen.dart';
import 'package:jobless/views/screen/Profile/setting/about_screen.dart';
import 'package:jobless/views/screen/Profile/setting/change_password_screen.dart';
import 'package:jobless/views/screen/Profile/setting/privacy_police.dart';
import 'package:jobless/views/screen/Profile/setting/setting_screen.dart';
import 'package:jobless/views/screen/Profile/setting/terms_screen.dart';
import 'package:jobless/views/screen/Widget/view_friend_screen.dart';
import 'package:jobless/views/screen/Message/message_screen.dart';
import 'package:jobless/views/screen/Profile/profile_screen.dart';
import 'package:jobless/views/screen/onboarding_screen/job_confirmetion_screen.dart';
import 'package:jobless/views/screen/onboarding_screen/jobless_categoric_screen.dart';
import 'package:jobless/views/screen/onboarding_screen/onboarding_screen1.dart';
import '../views/screen/Message/create_massage_group_screen.dart';
import '../views/screen/Message/edit_Message_group_screen.dart';
import '../views/screen/Message/group_create_friend_choice_screen.dart';
import '../views/screen/Notification/notification_screen.dart';
import '../views/screen/Profile/friend_list/friend_list_screen.dart';
import '../views/screen/Splash/splash_screen.dart';

class AppRoutes{

  static String splashScreen="/splash_screen";
  static String homeScreen="/home_screen";
  static String profileScreen="/profile_screen";
  static String notificationScreen="/notification_screen";
  static String messageScreen="/massage_screen";
  static String onboardingScreen="/onboarding_screen";
  static String jobConfirmScreen="/jobConfirm_screen";
  static String jobCategoriScreen="/jobCategori_screen";
  static String loginScreen="/login_screen";
  static String signUpScreen="/signUp_screen";
  static String emailveryfaiScreen="/emailverifai_screen";
  static String otpScreen="/otp_screen";
  static String searchScreen="/search_screen";
  static String viewFriendScreen="/viewFriend_screen";
  static String feelpostScreen="/feelpost_screen";
  static String feelGroupPostScreen="/feeling_group_post_screen";
  static String personalInfoScreen="/personalInfo_screen";
  static String settingScreen="/setting_screen";
  static String passwordChangeScreen="/passwordChange_screen";
  static String privacyScreen="/privacy_screen";
  static String termsScreen="/term_screen";
  static String aboutsScreen="/about_screen";
  static String friendlistScreen="/friendList_screen";
  static String friendprofileViewcreen="/friendRequestView_screen";
  static String myGroupscreen="/myGroup_screen";
  static String viewGroupScreen="/viewGroup_screen";
  static String otherViewGroupScreen="/other_viewGroup_screen";
  static String aboutGroupScreen="/aboutGroup_screen";
  static String seeALlMemberScreen="/seeAllMember_screen";
  static String createGroupScreen="/createGroup_screen";
  static String myGroupAboutScreen="/myAboutGroup_screen";
  static String invitePeopleScreen="/invitingPeople_screen";
  static String subscriptionsScreen="/subscriptions_screen";
  static String messageInboxScreen="/messageInbox_screen";
  static String messageGroupCreaateScreen="/messageGroupCreate_screen";
  static String messageGroupCreaatefriendChoiceScreen="/messageGroupCreatechoice_screen";
  static String groupInboxScreen="/groupInbox_screen";
  static String editGroupNameScreen="/editGroupName_screen";
  static String locationSelectorScreen="/location_selector_screen";
  static String updateProfileScreen="/update_profile_screen";
  static String statusScreen="/status_screen";
  static String makePaymentScreen="/make_payment_screen";
  static String otherGroupAboutScreen="/other_group_about_screen";
  static String viewMemberProfileScreen="/view_Member_Profile_Screen";
  static String supportScreen="/support_Screen";
  static String updateGroupScreen="/update_group_screen";
  static String seeAllMyGroupMemberScreen="/see_all_my_member";
  static String seeAllMyGroupChatMemberScreen="/see_all_my_group_chat_member";



 static List<GetPage> page=[
    GetPage(name:splashScreen, page: ()=>const SplashScreen()),
    GetPage(name:onboardingScreen, page: ()=>const OnBoardingScreen1()),
    GetPage(name:homeScreen, page: ()=>const HomeScreen(),transition:Transition.noTransition),
    GetPage(name:notificationScreen, page: ()=>const NotificationScreen(),transition:Transition.noTransition),
    GetPage(name:messageScreen, page: ()=> MessageScreen(),transition:Transition.noTransition),
    GetPage(name:profileScreen, page: ()=>const ProfileScreen(),transition: Transition.noTransition),
     GetPage(name:jobConfirmScreen, page: ()=>const JobConfiramScreen()),
     GetPage(name:jobCategoriScreen, page: ()=>const JoblessCategoricScreen()),
     GetPage(name:loginScreen, page: ()=> LoginScreen()),
     GetPage(name:signUpScreen, page: ()=> SignUpScreen()),
     GetPage(name:emailveryfaiScreen, page: ()=> EmailVerificationScreen()),
     GetPage(name:otpScreen, page: ()=> OtpScreen()),
     GetPage(name:searchScreen, page: ()=> SearchScreen()),
     GetPage(name:viewFriendScreen, page: ()=> ViewFriendScreen()),
     GetPage(name:feelpostScreen, page: ()=> FeelingPostScreen()),
     GetPage(name:feelGroupPostScreen, page: ()=> FeelingGroupPostScreen()),
     GetPage(name:personalInfoScreen, page: ()=> PersonalInfoScreen()),
     GetPage(name:settingScreen, page: ()=> SettingScreen()),
     GetPage(name:passwordChangeScreen, page: ()=> ChangePasswordScreen()),
     GetPage(name:privacyScreen, page: ()=> PrivacyPoliceScreen()),
     GetPage(name:termsScreen, page: ()=> TermsAndConditionsScreen()),
     GetPage(name:aboutsScreen, page: ()=> AboutScreen()),
     GetPage(name:friendlistScreen, page: ()=> FriendListScreen()),
     GetPage(name:friendprofileViewcreen, page: ()=> const FriendProfileViewScreen()),
     GetPage(name:myGroupscreen, page: ()=> MyGroupBaseScreen()),
     GetPage(name:viewGroupScreen, page: ()=> ViewGroupScreen()),
     GetPage(name:aboutGroupScreen, page: ()=> AboutGroupScreen()),
     GetPage(name:seeALlMemberScreen, page: ()=> SeeAllMember()),
     GetPage(name:createGroupScreen, page: ()=> CreateGroupScreen()),
     GetPage(name:myGroupAboutScreen, page: ()=> MyGroupAboutScreen()),
     GetPage(name:invitePeopleScreen, page: ()=> InvitingPeopleScreen()),
     GetPage(name:subscriptionsScreen, page: ()=> SubscriptionScreen()),
     GetPage(name:messageInboxScreen, page: ()=> MessageInboxScreen()),
     GetPage(name:messageGroupCreaateScreen, page: ()=> MessageGroupCreateScreen()),
     GetPage(name:messageGroupCreaatefriendChoiceScreen, page: ()=> GroupCreateFriendChoiceScreen()),
     GetPage(name:groupInboxScreen, page: ()=> GroupMessageInboxScreen()),
     GetPage(name:editGroupNameScreen, page: ()=> EditMessageGroupScreen()),
     GetPage(name:locationSelectorScreen, page: ()=> const LocationSelectorScreen()),
     GetPage(name:updateProfileScreen, page: ()=> const UpdateProfileScreen()),
     GetPage(name:statusScreen, page: ()=> const StatusScreen()),
   //  GetPage(name:makePaymentScreen, page: ()=> const MakePaymentScreen()),
     GetPage(name:otherViewGroupScreen, page: ()=> OtherViewGroupScreen()),
     GetPage(name:otherGroupAboutScreen, page: ()=> const OtherGroupAboutScreen()),
     GetPage(name:viewMemberProfileScreen, page: ()=> const ViewMemberProfileScreen()),
     GetPage(name:supportScreen, page: ()=> const SupportScreen()),
     GetPage(name:updateGroupScreen, page: ()=> const UpdateGroupScreen()),
     GetPage(name:seeAllMyGroupMemberScreen, page: ()=> const SeeAllMyGroupMember()),
     GetPage(name:seeAllMyGroupChatMemberScreen, page: ()=> const SeeAllMyGroupMemberScreen()),

  ];



}