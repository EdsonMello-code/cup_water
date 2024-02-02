import 'package:flutter/material.dart';

import '../widgets/cup_water_widget.dart';

class WaterAnimationScreen extends StatefulWidget {
  const WaterAnimationScreen({super.key});

  @override
  State<WaterAnimationScreen> createState() => _WaterAnimationScreenState();
}

class _WaterAnimationScreenState extends State<WaterAnimationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: CupWaterWidget(),
    );
  }
}
