import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/profile_controller/my_post_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_constants.dart';
import 'package:jobless/views/screen/Profile/parsonal_info/my_post_screen.dart';
import 'package:jobless/views/screen/Profile/parsonal_info/status_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';
import 'my_bio_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final ProfileController _profileController = Get.put(ProfileController(),tag: 'personalInfoScreen');
  final ProfileController profileControllerForProfile= Get.put(ProfileController(),tag: 'myProfile');

  final List<String> tapBarList = [
    AppString.myPostText,
    AppString.myBioText,
    AppString.statusText,
  ];
 String authorIds ='';
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await getProfileId();
    });

  }

  getProfileId() async {
    String authorId = await PrefsHelper.getString('authorId') ;
    authorIds=authorId;
    await _profileController.fetchProfile(authorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () async{
            await profileControllerForProfile.fetchProfile(authorIds);
            Get.back();
          },
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: AppColors.textColor,
              )),
        ),
        title: Text(AppString.profileText,
            style: AppStyles.customSize(
              size: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
              family: "Schuyler",
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          /// User Profile Section
         Obx((){
           return  Padding(
             padding: EdgeInsets.symmetric(horizontal: 24.w),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 ClipRRect(
                   borderRadius: BorderRadius.circular(15),
                   child: SizedBox(
                       height: 90.h,
                       width: 90.w,
                       child: _profileController.profile.value.image?.isNotEmpty == true
                           ? Image.network("${ApiConstants.imageBaseUrl}${_profileController.profile.value.image}",fit: BoxFit.contain,)
                           : Image.asset('assets/image/person.jpg',fit: BoxFit.cover)),
                 ),
                 Padding(
                   padding: EdgeInsets.only(left: 10.w),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Row(
                          children: [
                            Text("${_profileController.profile.value.fullName}",
                              style: AppStyles.customSize(
                                size: 14,
                                fontWeight: FontWeight.w500,
                                family: "Schuyler",
                              ),
                            ),
                            SizedBox(width: 6.w,),
                            _profileController.profile.value.paymentStatus=='paid'
                                ? SvgPicture.asset(AppIcons.tikmarkIcon,)
                                :SizedBox.shrink(),
                        ],),



                       SizedBox(height: 8.h),
                       _profileController.profile.value.jobExperience==true?
                       Row(
                         children: [
                           SvgPicture.asset(AppIcons.starIcon),
                           SizedBox(
                             width: 5.w,
                           ),
                           SizedBox(
                             width: 170.w,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(_profileController.profile.value.jobLessCategory?.take(2).join(',')??'', style: AppStyles.h6()),
                               ],
                             ),
                           ),
                         ],
                       ): SizedBox.shrink(),
                     ],
                   ),
                 )
               ],
             ),
           );
        }

         ),
          const SizedBox(height: 17),

          /// TabBar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var index = 0; index < tapBarList.length; index++)
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12).r,
                            color: currentIndex == index ? AppColors.primaryColor : Colors.transparent,
                            border: Border.all(color: AppColors.borderColor)),
                        child: Center(
                          child: Text(tapBarList[index],
                              style: AppStyles.customSize(
                                size: 16,
                                fontWeight: FontWeight.w500,
                                family: 'Schuyler',
                                color: currentIndex == index
                                    ? Colors.white
                                    : AppColors.primaryColor,
                              )),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// Body List data

          SizedBox(height: 20.h),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              child: Builder(
                builder: (context) {
                  switch (currentIndex) {
                    case 0:
                      return  MyPostScreen(postReward: _profileController.profile.value.paymentStatus??'',);
                    case 1:
                      return MyBioScreen();
                    case 2:
                      return StatusScreen();

                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
