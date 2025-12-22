
import '../models/apartment_model.dart';
import 'dart:async';

class ApartmentService {
  
  static List<String> _getCarouselImages(int start, int end) {
    return List.generate(end - start + 1, (index) {
      return 'assets/images/ima${start + index}.jpg';
    });
  }

  static List<Apartment> mockApartments = [
    Apartment(
      id: 'a1',
      title:'Luxury apartment in Damascus',
      location: 'Damascus, Mezzeh',
      pricePerNight: 1500.0,
      imagePath: 'assets/images/ima1.jpg',
      rating: 5.0,
      reviewsCount: 55,
      beds: 3,
      baths: 2,
      areaSqft: 1200,
      ownerName: 'Ahmed Al-Sayed',
      amenities: ['WiFi', 'Pool', 'Parking', 'Gym', 'Balcony'],
      description: 'A truly luxurious experience in the heart of Damascus. This apartment boasts modern design, high-end finishing, and panoramic city views. Perfect for families or a high-class business trip. All amenities are included to ensure your comfort.',
      imagesPaths: _getCarouselImages(7, 11), 
    ),
    Apartment(
      id: 'a2',
      title:'A Modern studio in Old Aleppo',
      location: 'Aleppo, Al-Azamiyah',
      pricePerNight: 950.0,
      imagePath: 'assets/images/ima2.jpg',
      rating: 4.5,
      reviewsCount: 30,
      beds: 1,
      baths: 1,
      areaSqft: 500,
      ownerName: 'Faten Homsi',
      amenities: ['WiFi', 'Parking', 'Heating'],
      description: 'Cozy and modern studio apartment situated in the historic area of Old Aleppo. Experience the charm of the past with the convenience of a fully renovated space. Ideal for solo travelers or couples.',
      imagesPaths: _getCarouselImages(12, 16), 
    ),
    Apartment(
      id: 'a3',
      title:'Sea-view villa in Latakia',
      location: 'Latakia, Blue Beach',
      pricePerNight: 1200.0,
      imagePath: 'assets/images/ima3.jpg',
      rating: 5.0,
      reviewsCount: 78,
      beds: 4,
      baths: 3,
      areaSqft: 2500,
      ownerName: 'Jamal Kanaan',
      amenities: ['WiFi', 'Pool', 'Parking', 'Garden', 'BBQ Area'],
      description: 'Stunning sea-view villa perfect for a getaway. Enjoy the private beach access, large pool, and beautifully landscaped garden. The perfect retreat to relax and unwind.',
      imagesPaths: _getCarouselImages(17, 21), 
    ),
    Apartment(
      id: 'a4',
      title:'A quiet apartment in Homs',
      location: 'Homs, Al-Hamra',
      pricePerNight: 1100.0,
      imagePath: 'assets/images/ima4.jpg',
      rating: 4.0,
      reviewsCount: 22,
      beds: 2,
      baths: 1,
      areaSqft: 850,
      ownerName: 'Noura Al Ali',
      amenities: ['WiFi', 'Heating', 'Quiet Area'],
      description: 'A comfortable and quiet apartment located in a family-friendly neighborhood in Homs. Fully equipped kitchen and spacious living areas. A peaceful stay guaranteed.',
      imagesPaths: _getCarouselImages(22, 26), 
    ),
    Apartment(
      id: 'a5',
      title:'Mountain Chalet in  Tartous',
      location: 'Tartous, Salanfeh',
      pricePerNight: 750.0,
      imagePath: 'assets/images/ima5.jpg',
      rating: 4.8,
      reviewsCount: 45,
      beds: 3,
      baths: 2,
      areaSqft: 1500,
      ownerName: 'Waseem Taha',
      amenities: ['WiFi', 'Parking', 'Fireplace', 'Mountain View'],
      description: 'Escape to the mountains with this charming chalet in Tartous. Enjoy the cool weather, fresh air, and a cozy fireplace. Experience nature at its finest.',
      imagesPaths: _getCarouselImages(27, 31), 
    ),
    Apartment(
      id: 'a6',
      title:'An apartment in Daraa',
      location: 'Daraa, Al-Kashef',
      pricePerNight: 1200.0,
      imagePath: 'assets/images/ima6.jpg',
      rating: 3.9,
      reviewsCount: 15,
      beds: 2,
      baths: 1,
      areaSqft: 700,
      ownerName: 'Maya Khouri',
      amenities: ['WiFi', 'Parking', 'Pets Allowed'],
      description: 'A simple, clean, and centrally located apartment in Daraa. Offers essential comforts for a short or long stay. Close to all public services.',
      imagesPaths: _getCarouselImages(32, 36), 
    ),
  ];

  Future<List<Apartment>> fetchAllApartments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockApartments;
  }
}

