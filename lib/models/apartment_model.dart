class Apartment {
  final String id;
  final String title;
  final String location;
  final double pricePerNight;
  final String imagePath;
  double rating;
  int reviewsCount;
  final int beds;
  final int baths;
  final double areaSqft;
  final String ownerName;
  final List<String> amenities;
  final String description;
  final List<String> imagesPaths;
  bool isFavorite;

  Apartment({
    required this.id,
    required this.title,
    required this.location,
    required this.pricePerNight,
    required this.imagePath,
    required this.rating,
    required this.reviewsCount,
    required this.beds,
    required this.baths,
    required this.areaSqft,
    required this.ownerName,
    required this.amenities,
    required this.description,
    required this.imagesPaths,
    this.isFavorite = false,
  });

  get price => null;

  get area => null;
}
