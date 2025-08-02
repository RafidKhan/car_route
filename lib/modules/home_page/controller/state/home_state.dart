import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../model/road_info.dart';

class HomeState {
  final GeoPoint? startLocation;
  final GeoPoint? destinationLocation;
  final MapController? mapController;
  final RoadInfoModel? roadInfo;
  final bool showSearchButton;

  const HomeState({
    this.startLocation,
    this.destinationLocation,
    this.mapController,
    this.roadInfo,
    this.showSearchButton=false,
  });

  HomeState copyWith({
    GeoPoint? startLocation,
    GeoPoint? destinationLocation,
    MapController? mapController,
    RoadInfoModel? roadInfo,
    bool? showSearchButton,
  }) {
    return HomeState(
      startLocation: startLocation ?? this.startLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      mapController: mapController ?? this.mapController,
      roadInfo: roadInfo ?? this.roadInfo,
      showSearchButton: showSearchButton ?? this.showSearchButton,
    );
  }

  HomeState removeDestinationLocation() {
    return HomeState(
      startLocation: startLocation,
      destinationLocation: null,
      mapController: mapController,
      roadInfo: roadInfo,
      showSearchButton: showSearchButton,
    );
  }

  HomeState removeRoadInfo() {
    return HomeState(
      startLocation: startLocation,
      destinationLocation: destinationLocation,
      mapController: mapController,
      roadInfo: null,
      showSearchButton: showSearchButton,
    );
  }
}
