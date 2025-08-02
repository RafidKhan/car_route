import 'package:car_route/modules/global/widgets/global_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/widgets/global_text.dart';
import '../controller/home_controller.dart';
import 'components/feature_intro_screen.dart';
import 'components/home_map_view.dart';
import 'components/location_road_info.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final controller = ref.read(homeController.notifier);
    Future(() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FeatureIntroSheet(),
      );
      controller.initMap(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(homeController.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const GlobalText(
          'Car Route',
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Stack(
        children: [
          const HomeMapView(),

          //text input to search location on map(map focuses on that location)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: GlobalTextFormField(
              textEditingController: controller.searchLocation,
              hintText: 'Search Location',
              onEditingComplete: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (controller.searchLocation.text.trim().isNotEmpty) {
                  await controller.getLocationFromAddress(context);
                }
              },
            ),
          ),

          //see location road info
          const LocationRoadInfo(),
        ],
      ),
    );
  }
}
