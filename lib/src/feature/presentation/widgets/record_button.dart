// views/widgets/record_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final double size;

  const RecordButton({
    super.key,
    required this.isRecording,
    required this.onTap,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.shade400,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: isRecording ? size * 0.4 : size * 0.8,
            height: isRecording ? size * 0.4 : size * 0.8,
            decoration: BoxDecoration(
              color: isRecording ? Colors.white : Colors.red.shade400,
              shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isRecording ? BorderRadius.circular(6) : null,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
          ),
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).scaleXY(
        begin: 1.0,
        end: 1.1,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}