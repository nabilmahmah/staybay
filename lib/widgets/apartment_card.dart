
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/apartment_model.dart';
import '../screens/apartment_details_screen.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  VoidCallback? onTap;
   ApartmentCard({super.key, required this.apartment, this.onTap});

  Widget _buildDetailItem(BuildContext context, {required IconData icon, required String value}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: AppSizes.paddingSmall / 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap ??
      ()  {   
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ApartmentDetailsScreen(apartment: apartment),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      child: Card(
        color: theme.cardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        margin: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.borderRadiusLarge),
              ),

              child: Image.asset(
                apartment.imagePath,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Text('Image Not Found: ${apartment.imagePath}'),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.paddingSmall / 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: AppSizes.paddingSmall / 2),
                      Text(
                        apartment.location,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSizes.paddingMedium * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(context, icon: Icons.king_bed, value: '${apartment.beds} Beds'),
                      _buildDetailItem(context, icon: Icons.bathtub, value: '${apartment.baths} Baths'),
                      _buildDetailItem(context, icon: Icons.square_foot, value: '${apartment.areaSqft} Sqft'),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: AppSizes.paddingSmall / 2),
                          Text(
                            '${apartment.rating.toStringAsFixed(1)} (${apartment.reviewsCount})',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.paddingMedium),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${apartment.pricePerNight.toStringAsFixed(0)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                              fontSize: 24,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
