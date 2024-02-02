import 'package:flutter/material.dart';
import 'package:water_level/pages/water_animation_page.dart';

void main() => runApp(const WaterAnimationApp());

class WaterAnimationApp extends StatelessWidget {
  const WaterAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const WaterAnimationScreen(),
    );
  }
}
