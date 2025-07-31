import 'package:car_route/modules/global/widgets/global_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DestinationLocationInput extends StatelessWidget {
  const DestinationLocationInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 5.h,
      ),
      child: GlobalTextFormField(
        textEditingController: TextEditingController(),
        hintText: 'Enter your destination location',
      ),
    );
  }
}
