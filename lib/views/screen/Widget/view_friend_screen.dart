import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/friendlist_controller/send_message_personal_controller.dart';
import 'package:jobless/controllers/home_controller/friendrequest_send_controller.dart';
import 'package:jobless/controllers/message_controller/send_message_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/screen/Auth/model/user_profile.dart';
import 'package:jobless/views/screen/Home/modal/search_user_model.dart';

import '../../../utils/style.dart';
import '../../base/casess_network_image.dart';
import '../../base/custom_button.dart';
import '../../base/custom_outlinebutton.dart';

class ViewFriendScreen extends StatefulWidget {
  const ViewFriendScreen({super.key});

  @override
  State<ViewFriendScreen> createState() => _ViewFriendScreenState();
}

class _ViewFriendScreenState extends State<ViewFriendScreen> {
  final FriendRequestSendController _requestSendController=Get.put(FriendRequestSendController());
  final SendPersonalMessageController _sendPersonalMessageController=Get.put(SendPersonalMessageController(),tag: 'viewFiendScreen');
  final ProfileController _profileController = Get.put(ProfileController());
  User user = User();
  @override
  void initState() {
    super.initState();
    userData();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
     await getUserId();
    });

  }
  userData()async{
    if( Get.arguments['user'] !=null){
        user = Get.arguments['user'] as User;
        print(user.toString());
    }
  }

  getUserId()async{
    if(user.sId?.isNotEmpty==true){
      await _profileController.fetchProfile(user.sId);
    }
    print(user.toString());
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
        child: Obx((){
         Profile  users = _profileController.profile.value;
          return  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
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
                                SizedBox(width: 10.w,),
                                users.paymentStatus=='paid'?SvgPicture.asset(AppIcons.tikmarkIcon):SizedBox.shrink(),
                                SizedBox(width: 5.w,),
                                users.jobExperience!=true? SvgPicture.asset(AppIcons.yellowStarIcon):SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.locationIcon),
                                SizedBox(width: 5.w,),
                                Text(
                                    "${users.address}",
                                    style: AppStyles.h6()
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h,),

                            users.jobExperience==true? Row(
                              children: [
                                SvgPicture.asset(AppIcons.starIcon),
                                SizedBox(width: 5.w,),
                                SizedBox(
                                  width: 175.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(users.jobLessCategory?.take(2).join(',')??'',
                                          style: AppStyles.h6()
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ): const SizedBox.shrink(),
                            SizedBox(height: 14.h),
                            Row(
                              children: [
                                GetBuilder<FriendRequestSendController>(builder: (GetxController controller){
                                  return user.friendRequestStatus!.contains('accepted')!=true? CustomButton(
                                      onTap: ()async{
                                        await _requestSendController.sendRequest(user.sId);
                                        if (_requestSendController.message.isNotEmpty) {
                                          Get.snackbar(
                                            'Friend Request', // Title
                                            _requestSendController.message.value, // Message
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.greenAccent,
                                            colorText: Colors.white,
                                            duration: const Duration(seconds: 2),
                                          );
                                        }
                                      },
                                      width: 120.w,
                                      height: 35.h,
                                      text: user.friendRequestStatus=='pending' ?"pending":'Request') : SizedBox.shrink();
                                }),

                                SizedBox(width: 15.w,),

                                CustomOutlineButton(
                                  onTap: ()async {
                                    if(user.sId!.isNotEmpty){
                                      await _sendPersonalMessageController.sendPersonalMessage(profileId:user.sId??'' );
                                    }
                                  },
                                  width: 110.w,
                                  height: 30,
                                  text: 'Message',
                                  textStyle: AppStyles.h5(),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              /// All About

              SizedBox(height: 15.h),
              allAbout(users)
            ],
          );
        }

        ),
      ),
    );
  }

  /// About Section

  allAbout(Profile users){

   return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.h),
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
          SizedBox(height:16.h,),
          Text(
            users.about??'N/A',
            style: AppStyles.h5(
              color: AppColors.subTextColor
            )
          ),

          /// Email

          SizedBox(height:24.h,),
          Text(
            AppString.emailText,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height:5.h,),
          Text(
              "${users.email}",
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Phone Number
          SizedBox(height:24.h,),
          Text(
            AppString.phoneText,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height:5.h,),
          Text(users.phoneNumber??'',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Skill

          SizedBox(height:24.h,),
          Text(
            "Skill",
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height:5.h,),
          Text(users.skills??'',
              style: AppStyles.h5(
                  color: AppColors.subTextColor
              )
          ),

          /// Bio
          SizedBox(height:24.h,),
          Text(
            AppString.bioText,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height:5.h,),
          Text(users.bio??'',
              style: AppStyles.h5(color: AppColors.subTextColor)
          ),

          /// Past experience
          SizedBox(height:24.h,),
          Text('Past Experience',
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height:5.h,),
          Text(users.pastExperiences??'',
              style: AppStyles.h5(color: AppColors.subTextColor)
          ),

          /// Future plan
          SizedBox(height:24.h,),
          Text('Future plan',
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              family: "Schuyler",
            ),
          ),
          SizedBox(height:5.h,),
          Text(users.futurePlan??'',
              style: AppStyles.h5(color: AppColors.subTextColor)
          ),



          /// Job less Categotic

          SizedBox(height:24.h,),
          users.jobExperience==true? Wrap(
            children: [
              Text(
                AppString.jobLessCategotiText,
                style: AppStyles.customSize(
                  size: 16,
                  fontWeight: FontWeight.w500,
                  family: "Schuyler",
                ),
              ),
              SizedBox(height:5.h,),
               Text(users.jobLessCategory?.join(',')??'',
                style: AppStyles.h5(color: AppColors.subTextColor),
              ),
            ],
          ):SizedBox.shrink(),

          SizedBox(height: 30.h,),

        ],

      ),
    );
  }
}
