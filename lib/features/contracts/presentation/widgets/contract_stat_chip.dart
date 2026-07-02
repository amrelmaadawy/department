import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ContractStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContractStatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: context.colors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFonts.labelMedium,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

String formatContractDate(String raw) {
  try {
    final date = DateTime.parse(raw);
    return DateFormat('d MMM yyyy', 'ar').format(date);
  } catch (_) {
    return raw.split('T').first;
  }
}
