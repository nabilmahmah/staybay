import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/apartment_service.dart';
import '../models/apartment_model.dart';
import '../widgets/compact_apartment_card.dart';

class FavoritesScreen extends StatefulWidget {
  static const String routeName = '/favorites';
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  //inal ApartmentService _apartmentService = ApartmentService();
  late Future<List<Apartment>> _favoritesFuture;

  List<Apartment> _fetchMockFavorites() {
    return ApartmentService.mockApartments
        .where((apartment) => apartment.isFavorite)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _favoritesFuture = Future.value(_fetchMockFavorites());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites'), centerTitle: true),
     
      body: FutureBuilder<List<Apartment>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading favorites: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppSizes.paddingMedium),
                  Text(
                    'No Favorite items yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return CompactApartmentCard(apartment: favorites[index]);
              },
            );
          }
        },
      ),
    );
  }
}
