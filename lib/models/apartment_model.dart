import 'package:staybay/consetans.dart';

class Apartment {
  final String? id;
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
    this.isFavorite = false,
    required this.amenities,
  });
  factory Apartment.fromJson(Map<String, dynamic> json) {
    var hasWifi = json['has_wifi'] == 1 ? 'wifi' : null;
    var hasPool = json['has_pool'] == 1 ? 'pool' : null;
    List<String> amenities = [];
    amenities.addAll([
      if (hasWifi != null) hasWifi,
      if (hasPool != null) hasPool,
    ]);

    var governorate = json['governorate']['name'];
    var city = json['city']['name'];
    var location = '$city, $governorate';

    var images = json['images'] as List<dynamic>;
    List<String> imagesPaths = [];
    for (var image in images) {
      var path = image['path'];
      imagesPaths.add('$kBaseUrlImage/$path');
    }

    var ownerFirstName = json['owner']['first_name'];
    var ownerLastName = json['owner']['last_name'];
    var ownerName = '$ownerFirstName $ownerLastName';
    return Apartment(
      id: json['id'].toString(),
      title: json['title'],
      location: location,
      pricePerNight: json['price'].toDouble(),
      imagePath: imagesPaths.first,
      rating: json['rating'].toString(),
      ratingCount: json['rating_count'],
      beds: json['bedrooms'],
      baths: json['bathrooms'],
      areaSqft: json['size'].toDouble(),
      ownerName: ownerName,
      amenities: amenities,
      description: json['description'] ?? '',
      imagesPaths: imagesPaths,
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
