import 'package:flutter/material.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:safeleaf/utils/app_colors.dart';

import 'package:safeleaf/widgets/home/category_more_menu.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool isTelugu;
  final VoidCallback onTap;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isTelugu,
    required this.onTap,
    this.onRename,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = isTelugu ? category.nameTelugu : category.name;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = cardWidth * 0.52;

        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: cardHeight,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(cardWidth * 0.07),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(cardWidth * 0.08),
                    border: Border.all(
                      color: AppColors.surfaceBorder,
                      width: 0.3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: cardHeight * 0.2),
                      Center(
                        child: Container(
                          height: cardWidth * 0.3,
                          width: cardWidth * 0.3,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(cardWidth * 0.06),
                          ),
                          child: Icon(
                            category.icon,
                            color: AppColors.primary,
                            size: cardWidth * 0.14,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: cardWidth * 0.1,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      SizedBox(height: cardWidth * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: cardWidth * 0.09,
                            color: AppColors.primary.withOpacity(0.6),
                          ),
                          SizedBox(width: cardWidth * 0.02),
                          Flexible(
                            child: Text(
                              '${category.documentCount} ${isTelugu ? "పత్రాలు" : "Docs"}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: cardWidth * 0.07,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary.withOpacity(0.65),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: cardHeight * 0.02),
                    ],
                  ),
                ),

                Positioned(
                  top: -4,
                  right: -7,
                  child: CategoryMoreMenu(
                    isTelugu: isTelugu,
                    isCustom: category.isCustom,
                    onRename: onRename,
                    onDelete: onDelete,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}