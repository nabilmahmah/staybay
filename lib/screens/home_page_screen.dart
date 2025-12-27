import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/app_theme.dart';
import 'package:staybay/cubits/apartments/acpartment_state.dart';
import 'package:staybay/cubits/apartments/aparment_cubit.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/widgets/active_filters_bar.dart';
import 'package:staybay/widgets/apartment_card.dart';
import 'package:staybay/widgets/filter_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> filters = {};

  @override
  void initState() {
    super.initState();
    context.read<ApartmentCubit>().fetchApartments();
    _scrollController.addListener(_onScroll);
  }

  // ================= Scroll =================
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ApartmentCubit>().fetchApartments(filters: filters);
    }
  }

  // ================= Filters =================
  Future<void> _openFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const FilterDialog(),
    );

    if (result != null) {
      final cleaned = _sanitizeFilters(result);

      setState(() {
        filters = Map<String, dynamic>.from(cleaned);
      });

      log('Active Filters: $filters');

      context.read<ApartmentCubit>().fetchApartments(
        refresh: true,
        filters: filters,
      );
    }
  }

  Map<String, dynamic> _sanitizeFilters(Map<String, dynamic> raw) {
    final Map<String, dynamic> cleaned = {};

    raw.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (value is bool && value == false) return;

      cleaned[key] = value;
    });

    return cleaned;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: BlocBuilder<ApartmentCubit, ApartmentState>(
        builder: (context, state) {
          if (state is ApartmentLoading &&
              context.read<ApartmentCubit>().currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApartmentError) {
            return Center(child: Text(state.message));
          }

          if (state is ApartmentLoaded) {
            final apartments = state.apartments
                .map((e) => Apartment.fromJson(e))
                .toList();

            if (apartments.isEmpty) {
              return const Center(child: Text('No apartments found'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ApartmentCubit>().refreshApartments(filters);
              },
              child: Column(
                children: [
                  /// ===== Active Filters =====
                  ActiveFiltersBar(
                    filters: filters,
                    onRemove: (key) {
                      setState(() {
                        final newFilters = Map<String, dynamic>.from(filters);

                        newFilters.remove(key);

                        if (key == 'price_min' || key == 'price_max') {
                          newFilters.remove('price_min');
                          newFilters.remove('price_max');
                        }

                        filters = newFilters;
                      });

                      context.read<ApartmentCubit>().fetchApartments(
                        refresh: true,
                        filters: filters,
                      );
                    },
                  ),

                  /// ===== Apartments List =====
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSizes.paddingMedium),
                      itemCount: apartments.length + 1,
                      itemBuilder: (context, index) {
                        if (index < apartments.length) {
                          return ApartmentCard(apartment: apartments[index]);
                        }

                        return context.read<ApartmentCubit>().hasReachedMax
                            ? const SizedBox.shrink()
                            : const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ================= AppBar =================
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppSizes.paddingExtraLarge * 2.5),
      child: Container(
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        final newFilters = Map<String, dynamic>.from(filters);

                        if (value.trim().isEmpty) {
                          newFilters.remove('search');
                        } else {
                          newFilters['search'] = value.trim();
                        }

                        filters = newFilters;
                      });

                      context.read<ApartmentCubit>().fetchApartments(
                        refresh: true,
                        filters: filters,
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: _openFilterDialog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
