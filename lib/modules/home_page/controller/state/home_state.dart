import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class HomeState {
  final GeoPoint? startLocation;
  final GeoPoint? destinationLocation;
  final MapController? mapController;

  const HomeState({
    this.startLocation,
    this.destinationLocation,
    this.mapController,
  });

  HomeState copyWith({
    GeoPoint? startLocation,
    GeoPoint? destinationLocation,
    MapController? mapController,
  }) {
    return HomeState(
      startLocation: startLocation ?? this.startLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      mapController: mapController ?? this.mapController,
    );
  }

  HomeState removeDestinationLocation() {
    return HomeState(
      startLocation: startLocation,
      destinationLocation: null,
      mapController: mapController,
    );
  }
}
