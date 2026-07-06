import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:safeleaf/modules/documents/document_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/common/safeleaf_app_bar.dart';
import 'package:safeleaf/widgets/documents/document_card.dart';
import 'package:safeleaf/widgets/documents/document_header.dart';
import 'package:safeleaf/widgets/documents/document_secure_banner.dart';

class DocumentView extends GetView<DocumentController> {
  final CategoryModel category;

  const DocumentView({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SafeLeafAppBar(),
      body: SafeArea(
        top: false,
        child: FutureBuilder<void>(
          future: controller.loadDocuments(category.id),
          builder: (context, snapshot) {
            return Column(
              children: [
                DocumentHeader(category: category),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (controller.filteredDocuments.isEmpty) {
                      return Center(
                        child: Image.asset(
                          'assets/noducmentsyet.png',
                          height: 400,
                          width: 400,
                          fit: BoxFit.contain,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.filteredDocuments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final item = controller.filteredDocuments[index];
                        return DocumentCard(
                          document: item,
                          onTap: () async {
                            await controller.openDocument(item);
                            await controller.reloadDocuments(category);
                          },
                        );
                      },
                    );
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: DocumentSecureBanner(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
