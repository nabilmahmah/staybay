import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/apartment_card.dart';
import '../services/apartment_service.dart';
import '../models/apartment_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Apartment> _apartments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApartments();
  }

  Future<void> _fetchApartments() async {
    try {
      final data = await ApartmentService().fetchAllApartments();
      setState(() {
        _apartments = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching apartments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          SizedBox(height: 40),
          SearchFiltersWidget(
            onLocationSelected: (gov, city) {
              // send to backend
            },
            onBedsSelected: (beds) {},
            onBathsSelected: (baths) {},
            onAreaSelected: (min, max) {},
            onPriceSelected: (min, max) {},
          ),
          //   SearchFiltersWidget(),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                      vertical: AppSizes.paddingSmall,
                    ),
                    itemCount: _apartments.length,
                    itemBuilder: (context, index) {
                      return ApartmentCard(apartment: _apartments[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
