import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';
import 'package:staybay/services/get_governorates_and_cities_service.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final GetGovernatesAndCities getGovernatesAndCities =
      GetGovernatesAndCities();

  // القيم المختارة
  Governorate? selectedGov;
  City? selectedCity;
  String? selectedBedrooms;
  String? selectedBathrooms;
  double? priceMin, priceMax;
  double? sizeMin, sizeMax;
  double? ratingMin, ratingMax;
  bool hasPool = false;
  bool hasWifi = false;

  List<Governorate> governorates = [];
  List<City> cities = [];
  final List<String> roomOptions = ['1', '2', '3', '4+'];
  final List<double> priceOptions = [10, 50, 100, 200, 500, 1000];
  final List<double> sizeOptions = [50, 100, 150, 200, 300, 500];
  final List<double> ratingOptions = [1, 2, 3, 4, 5];

  bool isLoadingGovs = true;
  bool isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadGovernorates();
  }

  Future<void> _loadGovernorates() async {
    try {
      final data = await getGovernatesAndCities.getGovernorates();
      if (mounted) {
        setState(() {
          governorates = data;
          isLoadingGovs = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingGovs = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context
        .watch<LocaleCubit>()
        .state
        .localizedStrings['filter'];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> onGovChanged(Governorate? gov) async {
            if (gov == null) return;
            setDialogState(() {
              selectedGov = gov;
              selectedCity = null;
              cities = [];
              isLoadingCities = true;
            });
            try {
              final data = await getGovernatesAndCities.getCities(gov.id);
              setDialogState(() {
                cities = data;
                isLoadingCities = false;
              });
            } catch (e) {
              setDialogState(() => isLoadingCities = false);
            }
          }

          return AlertDialog(
            title: Text(locale['title'] ?? 'Filter Apartments'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(locale['governorate'] ?? 'Governorate'),
                  isLoadingGovs
                      ? const LinearProgressIndicator()
                      : DropdownButton<Governorate>(
                          isExpanded: true,
                          value: selectedGov,
                          hint: Text(
                            locale['selectGov'] ?? 'Select Governorate',
                          ),
                          items: governorates
                              .map(
                                (gov) => DropdownMenuItem(
                                  value: gov,
                                  child: Text(gov.localized(context)),
                                ),
                              )
                              .toList(),
                          onChanged: onGovChanged,
                        ),

                  const SizedBox(height: 10),
                  _buildLabel(locale['city'] ?? 'City'),
                  isLoadingCities
                      ? const LinearProgressIndicator()
                      : DropdownButton<City>(
                          isExpanded: true,
                          value: selectedCity,
                          hint: Text(
                            selectedGov == null
                                ? (locale['selectGovFirst'] ??
                                      'Select Governorate First')
                                : (locale['selectCity'] ?? 'Select City'),
                          ),
                          items: cities
                              .map(
                                (city) => DropdownMenuItem(
                                  value: city,
                                  child: Text(city.localized(context)),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setDialogState(() => selectedCity = val),
                        ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Divider(),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(locale['bedrooms'] ?? 'Bedrooms'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedBedrooms,
                              items: roomOptions
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setDialogState(() => selectedBedrooms = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(locale['bathrooms'] ?? 'Bathrooms'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedBathrooms,
                              items: roomOptions
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setDialogState(() => selectedBathrooms = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  _buildLabel(locale['price'] ?? 'Price'),
                  _buildRangeRow(priceOptions, priceMin, priceMax, (v, isMin) {
                    setDialogState(() {
                      if (isMin)
                        priceMin = v;
                      else
                        priceMax = v;
                    });
                  }, locale),

                  const SizedBox(height: 15),
                  _buildLabel(locale['size'] ?? 'Area (m²)'),
                  _buildRangeRow(sizeOptions, sizeMin, sizeMax, (v, isMin) {
                    setDialogState(() {
                      if (isMin)
                        sizeMin = v;
                      else
                        sizeMax = v;
                    });
                  }, locale),

                  const SizedBox(height: 15),
                  _buildLabel(locale['rating'] ?? 'Rating'),
                  _buildRangeRow(ratingOptions, ratingMin, ratingMax, (
                    v,
                    isMin,
                  ) {
                    setDialogState(() {
                      if (isMin)
                        ratingMin = v;
                      else
                        ratingMax = v;
                    });
                  }, locale),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Divider(),
                  ),

                  CheckboxListTile(
                    title: Text(locale['hasPool'] ?? 'Has Pool'),
                    value: hasPool,
                    onChanged: (v) => setDialogState(() => hasPool = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: Text(locale['hasWifi'] ?? 'Has WiFi'),
                    value: hasWifi,
                    onChanged: (v) => setDialogState(() => hasWifi = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'governorate_id': selectedGov?.id,
                    'city_id': selectedCity?.id,
                    'city_name': selectedCity?.localized(context),
                    'bedrooms': selectedBedrooms,
                    'bathrooms': selectedBathrooms,
                    'price_min': priceMin,
                    'price_max': priceMax,
                    'size_min': sizeMin,
                    'size_max': sizeMax,
                    'rating_min': ratingMin,
                    'rating_max': ratingMax,
                    'has_pool': hasPool,
                    'has_wifi': hasWifi,
                  });
                },
                child: Text(locale['apply'] ?? 'apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildRangeRow(
    List<double> options,
    double? min,
    double? max,
    Function(double?, bool) onChanged,
    dynamic locale,
  ) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<double>(
            isExpanded: true,
            hint: Text(locale['min'] ?? 'Min'),
            value: min,
            items: options
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.toInt().toString()),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null && max != null && v > max) {
                onChanged(v, true);
                onChanged(null, false);
              } else {
                onChanged(v, true);
              }
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("-"),
        ),
        Expanded(
          child: DropdownButton<double>(
            isExpanded: true,
            hint: Text(locale['max'] ?? 'Max'),
            value: max,
            items: options.map((v) {
              bool isDisabled = (min != null && v < min);
              return DropdownMenuItem(
                value: v,
                enabled: !isDisabled,
                child: Text(
                  v.toInt().toString(),
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: (v) => onChanged(v, false),
          ),
        ),
      ],
    );
  }
}
