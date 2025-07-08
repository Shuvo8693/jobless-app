import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/utils/app_icons.dart';
import 'package:jobless/utils/style.dart';

class PostInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? profileImageUrl;
  final VoidCallback? onMenuTap;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const PostInputField({
    Key? key,
    required this.controller,
    this.profileImageUrl,
    this.onMenuTap,
    this.onChanged,
    this.hintText = "What's happening ?",
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onTap,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.sentences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        controller: controller,
        validator: validator,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        autofocus: autofocus,
        textCapitalization: textCapitalization,
        cursorColor: AppColors.subTextColor,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.zero,
          hintStyle: AppStyles.h6(color: AppColors.subTextColor),
          fillColor: Colors.transparent,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          prefixIcon: _buildPrefixIcon(),
          suffixIcon: _buildSuffixIcon(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (profileImageUrl == null) return null;

    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: CircleAvatar(
        backgroundImage: NetworkImage(profileImageUrl!),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (onMenuTap == null) return null;

    return InkWell(
      onTap: onMenuTap,
      child: CircleAvatar(
        radius: 15.r,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(
          AppIcons.threeDotIcon,
          height: 20.h,
          color: const Color(0xffC4D3F6),
        ),
      ),
    );
  }
}