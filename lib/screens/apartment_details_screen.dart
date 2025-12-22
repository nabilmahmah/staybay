import 'package:flutter/material.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/services/apartment_service.dart';
import '../app_theme.dart';
import '../widgets/details_image_carousel.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/amenities_responsive_grid.dart';
import 'booking_details_screen.dart';
import '../widgets/rating_dialog.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  static const String routeName = '/details';

  final Apartment apartment;

  const ApartmentDetailsScreen({super.key, required this.apartment});

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.apartment.isFavorite;
  }

  Widget _buildFeatureIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(height: AppSizes.paddingSmall / 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  void _showRatingDialog(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => const RatingDialog(),
    );

    if (result != null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you! You gave a rating of $result stars.'),
        ),
      );
    }
  }

void _navigateToBooking(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BookingDetailsScreen(
        apartment: widget.apartment,
      ),
    ),
  );
}
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apartmentDetails = widget.apartment;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 350.0,
              pinned: true,
              floating: false,
              elevation: 0,
              backgroundColor: theme.colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      final index = ApartmentService.mockApartments.indexWhere(
                        (apt) => apt.id == apartmentDetails.id);
                      ApartmentService.mockApartments[index].isFavorite = !_isFavorite;
                      _isFavorite = !_isFavorite;
                    });
                  },
               ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: DetailsImageCarousel(
                  imagesPaths: apartmentDetails.imagesPaths,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                apartmentDetails.title,
                style: AppStyles.titleStyle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSizes.paddingSmall / 2),
                      Text(
                        apartmentDetails.location,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '\$${apartmentDetails.pricePerNight.toStringAsFixed(0)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary,
                            fontSize: 22,
                          ),
                        ),
                        TextSpan(
                          text: ' / night',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: AppSizes.paddingLarge * 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFeatureIcon(
                    context,
                    icon: Icons.king_bed,
                    label: 'Bedrooms',
                    value: '${apartmentDetails.beds}',
                  ),
                  _buildFeatureIcon(
                    context,
                    icon: Icons.bathtub,
                    label: 'Bathrooms',
                    value: '${apartmentDetails.baths}',
                  ),
                  _buildFeatureIcon(
                    context,
                    icon: Icons.square_foot,
                    label: 'Area',
                    value:
                        '${apartmentDetails.areaSqft.toStringAsFixed(0)} Sqft',
                  ),
                ],
              ),
              const Divider(height: AppSizes.paddingLarge * 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_2_rounded,
                        size: 24,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSizes.paddingMedium),
                      Expanded(
                        child: Text(
                          'Owner: ${apartmentDetails.ownerName}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),
                  InkWell(
                    onTap: () => _showRatingDialog(context),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusLarge,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingSmall,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < apartmentDetails.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 24,
                            );
                          }),
                          const SizedBox(width: AppSizes.paddingSmall),
                          Text(
                            '(${apartmentDetails.reviewsCount} Reviews)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: AppSizes.paddingLarge * 2),

              Text(
                'Amenities & Services',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              AmenitiesResponsiveGrid(amenities: apartmentDetails.amenities),
              const Divider(height: AppSizes.paddingLarge * 2),

              Text(
                'Description',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              Text(
                apartmentDetails.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.paddingExtraLarge),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: CustomPrimaryButton(
          text: 'Book Now',
          onPressed: () => _navigateToBooking(context),
        ),
      ),
    );
  }
}
