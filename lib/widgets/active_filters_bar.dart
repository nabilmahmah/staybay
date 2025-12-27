import 'package:flutter/material.dart';
import 'package:staybay/app_theme.dart';

class ActiveFiltersBar extends StatelessWidget {
  final Map<String, dynamic> filters;
  final void Function(String key) onRemove;

  const ActiveFiltersBar({
    super.key,
    required this.filters,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final chips = filters.entries
        .map((entry) {
          final label = _labelFor(entry.key, entry.value);
          if (label == null) return null;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(label),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => onRemove(entry.key),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              labelStyle: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        })
        .whereType<Widget>()
        .toList();

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: chips),
      ),
    );
  }

  String? _labelFor(String key, dynamic value) {
    switch (key) {
      case 'city_name':
        return 'City: $value';

      case 'bedrooms':
        return 'Beds: $value';

      case 'bathrooms':
        return 'Baths: $value';

      case 'price_min':
        return filters.containsKey('price_max')
            ? 'Price: \$${filters['price_min']} - \$${filters['price_max']}'
            : 'Price ≥ \$${filters['price_min']}';

      case 'has_pool':
        return 'Pool';

      case 'has_wifi':
        return 'WiFi';

      case 'search':
        return 'Search: "$value"';

      default:
        return null;
    }
  }
}
