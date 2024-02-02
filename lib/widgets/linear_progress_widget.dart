
import 'package:flutter/material.dart';

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
