import 'package:car_route/modules/home_page/view/home_screen.dart';
import 'package:car_route/utils/network_connection.dart';
import 'package:car_route/utils/view_util.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/global_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      //check internet connection for better ux
      final bool hasInternet =
          await NetworkConnection.instance.hasInternetConnection();
      if (hasInternet) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ViewUtil.showSnackBar(context, "No Internet Connection");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: GlobalText(
          "Car Route",
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
