import 'package:geocoding/geocoding.dart';

class HomeState {
  final Location? currentLocation;
  final Location? destinationLocation;
  final bool isButtonEnabled;

  const HomeState({
    this.currentLocation,
    this.destinationLocation,
    this.isButtonEnabled = false,
  });

  HomeState copyWith({
    Location? currentLocation,
    Location? destinationLocation,
    bool? isButtonEnabled,
  }) {
    return HomeState(
      currentLocation: currentLocation ?? this.currentLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
