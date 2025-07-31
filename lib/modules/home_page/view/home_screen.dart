import 'package:car_route/modules/home_page/view/components/start_location_input.dart';
import 'package:car_route/modules/home_page/view/components/destination_location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/widgets/global_text.dart';
import '../controller/home_controller.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: const GlobalText(
              'Enter your start and destination locations',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const StartLocationInput(),
          const DestinationLocationInput(),
        ],
      ),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        final state = ref.watch(homeController);
        return FloatingActionButton(
          backgroundColor:
              state.isButtonEnabled ? Colors.lightBlue : Colors.grey,
          onPressed: state.isButtonEnabled ? () {} : null,
          child: const Icon(
            Icons.start,
            color: Colors.white,
          ),
        );
      }),
    );
  }
}
