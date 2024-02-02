import 'dart:math';

import 'package:flutter/material.dart';

class WaterAnimationWidget extends StatefulWidget {
  final double waterPercent;

  const WaterAnimationWidget({
    super.key,
    required this.waterPercent,
  });

  @override
  State<WaterAnimationWidget> createState() => _WaterAnimationWidgetState();
}

class _WaterAnimationWidgetState extends State<WaterAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, child) {
        return Center(
          child: SizedBox(
            width: 200,
            child: SizedBox(
              height: 300,
              child: ClipRRect(
                child: CustomPaint(
                  foregroundPainter: CustomBorderPainter(),
                  child: CustomPaint(
                    painter: WaterPainter(
                      animationValue: _animationController.value,
                      waterPercent: widget.waterPercent,
                    ),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class WaterPainter extends CustomPainter {
  final double animationValue;
  final double waterPercent;

  WaterPainter({
    required this.animationValue,
    this.waterPercent = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment(0.01, 1.00),
        end: Alignment(-0.01, -1),
        colors: [
          Color(0xFF021128),
          Color(0xFF003058),
        ],
      ).createShader(
        rect,
      );

    final waveHeight = size.height * 0.05;
    final waveWidth = size.width;
    final wavePath = Path();
    wavePath.moveTo(0, size.height);
    wavePath.lineTo(0, size.height - waveHeight);

    for (double interation = 0; interation <= waveWidth; interation += 5) {
      final waveWidthByInteration = interation / waveWidth;
      const fullCircleInRadians = 2 * pi;
      final frequence = animationValue * 2 * fullCircleInRadians;
      final waveHeightHalf = waveHeight / 2;
      final currentAngle = waveWidthByInteration * fullCircleInRadians;

      final double x = interation;
      final double y =
          sin(currentAngle + frequence) * waveHeightHalf + size.height;
      wavePath.lineTo(
        x,
        y - size.height * waterPercent,
      );
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.close();
    canvas.drawPath(wavePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
