

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobless/controllers/file_controller.dart';
import 'package:jobless/controllers/group_controller/create_group_post_controller.dart';
import 'package:jobless/controllers/group_controller/group_timeline_post_controller.dart';
import 'package:jobless/controllers/home_controller/create_post_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/utils/style.dart';
import 'package:jobless/views/base/custom_button.dart';


class FeelingGroupPostScreen extends StatefulWidget {
  const FeelingGroupPostScreen({super.key});

  @override
  State<FeelingGroupPostScreen> createState() => _FeelingGroupPostScreenState();
}

class _FeelingGroupPostScreenState extends State<FeelingGroupPostScreen> {
  final FileController _createPostCtrl =Get.put(FileController());
  final GroupCreatePostController _groupCreatePostController=Get.put(GroupCreatePostController());
  TextEditingController postCtrl=TextEditingController();
  final GroupTimelinePostController _groupTimeLinePostController = Get.put(GroupTimelinePostController());

  int? _selectedValue;
  String selectPrivacy="";
  String _profileImage='';
  String _groupId='';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await getProfileImage();
      getGroupId();
    });
  }
  getProfileImage()async{
    String imageValue= await PrefsHelper.getString('profileImage');
    setState((){
      _profileImage = imageValue;
    });

    print(_profileImage);
  }

  getGroupId(){
    String groupId=Get.arguments['myGroupID'];
    setState(() {
      _groupId=groupId;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: (){
            WidgetsBinding.instance.addPostFrameCallback((__)async{
              await _groupTimeLinePostController.fetchMyGroupPost(groupId: _groupId);
              Get.back();
            });
          },
          child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.textColor,
              )),
        ),
        actions: [
          Obx((){
            return  CustomButton(
                loading: _groupCreatePostController.isLoading.value,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                height: 38.h,
                width: 85.w,
                onTap: ()async{
                  await _groupCreatePostController.createGroupPost(postCtrl.text, _createPostCtrl.getFilePath.value,selectPrivacy, _groupId);
                }, text: AppString.postText);
          }

          )
        ],
      ),

      body: SingleChildScrollView(

          child:Obx(()=> Column(
            children: [
              SizedBox(height: 20.h,),
              _createPostCtrl.type.value=='image'?  Container(
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xffF9F6F1),
                  border: Border.all(color:AppColors.primaryColor),
                  image: DecorationImage(image: FileImage(
                    File(_createPostCtrl.filePath.value),
                  ),fit: BoxFit.fill ),
                ),
              ):_createPostCtrl.type.value=='pdf'?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.primaryColor)
                    ),
                    child: Center(
                      child: Text('Pdf',style: AppStyles.h4(color: AppColors.primaryColor),),

                    ),
                  ),
                  SizedBox(width: 15.w,),
                  Text('${_createPostCtrl.fileName}',style: AppStyles.h3(),),
                ],
              ):Container(),
              SizedBox(height: 24.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      showImagePickerOption(context);
                    },
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        height:54.h,
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.primaryColor.withOpacity(0.2))

                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(left: 10.w,right: 10.w),
                          child: Center(child: Text('Upload File',style: AppStyles.h5(color: AppColors.primaryColor),)),
                        ),
                      ),
                    ),
                  ),
                  /* InkWell(
                 onTap: (){
                   _createPostCtrl.pickFile();

                 },
                 child: Container(
                   height:54.h,
                   decoration:BoxDecoration(
                       borderRadius: BorderRadius.circular(16.r),
                       border: Border.all(color: AppColors.primaryColor.withOpacity(0.2))

                   ),
                   child: Center(child: Padding(
                     padding:  EdgeInsets.only(left: 10.w,right: 10.w),
                     child: Text('Upload PDF',style: AppStyles.h5(color: AppColors.primaryColor),),
                   )),
                 ),
               ),*/
                ],
              ),

              SizedBox(height: 30.h,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: postCtrl,
                    cursorColor: AppColors.subTextColor,
                    // textAlign: TextAlign.center,  // Centers the text and cursor
                    decoration: InputDecoration(
                      hintText: "What’s happening ?",
                      contentPadding: EdgeInsets.zero,
                      hintStyle: AppStyles.h6(color: AppColors.subTextColor), // Customize the hint text color
                      fillColor: Colors.transparent,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none, // Transparent border
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent), // Transparent when not focused
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent), // Transparent when focused
                      ), // Adjust the prefix constraints to fit properly
                      prefixIcon: Padding(
                        padding:  const EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${ApiConstants.imageBaseUrl}$_profileImage',),),
                      ),
                      ///-----Privacy section----
                      suffixIcon: InkWell(
                        onTap: (){
                          postSelect(context);
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                              AppIcons.threeDotIcon,
                              height: 20.h,
                              color: const Color(0xffC4D3F6)),
                        ),
                      ),
                    ),
                  )),

            ],
          )
          )),
    );
  }

  /// Post Select

  void postSelect(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secendryColor,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Post Public'),
                    titleTextStyle:AppStyles.customSize(
                      size: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                      family: "Schuyler",
                    ),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value;
                          selectPrivacy= "public";
                          print("Select>>>$selectPrivacy");
                        });

                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Post Private'),
                    titleTextStyle:AppStyles.customSize(
                      size: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                      family: "Schuyler",
                    ),
                    leading: Radio<int>(
                      value: 2,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value;
                          selectPrivacy= "private";
                          print("Select>>>$selectPrivacy");
                        });

                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }



  showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      // backgroundColor: AppColors.AppBgColor,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*Expanded(
                    child: InkWell(
                      onTap: () {

                       _createPostCtrl.pickImageFromCamera(ImageSource.gallery);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            const Text('Gallery')
                          ],
                        ),
                      ),
                    ),
                  ),*/
                  Expanded(
                      child: GetBuilder<GroupCreatePostController>(builder: (context){
                        return  InkWell(
                          onTap: ()async {
                            await _createPostCtrl.pickFile();

                          },
                          child: SizedBox(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.file_copy_outlined,
                                  size: 50.w,
                                  color: AppColors.primaryColor,
                                ),
                                const Text('File')
                              ],
                            ),
                          ),
                        );
                      })

                  ),
                ],
              ),
            ),
          );
        });
  }
}
