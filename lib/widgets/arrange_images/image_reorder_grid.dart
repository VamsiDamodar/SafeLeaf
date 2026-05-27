import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/arrange_images/rearrange_image_card.dart';

class ImageReorderGrid extends StatelessWidget {
  final List<File> files;
  final String Function(int index) getFileName;
  final String Function(int index) getReadableSize;
  final void Function(int oldIndex, int newIndex) onMoveImage;

  const ImageReorderGrid({
    super.key,
    required this.files,
    required this.getFileName,
    required this.getReadableSize,
    required this.onMoveImage,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('No images selected')),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 680 ? 3 : 2;
        final spacing = width >= 680 ? 18.0 : 14.0;
        final itemWidth =
            (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        final itemHeight = itemWidth * 1.2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(files.length, (index) {
            return LongPressDraggable<int>(
              data: index,
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: Opacity(
                    opacity: 0.85,
                    child: RearrangeImageCard(
                      file: files[index],
                      orderNumber: index + 1,
                      title: getFileName(index),
                      sizeText: getReadableSize(index),
                    ),
                  ),
                ),
              ),
              childWhenDragging: SizedBox(
                width: itemWidth,
                height: itemHeight,
                child: Opacity(
                  opacity: 0.35,
                  child: RearrangeImageCard(
                    file: files[index],
                    orderNumber: index + 1,
                    title: getFileName(index),
                    sizeText: getReadableSize(index),
                  ),
                ),
              ),
              child: DragTarget<int>(
                onWillAccept: (oldIndex) =>
                    oldIndex != null && oldIndex != index,
                onAccept: (oldIndex) => onMoveImage(oldIndex, index),
                builder: (context, candidateData, rejectedData) {
                  final isHovering = candidateData.isNotEmpty;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: itemWidth,
                    height: itemHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: isHovering
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: RearrangeImageCard(
                      file: files[index],
                      orderNumber: index + 1,
                      title: getFileName(index),
                      sizeText: getReadableSize(index),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }
}