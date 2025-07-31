import 'package:flutter/material.dart';

import '../../global/widgets/global_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GlobalText(
          'Car Route',
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
