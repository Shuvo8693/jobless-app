import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/utils/app_image.dart';
import 'package:jobless/views/base/custom_gradientcolor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),(){
      Get.toNamed(AppRoutes.onboardingScreen);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   return  Scaffold(
     body:CustomGradientcolor(
       chiled: Center(
         child: SvgPicture.asset(AppImage.appIcon,height:134,width: 134,),
       ),
     ),
   );

  }
}
