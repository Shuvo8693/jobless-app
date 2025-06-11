
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/subscription_controller/make_payment_controller.dart';
import 'package:jobless/controllers/subscription_controller/revenue_cat_controller.dart';
import 'package:jobless/controllers/subscription_controller/subscription_package_list_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/views/base/custom_button.dart';
import 'package:jobless/views/screen/Profile/payment/model/subscription_package_list_model.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/style.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
 // final SubscriptionPackageListController _packageListController=Get.put(SubscriptionPackageListController());
  final RevenueCatController _revenueCatController = Get.put(RevenueCatController());
  final PaymentController _paymentController= Get.put(PaymentController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _revenueCatController.fetchOfferings();
    });
    // _scrollController.addListener(() async {
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - 200 && !_packageListController.isFetchingMore.value) {
    //     await _packageListController.loadMorePackage();
    //   }
    // });
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
              final packageResult= _revenueCatController.packages;

             if(_revenueCatController.isLoading.value){
               return const Center(child: CircularProgressIndicator());
             }
             else if( packageResult.isEmpty){
               return const Center(child: Text('No package available'));
             }

              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: packageResult.length ,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
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
                              Text(packageIndex.storeProduct.title,style: AppStyles.h2(family: "Schuyler",)),
                              Divider(color: AppColors.dark2Color.withOpacity(0.2),),
                              ///=============>
                              Row(
                                children: [
                                  Icon(Icons.join_right),
                                  SizedBox(width: 8.w),
                                  SizedBox(
                                    width: 260.w,
                                      child: Text('${packageIndex.storeProduct.productCategory}',overflow: TextOverflow.clip,style: AppStyles.h4(family: "Schuyler",))),
                              ],),
                              ///=============>
                              SizedBox(height: 15.h,),
                              Row(
                                children: [
                                  Text('\$${packageIndex.storeProduct.price}',style: AppStyles.h1(
                                    family: "Schuyler",
                                  )),
                                  // Text('/ Monthly',style: AppStyles.h5(
                                  //   family: "Schuyler",
                                  // )),
                                ],
                              ),
                              /// Make payment Button
                              SizedBox(height: 15.h,),
                              CustomButton(
                                onTap: ()async{
                                 // await _paymentController.makePayment(packageIndex.price.toString(), 'USD', packageIndex.id);
                                  await _revenueCatController.purchasePackage(packageIndex);
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
