import 'package:car_route/modules/home_page/controller/state/home_state.dart';
import 'package:car_route/utils/extenstion.dart';
import 'package:flutter/cupertino.dart';
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
  HomeController() : super(const HomeState()) {
    startLocationController.addListener(checkButtonState);
    destinationLocationController.addListener(checkButtonState);
  }

  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController destinationLocationController =
      TextEditingController();

  final Location location = Location();

  Future<void> initMap() async {
    await checkPermission(onSuccess: () async {
      final currentLocation = await location.getLocation();

      setMapController(currentLocation);
    });
  }

  void checkButtonState() {
    state = state.copyWith(
      isButtonEnabled: startLocationController.text.trim().isNotEmpty &&
          destinationLocationController.text.trim().isNotEmpty,
    );
  }

  Future<void> getLocationFromAddress() async {
    final currentLocation =
        await startLocationController.text.trim().getLocationFromAddress();
    final destinationLocation = await destinationLocationController.text
        .trim()
        .getLocationFromAddress();
    currentLocation?.printLog();
    destinationLocation?.printLog();
    state = state.copyWith(
      startLocation: currentLocation,
      destinationLocation: destinationLocation,
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
}
