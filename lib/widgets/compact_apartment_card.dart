import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/apartment_model.dart';
import '../screens/apartment_details_screen.dart';

class CompactApartmentCard extends StatelessWidget {
  final Apartment apartment;
  const CompactApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heartColor = theme.colorScheme.error; 

    return InkWell(
      onTap: () {   
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ApartmentDetailsScreen(apartment: apartment),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      child: Card(
        color: theme.cardColor,
        elevation: 1, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          side: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.6), 
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
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                child: Image.asset(
                  apartment.imagePath,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100, 
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(width: AppSizes.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apartment.title,
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
                        Icon(Icons.location_on, size: 16, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: AppSizes.paddingSmall / 2),
                        Text(
                          apartment.location,
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
                    const SizedBox(height: AppSizes.paddingSmall),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${apartment.pricePerNight.toStringAsFixed(0)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: ' / night',
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
                  icon: Icon(Icons.favorite, color: heartColor, size: 30),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Removed ${apartment.title} from favorites.')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

