import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobless/controllers/group_controller/create_group_controller.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/base/custom_text_field.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/style.dart';
import '../../../base/image_dialog.dart';

class CreateGroupScreen extends StatefulWidget {
   const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final CreateGroupController _createGroupCtrl=Get.put(CreateGroupController());

  TextEditingController nameCtrl=TextEditingController();

  TextEditingController descriptionCtrl=TextEditingController();

  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

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
        title: Text('Create Group',style: AppStyles.h2(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(

          child: Form(
            key: _formKey,
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
                   child:_createGroupCtrl.imagePath.isNotEmpty? Container(
                     height: 120.h,
                     width: 120.w,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12.r),
                       color: const Color(0xffF9F6F1),
                       border: Border.all(color:AppColors.primaryColor),
                       image: DecorationImage(image: FileImage(
                         File(_createGroupCtrl.imagePath.value),
                       ),fit: BoxFit.cover ),
                     ),

                   ):
                   Container(
                     height: 120.h,
                     width: 120.w,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12.r),
                       color: const Color(0xffC4D3F6),
                       border: Border.all(color:AppColors.primaryColor),
                     ),
                     child: Center(child: SvgPicture.asset(AppIcons.uploadIcon,height: 25.h,width: 22.w,)),
                   ),
                 ),

                 SizedBox(height: 10.h,),
                 Text('upload your group image',style:AppStyles.h5()),
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
                    controller:nameCtrl,
                  validator: (value){
                      if((value as String).isEmpty){
                        return '';
                      }else{
                        return null;
                      }
                  },
                ),

                /// Description
                SizedBox(height: 16.h,),
                Text(AppString.descriptionsText,style:AppStyles.h4(family: "Schuyler")),
                SizedBox(height: 10.h,),
                CustomTextField(
                    hintText: 'Here Type',
                    contentPaddingVertical: 15.h,
                    maxLine: 5,
                    controller:descriptionCtrl,
                  validator: (value){
                    if((value as String).isEmpty){
                      return '';
                    }else{
                      return null;
                    }
                  },
                ),

                /// Create Button

                SizedBox(height: 55.h,),
                Obx((){
                  return  CustomButton(
                      loading: _createGroupCtrl.isLoading.value,
                      onTap: ()async{
                        if(_formKey.currentState!.validate()){
                          await _createGroupCtrl.createGroup(nameCtrl.text, descriptionCtrl.text);
                        }
                      }, text: 'Create Group');
                }
                )
              ],
            ),
          ),
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
                         _createGroupCtrl.pickImageFromCamera(ImageSource.gallery);
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
                   ),
                   Expanded(
                     child: InkWell(
                       onTap: () {
                         _createGroupCtrl.pickImageFromCamera(ImageSource.camera);
                       },
                       child: SizedBox(
                         child: Column(
                           children: [
                             Icon(
                               Icons.camera_alt,
                               size: 50.w,
                               color: AppColors.primaryColor,
                             ),
                             const Text('Camera')
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
