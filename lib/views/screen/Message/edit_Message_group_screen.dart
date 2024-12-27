import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobless/controllers/group_controller/create_group_controller.dart';
import 'package:jobless/controllers/message_controller/group_message_update_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_text_field.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';


class EditMessageGroupScreen extends StatefulWidget {
 const EditMessageGroupScreen({super.key});

  @override
  State<EditMessageGroupScreen> createState() => _EditMessageGroupScreenState();
}

class _EditMessageGroupScreenState extends State<EditMessageGroupScreen> {
  final GroupMessageUpdateController _groupMessageUpdateController=Get.put(GroupMessageUpdateController());

  TextEditingController nameCtrl=TextEditingController();

  String chatId='';

  @override
  void initState() {
    super.initState();
    getGroupChatId();
  }
  getGroupChatId(){
   String id= Get.arguments['chatId'] as String;
   if(id.isNotEmpty){
     chatId=id;
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.arrow_back_ios,size: 18,color: AppColors.textColor,)),

        ),
        title: Text('Update Chat Group',style: AppStyles.h3(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Upload Picture
            Obx(()=> Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      showImagePickerOption(context);
                    },
                    child:_groupMessageUpdateController.imagePath.isNotEmpty? Container(
                      height: 120.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Color(0xffF9F6F1),
                        border: Border.all(color:AppColors.primaryColor),
                        image: DecorationImage(image: FileImage(
                          File(_groupMessageUpdateController.imagePath.value),
                        ),fit: BoxFit.cover ),
                      ),

                    ):
                    Container(
                      height: 120.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Color(0xffC4D3F6),
                        border: Border.all(color:AppColors.primaryColor),
                      ),
                      child: Center(child: SvgPicture.asset(AppIcons.uploadIcon,height: 25.h,width: 22.w,)),
                    ),
                  ),

                  SizedBox(height: 10.h,),
                  Text('upload your group message image',style:AppStyles.h5()),
                ],
              ),
            ),),

            /// Name
            SizedBox(height: 16.h,),
            Text(AppString.nameText,style:AppStyles.h4(family: "Schuyler")),
            SizedBox(height: 10.h,),
            CustomTextField(
                hintText: 'Group Name',
                contentPaddingVertical: 15.h,
                controller:nameCtrl),
            /// Create Button

            SizedBox(height: 55.h,),
            Align(alignment: Alignment.bottomCenter,

                child: Obx((){
                  return  CustomButton(
                      loading:_groupMessageUpdateController.isLoading.value ,
                      onTap: ()async{
                        if(chatId.isNotEmpty){
                          await _groupMessageUpdateController.updateGroupMessage(chatId: chatId, name: nameCtrl.text);
                        }
                        //  Get.toNamed(AppRoutes.messageGroupCreaatefriendChoiceScreen);
                      }, text: 'Update');
                }

                ))
          ],
        ),
      ),
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
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _groupMessageUpdateController.pickImageFromCamera(ImageSource.gallery);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            Text('Gallery')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _groupMessageUpdateController.pickImageFromCamera(ImageSource.camera);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            Text('Camera')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
