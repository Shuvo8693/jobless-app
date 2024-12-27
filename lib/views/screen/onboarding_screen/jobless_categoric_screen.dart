import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/category_controller.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/views/base/custom_button.dart';

import '../../../controllers/auth_controller/signup_controller.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_string.dart';
import '../../../utils/style.dart';
import '../../base/custom_gradientcolor.dart';

class JoblessCategoricScreen extends StatefulWidget {
  const JoblessCategoricScreen({super.key});

  @override
  State<JoblessCategoricScreen> createState() => _JoblessCategoricScreenState();
}

class _JoblessCategoricScreenState extends State<JoblessCategoricScreen> {
  final SignupController _categoriCtrl = Get.put(SignupController());
  CategoryController categoryController = Get.put(CategoryController());

  var curentIndex = 0;

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomGradientcolor(
          chiled: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.jobConfirmScreen);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 51.h),
                  child: Text(AppString.skipText,
                      style: AppStyles.customSize(
                          size: 20,
                          fontWeight: FontWeight.w500,
                          underline: TextDecoration.underline)),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            SizedBox(height: 32.h),
            Text(AppString.choceCategoriText,
                style: AppStyles.h1(
                    fontWeight: FontWeight.w500, family: "Schuyler")),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                AppString.moreCategoryText,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                child: Obx(() {
              if (categoryController.categoryAttributes.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return AlignedGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                itemCount: categoryController.categoryAttributes.length,
                crossAxisSpacing: 14,
                itemBuilder: (context, index) {
                  final categoryIndex = categoryController.categoryAttributes[index];

                  bool isSelect = _categoriCtrl.categoriList.contains(categoryIndex.status);
                  return InkWell(
                    onTap: () {
                      if (isSelect) {
                        _categoriCtrl.categoriList.remove(categoryIndex.status);
                        print("CategoliList>>>${_categoriCtrl.categoriList}");
                      } else {
                        _categoriCtrl.categoriList.add(categoryIndex.status!);
                        print("CategoliList>>>${_categoriCtrl.categoriList}");
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isSelect
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          border: Border.all(color: AppColors.primaryColor)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                            child: Text(
                          categoryIndex.status ?? '',
                          style: AppStyles.h6(
                            color:
                                isSelect ? Colors.white : AppColors.textColor,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                  );
                },
              );
            })),
            CustomButton(
                onTap: () {
                  if (_categoriCtrl.categoriList.isNotEmpty) {
                    Get.toNamed(AppRoutes.locationSelectorScreen, arguments: {
                      'categoryList': _categoriCtrl.categoriList,
                      'jobExperience' : true  // this true means jobless ,if its not set true then default will take false that's why false is job is active
                    });
                  }
                },
                padding: EdgeInsets.only(bottom: 20.h),
                text: AppString.submitText)
          ],
        ),
      )),
    );
  }
}
