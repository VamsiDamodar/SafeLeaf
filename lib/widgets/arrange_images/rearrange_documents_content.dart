import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safeleaf/widgets/arrange_images/image_reorder_grid.dart';
import 'package:safeleaf/widgets/arrange_images/rearrange_action_buttons.dart';
import 'package:safeleaf/widgets/arrange_images/rearrange_info_banner.dart';

class RearrangeDocumentsContent extends StatelessWidget {
  final List<File> files;
  final int imageCount;
  final String Function(int index) getFileName;
  final String Function(int index) getReadableSize;
  final void Function(int oldIndex, int newIndex) onMoveImage;
  final VoidCallback onAddMoreTap;
  final VoidCallback onNextTap;

  const RearrangeDocumentsContent({
    super.key,
    required this.files,
    required this.imageCount,
    required this.getFileName,
    required this.getReadableSize,
    required this.onMoveImage,
    required this.onAddMoreTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final horizontalPadding =
            (screenWidth * 0.05).clamp(16.0, 24.0).toDouble();
        final gap = (screenWidth * 0.035).clamp(12.0, 18.0).toDouble();
        final buttonHeight =
            (screenHeight * 0.065).clamp(50.0, 60.0).toDouble();

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RearrangeInfoBanner(
                      icon: Icons.security_rounded,
                      title: '$imageCount Images Selected',
                      subtitle: 'Tap and hold to reorder',
                    ),
                    SizedBox(height: gap * 1.5),
                    ImageReorderGrid(
                      files: files,
                      getFileName: getFileName,
                      getReadableSize: getReadableSize,
                      onMoveImage: onMoveImage,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  25,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const RearrangeInfoBanner(
                      icon: Icons.lightbulb_outline_rounded,
                      title: 'Tip',
                      subtitle: 'Drag and drop to change the order of documents.',
                    ),
                    SizedBox(height: gap),
                    RearrangeActionButtons(
                      gap: gap,
                      buttonHeight: buttonHeight,
                      onAddMoreTap: onAddMoreTap,
                      onNextTap: onNextTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}