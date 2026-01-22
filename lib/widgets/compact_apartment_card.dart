import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';
// import 'package:staybay/screens/add_apartment_screen.dart';
// import 'package:staybay/screens/add_apartment_screen.dart';
import 'package:staybay/screens/edit_apartment_screen.dart';
import 'package:staybay/services/add_favorite_service.dart';
import 'package:staybay/services/remove_favorite_service.dart';
import '../app_theme.dart';
import '../models/apartment_model.dart';
import '../screens/apartment_details_screen.dart';

class CompactApartmentCard extends StatefulWidget {
  final Apartment apartment;
  final bool edit;
  const CompactApartmentCard({
    super.key,
    required this.apartment,
    required this.edit,
  });

  @override
  State<CompactApartmentCard> createState() => _CompactApartmentCardState();
}

class _CompactApartmentCardState extends State<CompactApartmentCard> {
  late bool _isFavorite;

  @override
  initState() {
    _isFavorite = widget.apartment.isFavorite;
    super.initState();
  }

  @override
Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        Map<String, dynamic> locale =
            state.localizedStrings['CompactApartmentCard'];

        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            // Breakpoints
            final bool isSmall = width < 360;
            final bool isTablet = width >= 600;

            final double imageSize = isTablet
                ? 130
                : isSmall
                ? 80
                : 100;

            final double titleSize = isTablet ? 18 : 15;
            final double priceSize = isTablet ? 22 : 18;

            return InkWell(
              onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => widget.edit
                        ? EditApartmentScreen(apartment: widget.apartment)
                        : ApartmentDetailsScreen(apartment: widget.apartment),
                ),
                );
              },
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSizes.borderRadiusLarge,
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingSmall),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusSmall,
                        ),
                        child: Image.network(
                          widget.apartment.imagePath,
                          fit: BoxFit.cover,
                          height: imageSize,
                          width: imageSize,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: imageSize,
                                width: imageSize,
                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              ),
                        ),
                      ),

                      const SizedBox(width: AppSizes.paddingMedium),

                      /// CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.apartment.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: titleSize,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${widget.apartment.governorate?.localized(context)}, ${widget.apartment.city?.localized(context)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.apartment.rating} (${widget.apartment.ratingCount})',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '\$${widget.apartment.pricePerNight.toStringAsFixed(0)}',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: priceSize,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: locale['perNight'] ?? ' / night',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// FAVORITE
                      IconButton(
                      icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite
                              ? Colors.red
                              : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                            widget.apartment.isFavorite = _isFavorite;

                          if (_isFavorite) {
                            AddFavoriteService.addFavorite(
                              context,
                                int.parse(widget.apartment.id!),
                            );
                          } else {
                              RemoveFavoriteService.removeFavorite(
                              context,
                                int.parse(widget.apartment.id!),
                            );
                          }
                        });
                      },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
}

}
