import 'package:car_route/modules/global/widgets/global_text.dart';
import 'package:flutter/material.dart';

class ViewUtil {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: GlobalText(
        message,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
