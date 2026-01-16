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

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final locale = state.localizedStrings['activeFilters'] ?? {};
        final processedKeys = <String>{};

        final chips = filters.entries
            .map((entry) {
              final key = entry.key;
              if (processedKeys.contains(key)) return null;

              if (key.contains('_min') || key.contains('_max')) {
                final baseKey = key.split('_')[0];
                processedKeys.add('${baseKey}_min');
                processedKeys.add('${baseKey}_max');

                final label = _labelForRange(locale, baseKey, filters);
                return _buildChip(context, label, baseKey);
              }

              processedKeys.add(key);
              final label = _labelFor(locale, key, entry.value);
              if (label == null) return null;
              return _buildChip(context, label, key);
            })
            .whereType<Widget>()
            .toList();

        if (chips.isEmpty) return const SizedBox.shrink();

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(scrollDirection: Axis.horizontal, children: chips),
        );
      },
    );
  }

  Widget _buildChip(BuildContext context, String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        onDeleted: () => onRemove(key),
        deleteIcon: const Icon(Icons.close, size: 16),
      ),
    );
  }

  String _labelForRange(
    Map<String, dynamic> locale,
    String base,
    Map<String, dynamic> filters,
  ) {
    final min = filters['${base}_min'];
    final max = filters['${base}_max'];
    final name = locale[base] ?? base;

    if (min != null && max != null) return '$name: $min - $max';
    if (min != null) return '$name ≥ $min';
    return '$name ≤ $max';
  }

  String? _labelFor(Map<String, dynamic> locale, String key, dynamic value) {
    switch (key) {
      case 'city_name':
        return '${locale['city']}: $value';
      case 'bedrooms':
        return '${locale['beds']}: $value';
      case 'bathrooms':
        return '${locale['baths']}: $value';
      case 'has_pool':
        return locale['pool'];
      case 'has_wifi':
        return locale['wifi'];
      case 'search':
        return '"$value"';
      default:
        return null;
    }
  }
}
