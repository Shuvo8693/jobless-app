import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/send_message_personal_controller.dart';
import 'package:jobless/controllers/home_controller/friendrequest_send_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/casess_network_image.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';
import 'package:jobless/views/screen/Home/modal/search_user_model.dart';

class ViewMemberProfileScreen extends StatefulWidget {
  const ViewMemberProfileScreen({super.key});

  @override
  State<ViewMemberProfileScreen> createState() =>
      _ViewMemberProfileScreenState();
}

class _ViewMemberProfileScreenState extends State<ViewMemberProfileScreen> {
  final FriendRequestSendController _requestSendController = Get.put(FriendRequestSendController());
  final ProfileController _profileController = Get.put(ProfileController(),tag: 'viewMemberProfile');
  final SendPersonalMessageController _sendPersonalMessageController=Get.put(SendPersonalMessageController());
  Profile users = Profile();
  String authorId='';

  @override
  void initState() {
    super.initState();
    userData();
    getAuthorId();
  }
  getAuthorId()async{
   String id =  await PrefsHelper.getString('authorId');
   if(id.isNotEmpty){
     authorId=id;
   }
  }
  userData() async {
    if (Get.arguments['membersUserId'] != null) {
      dynamic userId = Get.arguments['membersUserId'];
      await _profileController.fetchProfile(userId);
      setState(() {
        users = _profileController.profile.value;
      });

      print(users.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                    imageUrl: "${ApiConstants.imageBaseUrl}${users.image}",
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
                          children: [
                            Text(
                              "${users.fullName}",
                              style: AppStyles.customSize(
                                size: 14,
                                fontWeight: FontWeight.w500,
                                family: "Schuyler",
                              ),
                            ),
                            SizedBox(width: 8.h),
                            _profileController.profile.value.jobExperience!=true
                                ? SvgPicture.asset(AppIcons.yellowStarIcon):SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.locationIcon),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text("${users.address}", style: AppStyles.h6()),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        users.jobExperience==true
                            ? Row(
                                children: [
                                  SvgPicture.asset(AppIcons.starIcon),
                                  SizedBox(width: 5.w),
                                  SizedBox(
                                    width: 175.w,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(users.jobLessCategory?.take(2).join(',')??'',
                                            style: AppStyles.h6()),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        SizedBox(height: 14.h),
                        users.id!=authorId?  Row(
                          children: [
                            GetBuilder<FriendRequestSendController>(
                                builder: (GetxController controller) {
                              return CustomButton(
                                  onTap: () async {
                                    await _requestSendController.sendRequest(users.id);
                                    if (_requestSendController.message.isNotEmpty) {
                                      Get.snackbar(_requestSendController.message.value, '',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: Colors.greenAccent,
                                        colorText: Colors.white,
                                        padding:  EdgeInsets.only(top: 20.h,left: 10.w),
                                        duration: const Duration(seconds: 2),
                                      );
                                    }
                                  },
                                  width: 110.w,
                                  height: 35.h,
                                  text: "Friend Request");
                            }),
                            SizedBox(width: 15.w),
                            CustomOutlineButton(

                              onTap: () async{
                                if( users.id!.isNotEmpty){
                                  await _sendPersonalMessageController.sendPersonalMessage(profileId: users.id??'');
                                }
                              },
                              width: 70.w,
                              height: 30,
                              text: 'Message',
                              textStyle: AppStyles.h5(),
                            ),
                            SizedBox(width: 10.w),
                          ],
                        ) : SizedBox.shrink()
                      ],
                    ),
                  )
                ],
              ),
            ),

            /// All About

            SizedBox(height: 15.h),
            allAbout()
          ],
        ),
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
        ],
      ),
    );
  }
}
