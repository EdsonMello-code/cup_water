import 'package:flutter/material.dart';
import 'package:water_level/widgets/linear_progress_widget.dart';
import 'package:water_level/widgets/water_animation_widget.dart';

class CupWaterWidget extends StatefulWidget {
  const CupWaterWidget({super.key});

  @override
  State<CupWaterWidget> createState() => _CupWaterWidgetState();
}

class _CupWaterWidgetState extends State<CupWaterWidget> {
  double currentWaterPercent = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WaterAnimationWidget(
          waterPercent: currentWaterPercent,
        ),
        LineProgressWidget(
          onChanged: (percent) {
            setState(() {
              currentWaterPercent = percent;
            });
          },
        ),
      ],
    );
  }
}
