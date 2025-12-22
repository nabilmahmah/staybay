import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/widgets/app_bottom_nav_bar.dart';
import '../services/apartment_service.dart';

class AddApartmentScreen extends StatefulWidget {
  static const String routeName = '/add';

  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  /// ===== FORM =====
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _bedsController = TextEditingController();
  final _bathsController = TextEditingController();
  final _areaController = TextEditingController();
  final _descriptionController = TextEditingController();

  /// ===== IMAGES =====
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _pickedImages = [];

  /// Web image cache
  final Map<String, Uint8List> _webImageBytes = {};

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// ===== IMAGE PICKER =====
  Future<void> _pickImages() async {
    try {
      final images = await _imagePicker.pickMultiImage(imageQuality: 85);
      if (images == null || images.isEmpty) return;

      if (kIsWeb) {
        for (final img in images) {
          _webImageBytes[img.name] = await img.readAsBytes();
        }
      }

      setState(() {
        _pickedImages.addAll(images);
      });
    } catch (_) {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      if (kIsWeb) {
        _webImageBytes[image.name] = await image.readAsBytes();
      }

      setState(() {
        _pickedImages.add(image);
      });
    }
  }

  void _removeImageAt(int index) {
    final removed = _pickedImages.removeAt(index);
    if (kIsWeb) _webImageBytes.remove(removed.name);
    setState(() {});
  }

  /// ===== SAVE =====
  void _saveApartment() {
    if (!_formKey.currentState!.validate()) return;

    double parseDouble(String v) =>
        double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
    int parseInt(String v) => int.tryParse(v) ?? 0;

    final imagePaths = kIsWeb
        ? _pickedImages.map((e) => e.name).toList()
        : _pickedImages.map((e) => e.path).toList();

    final apartment = Apartment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      pricePerNight: parseDouble(_priceController.text),
      imagePath: imagePaths.isNotEmpty ? imagePaths.first : '',
      rating: 0.0,
      reviewsCount: 0,
      beds: parseInt(_bedsController.text),
      baths: parseInt(_bathsController.text),
      areaSqft: parseDouble(_areaController.text),
      ownerName: '',
      amenities: const [],
      description: _descriptionController.text.trim(),
      imagesPaths: imagePaths,
    );

    ApartmentService.mockApartments.add(apartment);

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppBottomNavBar.routeName,
      (_) => false,
    );
  }

  /// ===== UI HELPERS =====
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
        decoration: _inputDecoration(label, icon),
      ),
    );
  }

  /// ===== IMAGE PREVIEW =====
  Widget _imagesPreview() {
    if (_pickedImages.isEmpty) {
      return GestureDetector(
        onTap: _pickImages,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library_outlined, size: 28),
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
                      : Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                        ),
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

  /// ===== BUILD =====
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Apartment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== FULL WIDTH HEADER =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a New Listing',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Fill the details below to add your apartment',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// ===== FORM CONTENT =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _imagesPreview(),
                    const SizedBox(height: 14),

                    _textField(
                        _titleController, 'Apartment Title', Icons.home),
                    _textField(_locationController, 'Location',
                        Icons.location_on),
                    _textField(
                      _priceController,
                      'Price per Night',
                      Icons.attach_money,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            _bedsController,
                            'Beds',
                            Icons.bed,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            _bathsController,
                            'Baths',
                            Icons.bathtub,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    _textField(
                      _areaController,
                      'Area (sqft)',
                      Icons.square_foot,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    _textField(
                      _descriptionController,
                      'Description',
                      Icons.description,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveApartment,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Apartment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
