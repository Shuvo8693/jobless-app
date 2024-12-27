import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/notification_controller/notification_controller.dart';
import 'package:jobless/utils/app_string.dart';
import 'package:jobless/views/base/bottom_menu..dart';

import '../../../utils/app_colors.dart';
import '../../../utils/style.dart';
import 'inner_widget/notification_cart.dart';
import 'notification_model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _notificationController=Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _notificationController.fetchNotification();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: BottomMenu(1),
     appBar:  AppBar(
       centerTitle: true,
        title: Text(AppString.notificationText,style: AppStyles.customSize(
          size: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
          family: "Schuyler",
        )),
       backgroundColor: Colors.transparent,
      ),

      body:Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Obx((){
          List<NotificationResults> notificationResults =_notificationController.notificationModel.value.data?.attributes?.results??[];
          if(_notificationController.isLoading.value){
            return Center(child: CircularProgressIndicator());
          }
          if(notificationResults.isEmpty){
            return Center(child: Text('Notification not available'));
          }
          return  ListView.separated(
            itemCount: notificationResults.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context,index){
             final notificationIndex = notificationResults[index];
             if(notificationIndex.type=='friendRequest'){

               return  NotificationCart(notificationResults: notificationIndex, index: index,notificationController: _notificationController,);

             }else if(notificationIndex.type=='payment'){

               return  NotificationCart(notificationResults: notificationIndex, index: index);

             }else if(notificationIndex.type=='post'){

               return  NotificationCart(notificationResults: notificationIndex, index: index);

             }else{
               return SizedBox.shrink();
             }

            },
            separatorBuilder: (context,index){
              return Divider(
                color: AppColors.secendryColor,
              );
            },
          );
        }

        ),
      ),
    );
  }
}
