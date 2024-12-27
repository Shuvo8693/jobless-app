
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_button.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';

class MyBioScreen extends StatefulWidget {
  const MyBioScreen({super.key});

  @override
  State<MyBioScreen> createState() => _MyBioScreenState();
}

class _MyBioScreenState extends State<MyBioScreen> {
  final ProfileController _profileController=Get.put(ProfileController(),tag: 'bio_screen');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await getProfileId();
    });
  }
  getProfileId() async {
    String authorId = await PrefsHelper.getString('authorId');
    if(authorId !=null && authorId.isNotEmpty){
      await _profileController.fetchProfile(authorId);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        child: Obx((){
          return  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full Name',style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              customListTile(_profileController.profile.value.fullName.toString(), AppIcons.profileIcon),
              SizedBox(height: 10.h),
              Text(AppString.emailText,style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              customListTile(_profileController.profile.value.email.toString(), AppIcons.emailIcon),
              SizedBox(height: 10.h),
              Text(AppString.phoneText,style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              customListTile(_profileController.profile.value.phoneNumber??'', AppIcons.phoneIcon),
              SizedBox(height: 10.h),
              Text(AppString.genderText,style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              customListTile(_profileController.profile.value.gender??'', AppIcons.friendlistIcon),
              SizedBox(height: 10.h),
              Text(AppString.dateOfBirthText,style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              customListTile(_profileController.profile.value.dataOfBirth??'', AppIcons.calenderIcon),

              SizedBox(height: 10.h),
              Text('Address',style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              customListTile(_profileController.profile.value.address??'', AppIcons.locationIcon),
              SizedBox(height: 10.h),
              Text('Skill',style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              customListTile(_profileController.profile.value.skills??'', AppIcons.skillIcon),
              SizedBox(height: 10.h),

              Text('Past Experience',style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              Container(
                height:146.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor,width: 1),
                    color: AppColors.fillColor,
                    borderRadius: BorderRadius.circular(16).r
                ),
                child:  Padding(
                  padding:  EdgeInsets.only(left: 10.w,top: 10.h),
                  child: Text(_profileController.profile.value.pastExperiences??'',style:AppStyles.h5(family: "Schuyler")),
                ),
              ),

              /// Bio
              Text('Bio',style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              Container(
                height:146.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor,width: 1),
                    color: AppColors.fillColor,
                    borderRadius: BorderRadius.circular(16).r
                ),
                child:  Padding(
                  padding:  EdgeInsets.only(left: 10.w,top: 10.h),
                  child: Text(_profileController.profile.value.bio??'',style:AppStyles.h5(family: "Schuyler")),
                ),
              ),

              /// About
              Text('About',style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              Container(
                height:146.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor,width: 1),
                    color: AppColors.fillColor,
                    borderRadius: BorderRadius.circular(16).r
                ),
                child:  Padding(
                  padding:  EdgeInsets.only(left: 10.w,top: 10.h),
                  child: Text(_profileController.profile.value.about??'',style:AppStyles.h5(family: "Schuyler")),
                ),
              ),

              /// Future plan
              Text('Future Plan',style:AppStyles.h4(family: "Schuyler")),
              SizedBox(height: 10.h,),
              Container(
                height:146.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor,width: 1),
                    color: AppColors.fillColor,
                    borderRadius: BorderRadius.circular(16).r
                ),
                child:  Padding(
                  padding:  EdgeInsets.only(left: 10.w,top: 10.h),
                  child: Text(_profileController.profile.value.futurePlan??'',style:AppStyles.h5(family: "Schuyler")),
                ),
              ),
              SizedBox(height: 10.h),
              /// job less category
              _profileController.profile.value.jobExperience==true?  Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('Jobless category',style:AppStyles.h4(family: "Schuyler")),
                  ),

                  Container(
                    height:146.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor,width: 1),
                        color: AppColors.fillColor,
                        borderRadius: BorderRadius.circular(16).r
                    ),
                    child:  Padding(
                      padding:  EdgeInsets.only(left: 10.w,top: 10.h),
                      child: Text(_profileController.profile.value.jobLessCategory?.join(',')??'',style:AppStyles.h5(family: "Schuyler")),
                    ),
                  ),
              ],): SizedBox.shrink(),


              /// Update Button

              CustomButton(
                  padding: EdgeInsets.only(top: 25.h,bottom: 10.h),
                  onTap: ()=> Get.toNamed(AppRoutes.updateProfileScreen)
                  , text: 'Edit Profile')


            ],
          );
        }
        ),
      ),
    );
  }

   customListTile(String title,String icon){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor,width: 1),
          color: AppColors.fillColor,
          borderRadius: BorderRadius.circular(16).r
      ),
      child: ListTile(
        leading: SvgPicture.asset(icon),
        title:Text(title,style:  AppStyles.customSize(
          size: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.subTextColor,
          family: "Schuyler",
        )),
      ),
    );
   }
}
