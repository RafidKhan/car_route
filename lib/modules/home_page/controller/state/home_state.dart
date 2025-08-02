import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../model/road_info.dart';

class HomeState {
  final GeoPoint? startLocation;
  final GeoPoint? destinationLocation;
  final MapController? mapController;
  final RoadInfoModel? roadInfo;

  const HomeState({
    this.startLocation,
    this.destinationLocation,
    this.mapController,
    this.roadInfo,
  });

  HomeState copyWith({
    GeoPoint? startLocation,
    GeoPoint? destinationLocation,
    MapController? mapController,
    RoadInfoModel? roadInfo,
  }) {
    return HomeState(
      startLocation: startLocation ?? this.startLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      mapController: mapController ?? this.mapController,
      roadInfo: roadInfo ?? this.roadInfo,
    );
  }

  HomeState removeDestinationLocation() {
    return HomeState(
      startLocation: startLocation,
      destinationLocation: null,
      mapController: mapController,
      roadInfo: roadInfo,
    );
  }

  HomeState removeRoadInfo() {
    return HomeState(
      startLocation: startLocation,
      destinationLocation: destinationLocation,
      mapController: mapController,
      roadInfo: null,
    );
  }
}
