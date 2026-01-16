import 'package:staybay/constants.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';

class Apartment {
  String? id;
  final String title;
  final String? location;
  final double pricePerNight;
  final String imagePath;
  String rating;
  int ratingCount;
  final int beds;
  final int baths;
  final double areaSqft;
  final String? ownerName;
  final List<String> amenities;
  final String description;
  final List<String> imagesPaths;
  bool isFavorite;
  City? city;
  Governorate? governorate;
  List<int>? imagesIDs;
  final int? ownerId;

  Apartment({
    this.id,
    this.location,
    this.ownerName,
    required this.title,
    required this.pricePerNight,
    required this.imagePath,
    required this.rating,
    required this.ratingCount,
    required this.beds,
    required this.baths,
    required this.areaSqft,
    required this.description,
    required this.imagesPaths,
    this.imagesIDs,
    this.isFavorite = false,
    required this.amenities,
    this.city,
    this.governorate,
    this.ownerId,
  });
  factory Apartment.fromJson(Map<String, dynamic> json) {
    List<String> amenities = [];
    if (json['has_wifi'] == 1 || json['has_wifi'] == true) {
      amenities.add('wifi');
    }
    if (json['has_pool'] == 1 || json['has_pool'] == true) {
      amenities.add('pool');
    }
    List<String> paths = [];
    List<int> ids = [];

    String coverPath = '';
    if (json['cover_image'] != null) {
      String p = json['cover_image']['path'] ?? '';
      coverPath = p.startsWith("http") ? p : '$kBaseUrlImage/$p';
    }

    if (json['images'] != null && json['images'] is List) {
      for (var img in json['images']) {
        if (img['id'] != null) ids.add(img['id']);
        String? p = img['path'];
        if (p != null) {
          paths.add(p.startsWith("http") ? p : '$kBaseUrlImage/$p');
        }
      }
    }

    if (coverPath.isEmpty && paths.isNotEmpty) {
      coverPath = paths.first;
    }

    return Apartment(
      id: json['id']?.toString(),
      title: json['title'] ?? 'No Title',
      location:
          "${json['city']?['name'] ?? ''}, ${json['governorate']?['name'] ?? ''}",
      pricePerNight: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imagePath: coverPath,
      rating: json['rating']?.toString() ?? '0',
      ratingCount: int.tryParse(json['rating_count']?.toString() ?? '0') ?? 0,
      beds: int.tryParse(json['bedrooms']?.toString() ?? '0') ?? 0,
      baths: int.tryParse(json['bathrooms']?.toString() ?? '0') ?? 0,
      areaSqft: double.tryParse(json['size']?.toString() ?? '0') ?? 0.0,
      ownerName:
          "${json['owner']?['first_name'] ?? ''} ${json['owner']?['last_name'] ?? ''}",
      amenities: amenities,
      description: json['description'] ?? '',
      imagesPaths: paths,
      imagesIDs: ids,
      isFavorite: json['is_favorite'] ?? false,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      governorate: json['governorate'] != null
          ? Governorate.fromJson(json['governorate'])
          : null,
      ownerId: json['owner_id'],
    );
  }
}
