import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/friend_remove_controller.dart';
import 'package:jobless/controllers/friendlist_controller/my_friend_controller.dart';
import 'package:jobless/controllers/friendlist_controller/send_message_personal_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';

import '../../../utils/style.dart';
import '../../base/casess_network_image.dart';


class FriendProfileViewScreen extends StatefulWidget {
  const FriendProfileViewScreen({super.key});

  @override
  State<FriendProfileViewScreen> createState() => _FriendProfileViewScreenState();
}

class _FriendProfileViewScreenState extends State<FriendProfileViewScreen> {
  final ProfileController _profileController = Get.put(ProfileController(),tag: 'friendProfile');
  final FriendRemoveController _friendRemoveController= Get.put(FriendRemoveController());
  final MyFriendController _myFriendController =Get.put(MyFriendController());
  final SendPersonalMessageController _sendPersonalMessageController=Get.put(SendPersonalMessageController());
 bool isRemoveCancel=false;
  @override
  void initState() {
    getButtonOff();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await getProfile();
    });
  }
 getButtonOff(){
   bool cancelRemove = Get.arguments['isRemoveCancel']??false;
   if(cancelRemove==true){
     isRemoveCancel=cancelRemove;
   }
 }
  getProfile() async {
    String friendId = Get.arguments['friendID'] as String;
    if (friendId != null || friendId.isNotEmpty) {
      await _profileController.fetchProfile(friendId);
    }
  }
  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () async {
            await _myFriendController.fetchMyFriendList();
            Get.back();
          },
          child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.textColor,
              )),
        ),
      ),
      body: Obx((){
        if(_profileController.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }
        if(_profileController.profile.value ==null){
          return const Text('Empty profile');
        }
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomNetworkImage(
                        imageUrl: "${ApiConstants.imageBaseUrl}${_profileController.profile.value.image}",
                        height: 64.h,
                        width: 64.w,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _profileController.profile.value.fullName ?? 'N/A',
                                  style: AppStyles.customSize(
                                    size: 14,
                                    fontWeight: FontWeight.w500,
                                    family: "Schuyler",
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                _profileController.profile.value.paymentStatus=='paid'
                                    ? SvgPicture.asset(AppIcons.tikmarkIcon):SizedBox.shrink(),

                                const SizedBox(width: 5,),
                                _profileController.profile.value.jobExperience!=true
                                    ? SvgPicture.asset(AppIcons.yellowStarIcon):SizedBox.shrink(),
                              ],
                            ),

                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.locationIcon),
                                SizedBox(width: 5.w,),
                                Text(_profileController.profile.value.address ?? 'N/A',
                                    style: AppStyles.h6()
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h,),
                            ///====jobless category===
                          _profileController.profile.value.jobExperience==true
                              ? Row(
                              children: [
                                 SvgPicture.asset(AppIcons.starIcon),
                                 SizedBox(width: 5.w,),
                                 SizedBox(
                                   width: 175.w,
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(_profileController.profile.value.jobLessCategory?.take(2).join(',') ?? 'N/A', style: AppStyles.h6()),
                                     ],
                                   ),
                                 ) ,
                              ],
                            ): const SizedBox.shrink(),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Align(
                alignment:Alignment.centerRight,
                child: Padding(
                  padding:  EdgeInsets.only(right: 10.w),
                  child: CustomOutlineButton(
                    onTap: () async{
                      if( _profileController.profile.value.id!.isNotEmpty){
                        await _sendPersonalMessageController.sendPersonalMessage(profileId: _profileController.profile.value.id??'');
                      }
                    },
                    width: 110.w,
                    height: 30,
                    text: 'Send Message',
                    textStyle: AppStyles.h5(),
                  ),
                ),
              ),

              /// All About

              SizedBox(height: 15.h),
              allAbout()
            ],
          ),
        );
      }
      ),
    );
  }

  /// About Section

  allAbout() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// about

          Text(
            AppString.aboutText,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height: 16.h,),
          Text(_profileController.profile.value.about ?? "N/A", style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Email

          SizedBox(height: 24.h,),
          Text(
            AppString.emailText,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
              _profileController.profile.value.email ?? 'N/A',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Phone Number
          SizedBox(height: 24.h,),
          Text(
            AppString.phoneText,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
              _profileController.profile.value.phoneNumber ?? 'N/A',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Skill

          SizedBox(height: 24.h,),
          Text(
            "Skill",
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
              _profileController.profile.value.skills ?? 'N/A',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Bio
          SizedBox(height: 24.h,),
          Text(
            AppString.bioText,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height: 5.h,),
          Text(_profileController.profile.value.bio ?? 'N/A',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),  SizedBox(height: 24.h,),

          /// Past experience
          Text('Past Experience',
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
              _profileController.profile.value.pastExperiences ?? 'N/A',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),
          /// Future Plan
          SizedBox(height: 24.h,),
          Text('Future Plan',
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height: 5.h,),
          Text(_profileController.profile.value.futurePlan ?? 'N/A',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Job less Categotic
          SizedBox(height: 8.h,),
          _profileController.profile.value.jobExperience==true? Wrap(
            children: [
              SizedBox(height: 24.h,),
              Text(
                AppString.jobLessCategotiText,
                style: AppStyles.customSize(
                  size: 16,
                  fontWeight: FontWeight.w500,
                  family: "Schuyler",
                ),
              ),
              SizedBox(height: 5.h,),
              Text(_profileController.profile.value.jobLessCategory?.join(',') ?? 'N/A',
                  style: AppStyles.h5(
                      color: AppColors.subTextColor
                  )
              ),
            ],
          ): SizedBox.shrink(),

       ///====Remove user===
          isRemoveCancel!=true? Obx(() {
        return CustomButton(
          loading: _friendRemoveController.isLoading.value,
          padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
          onTap: () async {
            if(_profileController.profile.value.id!.isNotEmpty){
              await _friendRemoveController.removeFriend(_profileController.profile.value.id,toRemoveFromIndex: (){
                _profileController.profile.value = Profile();
                _profileController.profile.refresh();
              });
            }

           /* if (!_friendRemoveController.isLoading.value && _friendRemoveController.responseMessage.value.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(_friendRemoveController.responseMessage.value),
                  duration: const Duration(seconds: 3), // Adjust duration as needed
                ),
              );
             // Get.offNamed(AppRoutes.friendlistScreen);
            }*/
          },
          text:_profileController.profile.value.id?.isNotEmpty??false? 'Remove User':'Removed',
        );
      }): SizedBox.shrink(),

          SizedBox(height: 30.h,),

        ],

      ),
    );
  }
}
