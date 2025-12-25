import 'package:flutter/material.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/screens/add_apartment_screen.dart';
import 'package:staybay/services/apartment_service.dart';
import 'package:staybay/services/get_apartment_service.dart';
import 'package:staybay/widgets/apartment_card.dart';
import 'package:staybay/widgets/compact_apartment_card.dart';

class MyApartmentsScreen extends StatefulWidget {
  static const routeName = '/my-apartments';

  MyApartmentsScreen({super.key});

  @override
  State<MyApartmentsScreen> createState() => _MyApartmentsScreenState();
}

class _MyApartmentsScreenState extends State<MyApartmentsScreen> {
  late Future<List<Apartment>> future;
  @override
  void initState() {
    super.initState();
    future = GetApartmentService.getMy();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My apartment'), centerTitle: true),
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
                child: Text(
                  'No Apartment yet',
                  style: theme.textTheme.headlineMedium,
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
