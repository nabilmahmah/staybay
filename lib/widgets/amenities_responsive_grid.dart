import 'package:flutter/material.dart';
import '../app_theme.dart';

class AmenitiesResponsiveGrid extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesResponsiveGrid({super.key, required this.amenities});

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'pool':
        return Icons.pool;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (amenities.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: AppSizes.paddingMedium,
      runSpacing: AppSizes.paddingMedium,
      children: amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getAmenityIcon(amenity),
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: AppSizes.paddingSmall / 2),
              Text(
                amenity,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
