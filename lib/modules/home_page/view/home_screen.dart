import 'package:car_route/modules/global/widgets/global_text_form_field.dart';
import 'package:car_route/modules/home_page/view/components/current_location_input.dart';
import 'package:car_route/modules/home_page/view/components/destination_location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/widgets/global_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GlobalText(
          'Car Route',
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: const GlobalText(
              'Enter your current and destination locations',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const CurrentLocationInput(),
          const DestinationLocationInput(),
        ],
      ),
    );
  }
}
