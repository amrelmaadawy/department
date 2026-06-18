import 'package:flutter/material.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/utils/responsive_builder.dart';
import '../../../domain/entities/ai_gallery_entity.dart';
import 'ai_gallery_item_card.dart';
import 'ai_gallery_details_sheet.dart';

class AiGalleryGrid extends StatelessWidget {
  final List<AiGalleryEntity> gallery;

  const AiGalleryGrid({
    super.key,
    required this.gallery,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsiveCrossAxisCount,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.8,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        final item = gallery[index];
        final heroTag = 'ai_image_${item.url}_${item.hashCode}';
        
        return AiGalleryItemCard(
          item: item,
          heroTag: heroTag,
          onTap: () {
            AiGalleryDetailsSheet.show(context, item, heroTag);
          },
        );
      },
    );
  }
}
