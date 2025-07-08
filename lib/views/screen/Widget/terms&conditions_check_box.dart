import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditionsCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTermsConditionsTap;

  const TermsConditionsCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.onTermsConditionsTap,
  });

  @override
  State<TermsConditionsCheckbox> createState() => _TermsConditionsCheckboxState();
}

class _TermsConditionsCheckboxState extends State<TermsConditionsCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: widget.isChecked,
          onChanged: widget.onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'By creating an account, I accept the ',
              style:  TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
              ),
              children: [
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.sp,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onTermsConditionsTap,
                ),
                 TextSpan(
                  text: '.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
