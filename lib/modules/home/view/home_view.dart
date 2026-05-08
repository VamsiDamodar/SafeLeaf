import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/home/viewmodel/home_controller.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/home/home_header.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = _HomeLayoutMetrics.from(constraints);
            final minContentHeight =
                (constraints.maxHeight - metrics.verticalPadding)
                    .clamp(0.0, double.infinity)
                    .toDouble();

            return SingleChildScrollView(
              padding: metrics.pagePadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minContentHeight),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: metrics.maxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(isCompact: metrics.isCompactHeight),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeLayoutMetrics {
  final bool isCompactHeight;
  final double maxContentWidth;
  final EdgeInsets pagePadding;

  const _HomeLayoutMetrics({
    required this.isCompactHeight,
    required this.maxContentWidth,
    required this.pagePadding,
  });

  double get verticalPadding => pagePadding.vertical;

  factory _HomeLayoutMetrics.from(BoxConstraints constraints) {
    final isCompactHeight = constraints.maxHeight < 700;
    final isTabletWidth = constraints.maxWidth >= 600;
    final horizontalPadding = (constraints.maxWidth * 0.06)
        .clamp(isTabletWidth ? 32.0 : 20.0, isTabletWidth ? 48.0 : 28.0)
        .toDouble();
    final verticalPadding = isCompactHeight ? 18.0 : 24.0;

    return _HomeLayoutMetrics(
      isCompactHeight: isCompactHeight,
      maxContentWidth: isTabletWidth ? 520 : 430,
      pagePadding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding + 12,
      ),
    );
  }
}
