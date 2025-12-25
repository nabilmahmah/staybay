import 'package:flutter/material.dart';
import 'package:staybay/services/get_apartment_service.dart';
import 'package:staybay/test.dart';
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
  late Future<List<Apartment>> future;
  @override
  void initState() {
    super.initState();
    future = GetApartmentService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites'), centerTitle: true),
      body: FutureBuilder<List<Apartment>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('oops Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            var favorites = snapshot.data!;
            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Favorite items yet',
                      style: theme.textTheme.headlineMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Refresh'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                var apartment = favorites[index];
                return CompactApartmentCard(apartment: apartment);
              },
            );
          } else {
            return Center(
              child: Text(
                'No favorites yet!',
                style: theme.textTheme.headlineMedium,
              ),
            );
          }
        },
      ),
    );
  }
}
