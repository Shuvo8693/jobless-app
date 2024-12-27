import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors{
  
  static Color primaryColor=const Color(0xFF4361EE);
  static Color backgroundColor=const Color(0xFF010101);
  static Color cardColor = const Color(0xFF2F2F2F);
  static Color cardLightColor = const Color(0xFF555555);
  static Color borderColor = const Color(0xFF2683EB);
  static Color textColor = const Color(0xFF111111);
  static Color subTextColor = const Color(0xFF565656);
  static Color dark2Color = const Color(0xff565656);
  static Color hintColor = const Color(0xFFB5B5B5);
  static Color secendryColor = const Color(0xFFC4D3F6);
  static Color greyColor = const Color(0xFFB5B5B5);
  static Color fillColor = const Color(0xFF5181F8).withOpacity(0.08);
  static Color dividerColor = const Color(0xFF555555);
  static Color shadowColor = const Color(0xFF2B2A2A);
  static Color bottomBarColor = const Color(0xFF343434);

  static BoxShadow shadow=BoxShadow(
    blurRadius: 4,
    spreadRadius: 0,
    color: shadowColor,
    offset: const Offset(0, 2),
  );
}