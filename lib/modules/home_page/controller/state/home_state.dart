import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class HomeState {
  final GeoPoint? startLocation;
  final GeoPoint? destinationLocation;
  final bool isButtonEnabled;
  final MapController? mapController;

  const HomeState({
    this.startLocation,
    this.destinationLocation,
    this.isButtonEnabled = false,
    this.mapController,
  });

  HomeState copyWith({
    GeoPoint? startLocation,
    GeoPoint? destinationLocation,
    bool? isButtonEnabled,
    MapController? mapController,
  }) {
    return HomeState(
      startLocation: startLocation ?? this.startLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      mapController: mapController ?? this.mapController,
    );
  }

  HomeState removeDestinationLocation() {
    return HomeState(
      startLocation: startLocation,
      destinationLocation: null,
      isButtonEnabled: isButtonEnabled,
      mapController: mapController,
    );
  }
}
