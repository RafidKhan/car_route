import 'package:car_route/modules/home_page/controller/state/home_state.dart';
import 'package:car_route/utils/extenstion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeController =
    StateNotifierProvider.autoDispose<HomeController, HomeState>(
  (ref) => HomeController(),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState()) {
    startLocationController.addListener(checkButtonState);
    destinationLocationController.addListener(checkButtonState);
  }

  final TextEditingController startLocationController =
      TextEditingController();
  final TextEditingController destinationLocationController =
      TextEditingController();

  void checkButtonState() {
    state = state.copyWith(
      isButtonEnabled: startLocationController.text.trim().isNotEmpty &&
          destinationLocationController.text.trim().isNotEmpty,
    );
  }

  Future<void> getLocationFromAddress() async{
    final currentLocation = await startLocationController.text.trim().getLocationFromAddress();
    final destinationLocation = await destinationLocationController.text.trim().getLocationFromAddress();
    currentLocation?.printLog();
    destinationLocation?.printLog();
  }
}
