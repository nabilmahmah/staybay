import 'package:staybay/models/apartment_model.dart';

class BookingService {
  static final List<Apartment> bookings = [];

  static void add(Apartment apartment) {
    if (!bookings.any((a) => a.id == apartment.id)) {
      bookings.add(apartment);
    }
  }

  static void remove(String apartmentId) {
    bookings.removeWhere((a) => a.id == apartmentId);
  }
}
  