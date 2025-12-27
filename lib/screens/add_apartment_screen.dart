import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';
import 'package:staybay/services/add_apartment_service.dart';
import 'package:staybay/services/get_governorates_and_cities_service.dart';
import 'package:staybay/widgets/app_bottom_nav_bar.dart';

class AddApartmentScreen extends StatefulWidget {
  static const String routeName = '/add';

  final Apartment? apartmentToEdit;
  const AddApartmentScreen({super.key, this.apartmentToEdit});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  /// ===== FORM =====
  final _formKey = GlobalKey<FormState>();

  final GetGovernatesAndCities _getGovernatesAndCities =
      GetGovernatesAndCities();

  Governorate? selectedGov;
  City? selectedCity;
  List<Governorate> governorates = [];
  List<City> cities = [];

  bool isLoadingGovs = true;
  bool isLoadingCities = false;

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _bedsController = TextEditingController();
  final _bathsController = TextEditingController();
  final _areaController = TextEditingController();
  final _descriptionController = TextEditingController();

  /// ===== AMENITIES =====
  final List<String> _allAmenities = ['wifi', 'pool'];

  List<String> _selectedAmenities = [];

  /// ===== IMAGES =====
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _pickedImages = [];
  final Map<String, Uint8List> _webImageBytes = {};

  @override
  void initState() {
    super.initState();
    _loadGovernorates(); // جلب المحافظات فور فتح الـ Dialog

    if (widget.apartmentToEdit != null) {
      final a = widget.apartmentToEdit!;
      _titleController.text = a.title;
      _priceController.text = a.pricePerNight.toString();
      _bedsController.text = a.beds.toString();
      _bathsController.text = a.baths.toString();
      _areaController.text = a.areaSqft.toString();
      _descriptionController.text = a.description;
      _selectedAmenities = List.from(a.amenities);
    }
  }

  Future<void> _loadGovernorates() async {
    try {
      final data = await _getGovernatesAndCities.getGovernorates();
      setState(() {
        governorates = data;
        isLoadingGovs = false;
      });
    } catch (e) {
      setState(() => isLoadingGovs = false);
      // يمكن إظهار رسالة خطأ هنا
    }
  }

  Future<void> _onGovernorateChanged(Governorate? gov) async {
    if (gov == null) return;

    setState(() {
      selectedGov = gov;
      selectedCity = null; // تصفير المدينة المختارة سابقاً
      cities = [];
      isLoadingCities = true;
    });

    try {
      final data = await _getGovernatesAndCities.getCities(gov.id);
      setState(() {
        cities = data;
        isLoadingCities = false;
      });
    } catch (e) {
      setState(() => isLoadingCities = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// ===== AMENITY ICON =====
  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'pool':
        return Icons.pool;
      default:
        return Icons.check_circle_outline;
    }
  }

  /// ===== IMAGE PICKER =====
  Future<void> _pickImages() async {
    final images = await _imagePicker.pickMultiImage(imageQuality: 85);
    if (images.isEmpty) return;

    if (kIsWeb) {
      for (final img in images) {
        _webImageBytes[img.name] = await img.readAsBytes();
      }
    }
    setState(() => _pickedImages.addAll(images));
  }

  void _removeImageAt(int index) {
    final removed = _pickedImages.removeAt(index);
    if (kIsWeb) _webImageBytes.remove(removed.name);
    setState(() {});
  }

  Widget _imagesPreview() {
    if (_pickedImages.isEmpty) {
      return GestureDetector(
        onTap: _pickImages,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library_outlined),
                SizedBox(height: 6),
                Text('Add images'),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _pickedImages.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == _pickedImages.length) {
            return InkWell(
              onTap: _pickImages,
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.add_a_photo),
              ),
            );
          }

          final image = _pickedImages[index];

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: kIsWeb
                      ? Image.memory(
                          _webImageBytes[image.name]!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(File(image.path), fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: () => _removeImageAt(index),
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ===== SAVE =====
  void _saveApartment() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedGov == null || selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select governorate and city')),
        );
        return;
      }
      var response = await AddApartmentService.addApartment(
        context: context,
        title: _titleController.text,
        description: _descriptionController.text,
        cityId: selectedCity!.id.toString(),
        price: _priceController.text,
        bedrooms: _bedsController.text,
        bathrooms: _bathsController.text,
        size: _areaController.text,
        hasPool: _selectedAmenities.contains('pool') ? '1' : '0',
        hasWifi: _selectedAmenities.contains('wifi') ? '1' : '0',
        imageFiles: _pickedImages,
      );

      if (response != null && response.statusCode == 201) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppBottomNavBar.routeName, (_) => false);
      }
    } else {
      if (_pickedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
        return;
      }
      if (selectedGov == null || selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select governorate and city')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===== AMENITIES UI =====
  Widget _amenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._allAmenities.map((amenity) {
          return CheckboxListTile(
            value: _selectedAmenities.contains(amenity),
            controlAffinity: ListTileControlAffinity.leading,
            title: Row(
              children: [
                Icon(_getAmenityIcon(amenity), size: 20),
                const SizedBox(width: 8),
                Text(amenity),
              ],
            ),
            onChanged: (value) {
              setState(() {
                value == true
                    ? _selectedAmenities.add(amenity)
                    : _selectedAmenities.remove(amenity);
              });
            },
          );
        }),
      ],
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _field(
    TextEditingController controller,
    String lable,
    IconData icone, {
    TextInputType inputType = TextInputType.text,
    int maxlines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxlines,
        validator: (validation) =>
            validation == null || validation.isEmpty ? 'Required' : null,
        decoration: _decoration(lable, icone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Apartment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _imagesPreview(),
              const SizedBox(height: 16),
              _field(_titleController, 'Title', Icons.home),
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

              // 2. قائمة المدن
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

              // _field(_locationController, 'Location', Icons.location_on),
              _field(
                _priceController,
                'Price per night',
                Icons.attach_money,
                inputType: TextInputType.number,
              ),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      _bedsController,
                      'Beds',
                      Icons.bed,
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      _bathsController,
                      'Baths',
                      Icons.bathtub,
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _field(
                _areaController,
                'Area',
                Icons.square_foot,
                inputType: TextInputType.number,
              ),
              _field(
                _descriptionController,
                'Description',
                Icons.description,
                maxlines: 3,
              ),
              const SizedBox(height: 16),
              _amenitiesSection(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveApartment,
                  child: const Text('Save Apartment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
