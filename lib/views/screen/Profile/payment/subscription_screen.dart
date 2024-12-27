
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/subscription_controller/make_payment_controller.dart';
import 'package:jobless/controllers/subscription_controller/subscription_package_list_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/payment/model/subscription_package_list_model.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/style.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionPackageListController _packageListController=Get.put(SubscriptionPackageListController());
  final PaymentController _paymentController= Get.put(PaymentController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _packageListController.fetchSubscriptionPackageList();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 && !_packageListController.isFetchingMore.value) {
        await _packageListController.loadMorePackage();
      }
    });
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
        title: Text('Subscription',style: AppStyles.h2(
          family: "Schuyler",
        )),
        backgroundColor: Colors.transparent,

      ),

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx((){
             List<SubscriptionPackageResults> packageResult= _packageListController.subscriptionPackageModel.value.data?.attributes?.results??[];

             if(_packageListController.timeLineLoading.value){
               return const Center(child: CircularProgressIndicator());
             }
             else if( packageResult.isEmpty){
               return const Center(child: Text('No package available'));
             }

              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: packageResult.length + (_packageListController.isFetchingMore.value? 1:0),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if(index == packageResult.length ){
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    var packageIndex = packageResult[index];
                    return Padding(
                      padding:  EdgeInsets.only(bottom: 8.h),
                      child: Container(
                        //height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30).r,
                          color: AppColors.secendryColor,

                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(AppIcons.crownIcon,),
                              Text('${packageIndex.name}',style: AppStyles.h2(family: "Schuyler",)),
                              Divider(color: AppColors.dark2Color.withOpacity(0.2),),
                              ///=============>
                              Row(
                                children: [
                                  Icon(Icons.join_right),
                                  SizedBox(width: 8.w),
                                  SizedBox(
                                    width: 260.w,
                                      child: Text('${packageIndex.description}',overflow: TextOverflow.clip,style: AppStyles.h4(family: "Schuyler",))),
                              ],),
                              ///=============>
                              SizedBox(height: 15.h,),
                              Row(
                                children: [
                                  Text('\$${packageIndex.price}',style: AppStyles.h1(
                                    family: "Schuyler",
                                  )),
                                  Text('/ Monthly',style: AppStyles.h5(
                                    family: "Schuyler",
                                  )),
                                ],
                              ),
                              SizedBox(height: 15.h,),
                              CustomButton(
                                onTap: ()async{
                                  await _paymentController.makePayment(packageIndex.price.toString(), 'USD', packageIndex.id);
                                },
                                color: Colors.black,
                                text: 'Buy',
                              ) ,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
           }
            ),
            SizedBox(height: 30.h,),

          ],
        ),
      ),
    );
  }
}
