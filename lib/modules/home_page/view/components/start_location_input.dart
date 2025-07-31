import 'package:car_route/main.dart';
import 'package:car_route/modules/global/widgets/global_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/home_controller.dart';

class StartLocationInput extends ConsumerWidget {
  const StartLocationInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(homeController.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 5.h,
      ),
      child: GlobalTextFormField(
        textEditingController: controller.startLocationController,
        hintText: 'Enter your start location',
      ),
    );
  }
}
