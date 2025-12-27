import 'package:flutter/material.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';
import 'package:staybay/services/get_governorates_and_cities_service.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final GetGovernatesAndCities getGovernatesAndCities =
      GetGovernatesAndCities();

  Governorate? selectedGov;
  City? selectedCity;
  String? selectedBedrooms;
  String? selectedBathrooms;

  List<Governorate> governorates = [];
  List<City> cities = [];
  List<String> roomOptions = ['1', '2', '3', '4+'];

  bool isLoadingGovs = true;
  bool isLoadingCities = false;

  double? priceMin, priceMax;
  double? sizeMin, sizeMax;
  double? ratingMin, ratingMax;
  bool hasPool = false;
  bool hasWifi = false;

  List<double> priceOptions = [1000, 5000, 10000, 20000, 50000];
  List<double> sizeOptions = [50, 100, 150, 200, 300, 500];
  List<double> ratingOptions = [1, 2, 3, 4, 5];
  @override
  void initState() {
    super.initState();
    _loadGovernorates();
  }

  void _validateRange(String type, double? value, bool isMin) {
    setState(() {
      if (type == 'price') {
        if (isMin) {
          priceMin = value;
          if (priceMax != null && priceMin! > priceMax!) priceMax = null;
        } else {
          priceMax = value;
          if (priceMin != null && priceMax! < priceMin!) priceMin = null;
        }
      } else if (type == 'size') {
        if (isMin) {
          sizeMin = value;
          if (sizeMax != null && sizeMin! > sizeMax!) sizeMax = null;
        } else {
          sizeMax = value;
          if (sizeMin != null && sizeMax! < sizeMin!) sizeMin = null;
        }
      } else if (type == 'rating') {
        if (isMin) {
          ratingMin = value;
          if (ratingMax != null && ratingMin! > ratingMax!) ratingMax = null;
        } else {
          ratingMax = value;
          if (ratingMin != null && ratingMax! < ratingMin!) ratingMin = null;
        }
      }
    });
  }

  Future<void> _loadGovernorates() async {
    try {
      final data = await getGovernatesAndCities.getGovernorates();
      setState(() {
        governorates = data;
        isLoadingGovs = false;
      });
    } catch (e) {
      setState(() => isLoadingGovs = false);
    }
  }

  Future<void> _onGovernorateChanged(Governorate? gov) async {
    if (gov == null) return;

    setState(() {
      selectedGov = gov;
      selectedCity = null;
      cities = [];
      isLoadingCities = true;
    });

    try {
      final data = await getGovernatesAndCities.getCities(gov.id);
      setState(() {
        cities = data;
        isLoadingCities = false;
      });
    } catch (e) {
      setState(() => isLoadingCities = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text('فلترة الشقق السكنية'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterRow(
                label: 'المحافظة',
                value: selectedGov?.name,
                child: isLoadingGovs
                    ? CircularProgressIndicator(strokeWidth: 2)
                    : DropdownButton<Governorate>(
                        isExpanded: true,
                        hint: Text('اختر محافظة'),
                        value: selectedGov,
                        items: governorates.map((gov) {
                          return DropdownMenuItem(
                            value: gov,
                            child: Text(gov.name),
                          );
                        }).toList(),
                        onChanged: _onGovernorateChanged,
                      ),
              ),

              _buildFilterRow(
                label: 'المدينة',
                value: selectedCity?.name,
                child: isLoadingCities
                    ? LinearProgressIndicator()
                    : DropdownButton<City>(
                        isExpanded: true,
                        hint: Text(
                          selectedGov == null
                              ? 'اختر محافظة أولاً'
                              : 'اختر مدينة',
                        ),
                        value: selectedCity,
                        items: cities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city.name),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => selectedCity = val),
                      ),
              ),

              _buildFilterRow(
                label: 'غرف النوم',
                value: selectedBedrooms,
                child: DropdownButton<String>(
                  isExpanded: true,
                  items: roomOptions
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedBedrooms = val),
                ),
              ),

              _buildFilterRow(
                label: 'دورات المياه',
                value: selectedBathrooms,
                child: DropdownButton<String>(
                  isExpanded: true,
                  items: roomOptions
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedBathrooms = val),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "السعر (ليرة)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildRangeRow('price', priceOptions, priceMin, priceMax),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "المساحة (م²)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildRangeRow('size', sizeOptions, sizeMin, sizeMax),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "التقييم",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildRangeRow(
                'rating',
                [1.0, 2.0, 3.0, 4.0, 5.0],
                ratingMin,
                ratingMax,
              ),

              CheckboxListTile(
                title: Text("يوجد مسبح"),
                value: hasPool,
                onChanged: (val) => setState(() => hasPool = val!),
                secondary: Icon(Icons.pool),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                title: Text("يوجد واي فاي"),
                value: hasWifi,
                onChanged: (val) => setState(() => hasWifi = val!),
                secondary: Icon(Icons.wifi),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'governorate_id': selectedGov?.id,
              'city_id': selectedCity?.id,
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
            }),
            child: Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeRow(
    String type,
    List<double> options,
    double? minVal,
    double? maxVal,
  ) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<double>(
            hint: Text("الأدنى"),
            isExpanded: true,
            value: minVal,
            items: options
                .map(
                  (v) => DropdownMenuItem(value: v, child: Text(v.toString())),
                )
                .toList(),
            onChanged: (v) => _validateRange(type, v, true),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("إلى"),
        ),
        Expanded(
          child: DropdownButton<double>(
            hint: Text("الأقصى"),
            isExpanded: true,
            value: maxVal,
            items: options
                .map(
                  (v) => DropdownMenuItem(value: v, child: Text(v.toString())),
                )
                .toList(),
            onChanged: (v) => _validateRange(type, v, false),
          ),
        ),
      ],
    );
  }
}

Widget _buildFilterRow({
  required String label,
  required String? value,
  required Widget child,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
              child,
            ],
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              value ?? '-',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
