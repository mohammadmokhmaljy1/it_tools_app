import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/catalog_entities.dart';

class OfferDetailsHeader extends StatelessWidget {
  final OfferEntity offer;
  final bool isExpired;

  const OfferDetailsHeader({
    super.key,
    required this.offer,
    required this.isExpired,
  });

  String _statusLabel() {
    if (isExpired) return 'انتهى هذا العرض';

    final endsAt = offer.endsAt;
    if (endsAt != null) {
      final remaining = endsAt.difference(DateTime.now());
      return 'متبقي ${remaining.inHours} ساعة';
    }

    return 'عرض ساري حالياً';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(offer.title, style: AppTextStyles.headingH2),
          if (offer.type.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              offer.type,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isExpired ? AppColors.pageBg : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isExpired ? Icons.timer_off_outlined : Icons.timer_outlined,
                  size: 16,
                  color: isExpired ? AppColors.danger : AppColors.royal,
                ),
                const SizedBox(width: 8),
                Text(
                  _statusLabel(),
                  style: AppTextStyles.captionStrong.copyWith(
                    color: isExpired ? AppColors.danger : AppColors.royal,
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
