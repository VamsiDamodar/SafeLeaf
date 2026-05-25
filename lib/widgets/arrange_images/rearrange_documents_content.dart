import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

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
        final horizontalPadding = (screenWidth * 0.05).clamp(16.0, 24.0).toDouble();
        final gap = (screenWidth * 0.035).clamp(12.0, 18.0).toDouble();
        final buttonHeight = (screenHeight * 0.065).clamp(50.0, 60.0).toDouble();

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoBanner(
                icon: Icons.security_rounded,
                title: '$imageCount Images Selected',
                subtitle: 'Tap and hold to reorder',
              ),
              SizedBox(height: gap * 1.5),

              // Responsive grid. Same widget works on small and wide screens.
              _ImageReorderGrid(
                files: files,
                getFileName: getFileName,
                getReadableSize: getReadableSize,
                onMoveImage: onMoveImage,
              ),

              SizedBox(height: gap * 1.7),
              const _InfoBanner(
                icon: Icons.lightbulb_outline_rounded,
                title: 'Tip',
                subtitle: 'Drag and drop to change the order of documents.',
              ),
              SizedBox(height: gap * 1.8),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: buttonHeight,
                      child: OutlinedButton.icon(
                        onPressed: onAddMoreTap,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add More'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: AppTextStyles.drawerItem.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: SizedBox(
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: onNextTap,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: AppTextStyles.drawerItem.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Next'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImageReorderGrid extends StatelessWidget {
  final List<File> files;
  final String Function(int index) getFileName;
  final String Function(int index) getReadableSize;
  final void Function(int oldIndex, int newIndex) onMoveImage;

  const _ImageReorderGrid({
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

        // Mobile lo 2 columns, wider screens lo 3 columns.
        final crossAxisCount = width >= 680 ? 3 : 2;
        final spacing = width >= 680 ? 18.0 : 14.0;
        final itemWidth = (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        final itemHeight = itemWidth * 1.2; // Card height is 1.2 times its width.

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
                    child: _ImageCard(
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
                  child: _ImageCard(
                    file: files[index],
                    orderNumber: index + 1,
                    title: getFileName(index),
                    sizeText: getReadableSize(index),
                  ),
                ),
              ),
              child: DragTarget<int>(
                onWillAccept: (oldIndex) => oldIndex != null && oldIndex != index,
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
                    child: _ImageCard(
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

class _ImageCard extends StatelessWidget {
  final File file;
  final int orderNumber;
  final String title;
  final String sizeText;

  const _ImageCard({
    required this.file,
    required this.orderNumber,
    required this.title,
    required this.sizeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.07),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area ni card width batti responsive ga control chestham.
              LayoutBuilder(
                builder: (context, constraints) {
                  final imageHeight = (constraints.maxWidth * 0.78)
                      .clamp(60.0, 145.0)
                      .toDouble();
                  return Container(
                    width: double.infinity,
                    height: imageHeight,
                    padding: const EdgeInsets.all(6),
                    color: AppColors.cardBackground,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerItem.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,1, 10, 10),
                child: Text(
                  sizeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerItem.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Green order badge like the reference image.
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                '$orderNumber',
                style: AppTextStyles.drawerItem.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoBanner({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final iconSize = (width * 0.060).clamp(20.0, 38.0).toDouble();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.iconBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: iconSize,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerHeaderTitle.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerItem.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}