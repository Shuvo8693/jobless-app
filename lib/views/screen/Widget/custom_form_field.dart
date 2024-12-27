import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomForm extends StatelessWidget {
  final String title;
  final String? value;
  final String? icon;
  final int? maxLine;
  final TextEditingController controller;
  final bool isEditable;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;

  const CustomForm({
    required this.title,
     this.value,
     this.icon,
    required this.controller,
    this.isEditable = false,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.maxLine, // Set default to non-editable
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Schuyler",
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: controller,
          maxLines: maxLine??1 ,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: contentPaddingHorizontal ?? 20.w,
                vertical: contentPaddingVertical ?? 20.w),
            prefix: Padding(
              padding: const EdgeInsets.only(right: 10),
              child:icon==null? null:SvgPicture.asset(icon!),
            ),
            hintText: value,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        )
      ],
    );
  }
}

