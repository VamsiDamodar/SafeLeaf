import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';

class PinDotsIndicator extends StatefulWidget {
  final int length;
  final int filledDots;
  final bool hasError;
  final int shakeKey;
  final double size;
  final double spacing;
  final Color filledColor;
  final Color emptyBorderColor;
  final Color errorColor;

  const PinDotsIndicator({
    super.key,
    required this.length,
    required this.filledDots,
    this.hasError = false,
    this.shakeKey = 0,
    this.size = 14,
    this.spacing = 7,
    this.filledColor = AppColors.primary,
    this.emptyBorderColor = AppColors.primaryLight,
    this.errorColor = Colors.red,
  });

  @override
  State<PinDotsIndicator> createState() => _PinDotsIndicatorState();
}

class _PinDotsIndicatorState extends State<PinDotsIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late int _lastShakeKey;

  @override
  void initState() {
    super.initState();
    _lastShakeKey = widget.shakeKey;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(covariant PinDotsIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shakeKey != _lastShakeKey) {
      _lastShakeKey = widget.shakeKey;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final dx = widget.hasError
            ? math.sin(_animation.value * math.pi * 4) * 10
            : 0.0;

        return Transform.translate(
          offset: Offset(dx, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.length,
              (index) {
                final isFilled = index < widget.filledDots;

                final color = widget.hasError
                    ? widget.errorColor
                    : isFilled
                        ? widget.filledColor
                        : Colors.transparent;

                final borderColor = widget.hasError
                    ? widget.errorColor
                    : isFilled
                        ? widget.filledColor
                        : widget.emptyBorderColor;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOut,
                  margin:
                      EdgeInsets.symmetric(horizontal: widget.spacing),
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: 1.4,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}