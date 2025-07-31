import 'package:car_route/modules/home_page/controller/state/home_state.dart';
import 'package:car_route/utils/extenstion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

final homeController =
    StateNotifierProvider.autoDispose<HomeController, HomeState>(
  (ref) => HomeController(),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState());

  final Location location = Location();

  Future<void> initMap() async {
    await checkPermission(onSuccess: () async {
      final currentLocation = await location.getLocation();

      setMapController(currentLocation);
    });
  }

  // Future<void> getLocationFromAddress() async {
  //   final currentLocation =
  //       await startLocationController.text.trim().getLocationFromAddress();
  //   final destinationLocation = await destinationLocationController.text
  //       .trim()
  //       .getLocationFromAddress();
  //   currentLocation?.printLog();
  //   destinationLocation?.printLog();
  //   state = state.copyWith(
  //     startLocation: currentLocation,
  //     destinationLocation: destinationLocation,
  //   );
  // }

  setMapController(LocationData location) {
    final mapController = MapController(
      initPosition: GeoPoint(
        latitude: location.latitude ?? 0,
        longitude: location.longitude ?? 0,
      ),
    );
    state = state.copyWith(mapController: mapController);

    state.mapController?.listenerMapSingleTapping.addListener(() async {
      final tappedPoint = state.mapController?.listenerMapSingleTapping.value;
      if (tappedPoint != null) {
        setMapPoint(tappedPoint);
      }
    });
  }

  Future<void> checkPermission({required VoidCallback onSuccess}) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    var permissionStatus = await permission_handler.Permission.location.status;
    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      permissionStatus = await permission_handler.Permission.location.request();
      if (!permissionStatus.isGranted) return;
    }

    onSuccess.call();
  }

  void setMapPoint(GeoPoint point) async {
    if (state.startLocation == null) {
      state = state.copyWith(startLocation: point);
      await state.mapController?.addMarker(
        point,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.green, size: 48),
        ),
      );
    } else if (state.destinationLocation == null) {
      state = state.copyWith(destinationLocation: point);
      await state.mapController?.addMarker(
        point,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.flag, color: Colors.red, size: 48),
        ),
      );

      // Draw the route
      await state.mapController?.drawRoad(
        state.startLocation!,
        state.destinationLocation!,
        roadType: RoadType.car,
        roadOption: const RoadOption(
          roadColor: Colors.blue,
        ),
      );
    } else {
      // Clear map and reset state
      await state.mapController?.removeLastRoad();

      // Set new start point
      state = state.copyWith(startLocation: point);

      // Remove the previous destination location
      state = state.removeDestinationLocation();

      await state.mapController?.addMarker(
        point,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.green, size: 48),
        ),
      );
    }
  }
}
