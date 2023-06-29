import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const WaterAnimationApp());

class WaterAnimationApp extends StatelessWidget {
  const WaterAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WaterAnimationScreen(),
    );
  }
}

class WaterAnimationScreen extends StatefulWidget {
  const WaterAnimationScreen({super.key});

  @override
  State<WaterAnimationScreen> createState() => _WaterAnimationScreenState();
}

class _WaterAnimationScreenState extends State<WaterAnimationScreen> {
  double bottom = 0;

  double currentWaterPercent = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
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
      ),
    );
  }
}

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

class LineProgressWidget extends StatefulWidget {
  final Function(double percent) onChanged;
  const LineProgressWidget({super.key, required this.onChanged});

  @override
  State<LineProgressWidget> createState() => _LineProgressWidgetState();
}

class _LineProgressWidgetState extends State<LineProgressWidget> {
  double currentPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        setState(() {
          currentPosition = (300 - details.localPosition.dy).abs();
        });

        widget.onChanged(currentPosition / 300);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          height: 300,
          width: 20,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),
              width: 20,
              height: currentPosition,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
