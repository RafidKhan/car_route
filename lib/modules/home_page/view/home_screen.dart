import 'package:car_route/utils/extenstion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global/widgets/global_text.dart';
import '../controller/home_controller.dart';

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
      controller.initMap();
    });
  }

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
      body: Consumer(builder: (context, ref, child) {
        final state = ref.watch(homeController);
        final controller = ref.watch(homeController.notifier);
        if (state.mapController == null) {
          return const SizedBox.shrink();
        }
        return OSMFlutter(
          controller: state.mapController!,
          osmOption: OSMOption(
            userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: true,
            ),
            zoomOption: const ZoomOption(
              initZoom: 40,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            roadConfiguration: const RoadOption(
              roadColor: Colors.lightBlue,
            ),
          ),
          // onGeoPointClicked: (GeoPoint point) {
          //   'point:: ${point}'.printLog();
          //   controller.setMapPoint(point);
          // },
        );
      }),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        final state = ref.watch(homeController);
        final controller = ref.read(homeController.notifier);
        return FloatingActionButton(
          backgroundColor:
              state.isButtonEnabled ? Colors.lightBlue : Colors.grey,
          onPressed: state.isButtonEnabled
              ? () {
                  //controller.getLocationFromAddress();
                }
              : null,
          child: const Icon(
            Icons.start,
            color: Colors.white,
          ),
        );
      }),
    );
  }
}
