import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomCircularProgress extends StatefulWidget {
  final double progress; // Value between 0.0 and 1.0
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color color; // ✅ NEW: for progress color
  final Color backgroundColor;
  final Color shadowColor;
  final Widget? child;
  final bool animate;
  final Duration animationDuration;

  const CustomCircularProgress({
    super.key,
    required this.progress,
    this.size = 80,
    required this.color,          // ✅ Added to constructor
    this.strokeWidth = 6,
    this.progressColor = const Color(0xFF00D4AA),
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.shadowColor = const Color(0xFF00D4AA),
    this.child,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<CustomCircularProgress> createState() => _CustomCircularProgressState();
}

class _CustomCircularProgressState extends State<CustomCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shadow/Glow effect
          Container(
            width: widget.size + 8,
            height: widget.size + 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Circular Progress
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CircularProgressPainter(
                  progress: widget.animate ? _animation.value : widget.progress,
                  strokeWidth: widget.strokeWidth,
                  progressColor: widget.progressColor,
                  backgroundColor: widget.backgroundColor,
                ),
              );
            },
          ),
          // Center content
          if (widget.child != null)
            Container(
              width: widget.size - (widget.strokeWidth * 4),
              height: widget.size - (widget.strokeWidth * 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.backgroundColor.withOpacity(0.1),
              ),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          progressColor,
          progressColor.withOpacity(0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Optional: Add a glowing effect at the progress end
    if (progress > 0) {
      final endAngle = startAngle + sweepAngle;
      final endPoint = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );

      final glowPaint = Paint()
        ..color = progressColor.withOpacity(0.8)
        ..strokeWidth = strokeWidth + 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(endPoint, strokeWidth / 3, glowPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}