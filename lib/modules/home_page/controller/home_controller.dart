import 'package:car_route/modules/home_page/controller/state/home_state.dart';
import 'package:car_route/modules/home_page/model/custom_lat_long.dart';
import 'package:car_route/modules/home_page/model/road_info.dart';
import 'package:car_route/utils/extenstion.dart';
import 'package:car_route/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:permission_handler/permission_handler.dart';
import '../view/components/locations_bottom_sheet.dart';
import 'package:geocoding/geocoding.dart' as geo;

final homeController =
    StateNotifierProvider.autoDispose<HomeController, HomeState>(
  (ref) => HomeController(),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState()) {
    searchLocation.addListener(checkSearchButtonStatus);
  }

  final TextEditingController searchLocation = TextEditingController();

  final Location location = Location();

  Future<void> initMap(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    await requestLocationPermission(
      onSuccess: () async {
        await setMapController(context);
      },
      onError: (error) {
        Navigator.pop(context);
        ViewUtil.showSnackBar(context, error);
      },
    );
  }

  Future<void> getLocationFromAddress(BuildContext context) async {
    final locations = await searchLocation.text
        .trim()
        .getLocationsFromAddress(); // custom extension go get list of location with Lat Long from input address
    if (locations.isNotEmpty) {
      searchLocation.clear();
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return LocationsBottomSheet(
            locations: locations,
            onSelectLocation: (loc) async {
              await setMapFocus(loc, true);
            },
            onSetMap: (loc) async {
              await setMapFocus(loc, false);
            },
          );
        },
      );
    } else {
      ViewUtil.showSnackBar(context, "Failed to get location from address");
    }
  }

  Future<void> setMapFocus(
    geo.Location locationData,
    bool setLocation,
  ) async {
    await state.mapController?.moveTo(
      GeoPoint(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      ),
      animate: true,
    );

    if (setLocation) {
      setMapPoint(
        GeoPoint(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        ),
      );
    }
  }

  Future<void> setMapController(BuildContext context) async {
    final currentLocation = await location.getLocation();
    final mapController = MapController(
      initPosition: GeoPoint(
        latitude: currentLocation.latitude ?? 0,
        longitude: currentLocation.longitude ?? 0,
      ),
    );
    state = state.copyWith(mapController: mapController);
    Navigator.pop(context);

    state.mapController?.listenerMapSingleTapping.addListener(() async {
      final tappedPoint = state.mapController?.listenerMapSingleTapping.value;
      if (tappedPoint != null) {
        setMapPoint(tappedPoint);
      }
    });
  }

  Future<void> requestLocationPermission({
    required Function() onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    try {
      var status = await Permission.location.status;

      if (status.isGranted) {
        // Permission already granted
        onSuccess();
        return;
      }

      if (status.isDenied || status.isRestricted || status.isLimited) {
        // Request permission
        status = await Permission.location.request();
        if (status.isGranted) {
          onSuccess();
          return;
        } else if (status.isPermanentlyDenied) {
          onError(
              "Location permission permanently denied. Please enable it from settings.");
          await openAppSettings();
          return;
        }
      }

      onError("Location permission denied.");
    } catch (e) {
      onError("Error requesting location permission");
    }
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
      // Draw the route and Get road information
      await drawRoadAndGetRoadInfo();
    } else {
      //clear road info
      clearRoadInfo();
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
        icon: Icon(Icons.navigation, color: Colors.green, size: 48),
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

  Future<void> drawRoadAndGetRoadInfo() async {
    if (state.startLocation == null ||
        state.destinationLocation == null ||
        state.mapController == null) {
      clearRoadInfo();
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

    final double distanceInKm = (roadInfo.distance ?? 0);
    final distance = formattedDistance(distanceInKm);
    debugPrint("time is: ${roadInfo.duration}");

    final durationInSeconds = (roadInfo.duration ?? 0).ceil();

    String time;
    if (durationInSeconds < 60) {
      time = "${durationInSeconds}s";
    } else if (durationInSeconds < 3600) {
      final minutes = (durationInSeconds / 60).ceil();
      time = "${minutes}m";
    } else {
      final hours = (durationInSeconds / 3600).ceil();
      time = "${hours}h";
    }

    state = state.copyWith(
      roadInfo: RoadInfoModel(
        time: time,
        distance: distance,
        startPointName: await CustomLatLong(
          lat: state.startLocation!.latitude,
          long: state.startLocation!.longitude,
        ).getAddressFromLatLng(),
        //custom extension to get location string from lat long
        endPointName: await CustomLatLong(
          lat: state.destinationLocation!.latitude,
          long: state.destinationLocation!.longitude,
        ).getAddressFromLatLng(),
        //custom extension to get location string from lat long
      ),
    );
  }

  void clearRoadInfo() {
    state = state.removeRoadInfo();
  }

  String formattedDistance(double distanceInKm) {
    if (distanceInKm >= 1) {
      return "${distanceInKm.toStringAsFixed(2)} km";
    } else {
      final distanceInMeters = distanceInKm * 1000;
      return "${distanceInMeters.toStringAsFixed(2)} meters";
    }
  }

  void checkSearchButtonStatus() {
    state =
        state.copyWith(showSearchButton: searchLocation.text.trim().isNotEmpty);
  }
}
