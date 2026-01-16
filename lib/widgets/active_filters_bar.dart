import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/app_theme.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';

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

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        Map<String, dynamic> locale =
            state.localizedStrings['activeFilters'] ?? {};

        final chips = filters.entries
            .map((entry) {
              final label = _labelFor(locale, entry.key, entry.value);
              if (label == null) return null;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(label),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => onRemove(entry.key),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.15,
                  ),
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
      },
    );
  }

  String? _labelFor(Map<String, dynamic> locale, String key, dynamic value) {
    switch (key) {
      case 'city_name':
        return '${locale['city'] ?? 'City'}: $value';

      case 'bedrooms':
        return '${locale['beds'] ?? 'Beds'}: $value';

      case 'bathrooms':
        return '${locale['baths'] ?? 'Baths'}: $value';

      case 'price_min':
        return filters.containsKey('price_max')
            ? '${locale['price'] ?? 'Price'}: \$${filters['price_min']} - \$${filters['price_max']}'
            : '${locale['price'] ?? 'Price'} ≥ \$${filters['price_min']}';

      case 'size_min':
        return filters.containsKey('size_max')
            ? '${locale['size'] ?? 'Area'}: ${filters['size_min']} - ${filters['size_max']} m²'
            : '${locale['size'] ?? 'Area'} ≥ ${filters['size_min']} m²';

      case 'rating_min':
        return filters.containsKey('rating_max')
            ? '${locale['rating'] ?? 'Rating'}: ${filters['rating_min']} - ${filters['rating_max']}'
            : '${locale['rating'] ?? 'Rating'} ≥ ${filters['rating_min']}';

      case 'has_pool':
        return locale['pool'];

      case 'has_wifi':
        return locale['wifi'];

      case 'search':
        return 'Search: "$value"';

      default:
        return null;
    }
  }
}
