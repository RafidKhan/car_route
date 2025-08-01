import 'package:car_route/modules/home_page/controller/state/home_state.dart';
import 'package:car_route/utils/extenstion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:permission_handler/permission_handler.dart';

final homeController =
    StateNotifierProvider.autoDispose<HomeController, HomeState>(
  (ref) => HomeController(),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState());

  final TextEditingController searchLocation = TextEditingController();

  final Location location = Location();

  Future<void> initMap() async {
    await checkPermission(onSuccess: () async {
      final currentLocation = await location.getLocation();

      setMapController(currentLocation);
    });
  }

  Future<void> getLocationFromAddress() async {
    final currentLocation =
        await searchLocation.text.trim().getLocationFromAddress();
    currentLocation?.printLog();
    await state.mapController?.moveTo(
      GeoPoint(
          latitude: currentLocation?.latitude ?? 0,
          longitude: currentLocation?.longitude ?? 0),
      animate: true,
    );
  }

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
    // if start location is not set, set it, then check if destination is set
    // if destination is not set, set it and draw the road
    // if both are set, clear the map and reset the start location
    if (state.startLocation == null) {
      // Set the start location
      await setStartLocation(point);
    } else if (state.destinationLocation == null) {
      // Set the destination location
      await setDestinationLocation(point);
      // Draw the route
      await drawRoad();
      // Get road information
      await getRoadInformation();
    } else {
      // Clear map and reset state
      await state.mapController?.removeLastRoad();
      if (state.startLocation != null) {
        // Remove the previous start location marker
        await state.mapController?.removeMarker(state.startLocation!);
      }
      if (state.destinationLocation != null) {
        // Remove the previous destination location marker
        await state.mapController?.removeMarker(state.destinationLocation!);
      }
      // Remove the previous destination location
      state = state.removeDestinationLocation();

      // Set the new start location
      await setStartLocation(point);
    }
  }

  Future<void> setStartLocation(GeoPoint point) async {
    state = state.copyWith(startLocation: point);
    await state.mapController?.addMarker(
      point,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_pin, color: Colors.green, size: 48),
      ),
    );
  }

  Future<void> setDestinationLocation(GeoPoint point) async {
    state = state.copyWith(destinationLocation: point);
    await state.mapController?.addMarker(
      point,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.flag, color: Colors.red, size: 48),
      ),
    );
  }

  Future<void> drawRoad() async {
    await state.mapController?.drawRoad(
      state.startLocation!,
      state.destinationLocation!,
      roadType: RoadType.car,
      roadOption: const RoadOption(
        roadColor: Colors.blue,
      ),
    );
  }

  Future<void> getRoadInformation() async {
    if (state.startLocation == null ||
        state.destinationLocation == null ||
        state.mapController == null) {
      return;
    }

    final RoadInfo roadInfo = await state.mapController!.drawRoad(
      state.startLocation!,
      state.destinationLocation!,
      roadType: RoadType.car,
      roadOption: const RoadOption(
        roadColor: Colors.orangeAccent,
        roadBorderWidth: 10,
        roadBorderColor: Colors.deepOrange,
        roadWidth: 20,
      ),
    );

    final double distanceInMiles = (roadInfo.distance ?? 0) * 1000;
    final distance = "${distanceInMiles.toStringAsFixed(2)} Meters";

    final durationInSeconds = roadInfo.duration ?? 0;
    final durationInMinutes =
        double.parse((durationInSeconds / 60).toStringAsFixed(2));

    final time = durationInSeconds <= 60
        ? "$durationInSeconds Sec"
        : "$durationInMinutes Min";
    'result: $distance, $time'.printLog();
  }
}
