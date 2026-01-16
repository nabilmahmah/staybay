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
        return InkWell(
          onTap: () {
            if (widget.edit) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      // AddApartmentScreen(apartmentToEdit: widget.apartment),
                      EditApartmentScreen(apartment: widget.apartment),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ApartmentDetailsScreen(apartment: widget.apartment),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          child: Card(
            color: theme.cardColor,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusSmall,
                    ),
                    child: Image.network(
                      widget.apartment.imagePath,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.apartment.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSizes.paddingSmall / 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSizes.paddingSmall / 2),
                            Text(
                              '${widget.apartment.governorate?.localized(context)},${widget.apartment.city?.localized(context)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingSmall),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: AppSizes.paddingSmall / 2),
                            Text(
                              '${widget.apartment.rating} (${widget.apartment.ratingCount})',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingSmall),

                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '\$${widget.apartment.pricePerNight.toStringAsFixed(0)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                  fontSize: 20,
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
                  Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(left: AppSizes.paddingSmall),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.white,
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
