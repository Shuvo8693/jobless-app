import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_outlinebutton.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_string.dart';
import '../../../utils/style.dart';
import '../../base/bottom_menu..dart';
import '../../base/casess_network_image.dart';
import '../Widget/customListtile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController= Get.put(ProfileController(),tag: 'myProfile');


   @override
  void initState() {
    super.initState();
    fetchProfile();
   }

  fetchProfile()async{
    var userId = await PrefsHelper.getString('authorId');
     await _profileController.fetchProfile(userId);

  }
@override
  void dispose() {
    super.dispose();
    _profileController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      bottomNavigationBar: const BottomMenu(3),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: ClipPathClass(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Obx((){
                  print("My profile ID : ${_profileController.profile.value.id.toString()}");
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: 50.h,),

                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                            AppString.profileText,
                            style: AppStyles.h4(color: Colors.white)
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      CustomNetworkImage(
                        imageUrl: "${ApiConstants.imageBaseUrl}${_profileController.profile.value.image}",
                        height: 120.h,
                        width: 120.w,
                        border: Border.all(color: Colors.white,width: 3),
                        boxShape: BoxShape.circle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${_profileController.profile.value.fullName}",
                              style: AppStyles.h4(color: Colors.white)
                          ),
                          const SizedBox(width: 5,),
                          _profileController.profile.value.paymentStatus=='paid'
                              ? SvgPicture.asset(AppIcons.tikmarkIcon,color: Colors.white,):SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(height: 8.h,),
                      _profileController.profile.value.jobExperience==true?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppIcons.starIcon,color: Colors.white,),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: 175.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_profileController.profile.value.jobLessCategory?.take(2).join(',')??'',
                                    style: AppStyles.h6(color: Colors.white)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ): const SizedBox.shrink(),

                      SizedBox(height: 30.h,)
                    ],
                  );
                }

                ),
              ),
            ),



            SizedBox(height: 16.h),

            /// Gold package container

            InkWell(
              onTap: (){
                Get.toNamed(AppRoutes.subscriptionsScreen);
              },
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  height:78.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.primaryColor
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: 14.w),
                        child: SvgPicture.asset(AppIcons.crownIcon),
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "gold package",
                              style: AppStyles.h4(color: Colors.white)
                          ),
                          Text(
                              "annually subscription",
                              style: AppStyles.h6(color: Colors.white)
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            ///Personal information

            Customlisttile(
              title:AppString.personalInfoText,
              icon: AppIcons.profileIcon,
              onTap: (){
                Get.toNamed(AppRoutes.personalInfoScreen);
              },
            ),

         /// My Friend List
            SizedBox(height: 16.h),
            Customlisttile(
              title:AppString.myFriendText,
              icon: AppIcons.friendlistIcon,
              onTap: (){
                Get.toNamed(AppRoutes.friendlistScreen);
              },
            ),


            /// My Group Screen
            SizedBox(height: 16.h),
            Customlisttile(
              title:AppString.myGroupText,
              icon: AppIcons.menuIcon,
              onTap: (){
                Get.toNamed(AppRoutes.myGroupscreen);
              },
            ),

           /// setting screen
            SizedBox(height: 16.h),
               Customlisttile(
                title:AppString.settionText,
                icon: AppIcons.settingIcon,
                onTap: (){
                  Get.toNamed(AppRoutes.settingScreen,arguments: {'email':_profileController.profile.value.email});
                },
              ),

            /// Logout screen
            SizedBox(height: 16.h),
            Customlisttile(
              title:AppString.logoutText,
              icon: AppIcons.logOutIcon,
              onTap: (){
                showCustomDialog(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout",style: AppStyles.h2(),),
        content: const Text("Are you sure you want to log out ?"),
        actions: [
          CustomOutlineButton(
              width: 55,
              onTap: (){
                Get.back();
              }, text: 'No'),

           CustomButton(
             width: 55,
               onTap: ()async{
                await PrefsHelper.remove('token');
               String token = await PrefsHelper.getString('token');
                if(token.isEmpty){
                  Get.offAllNamed(AppRoutes.splashScreen);
                }
               }, text: 'Yes'),
        ],
      );
    },
  );
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start at the top left
    path.moveTo(0, 0);

    // Draw a straight line to the top right corner
    path.lineTo(size.width, 0);

    // Draw a line to the bottom right, leaving space for the curve
    path.lineTo(size.width, size.height.h - 15);

    // Create a curve at the bottom-right corner
    var controlPointRight = Offset(size.width.w / 2, size.height.h + 40.h);
    var endPointRight = Offset(0, size.height.h - 15);
    path.quadraticBezierTo(
        controlPointRight.dx, controlPointRight.dy, endPointRight.dx, endPointRight.dy);

    // Line to the bottom-left corner
    path.lineTo(0, size.height.h - 30);

    // Close the path
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

