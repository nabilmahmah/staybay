import 'package:staybay/models/apartment_model.dart';

class Booking {
  final Apartment apartment;
  final DateTime checkIn;
  final DateTime checkOut;
  final String bookingId;

  Booking({
    required this.apartment,
    required this.checkIn,
    required this.checkOut,
    required this.bookingId,
  });

  /// Returns the number of nights for the booking
  int get nights {
    final days = checkOut.difference(checkIn).inDays;
    return days == 0 ? 1 : days;
  }

  /// Returns the total price for the booking
  double get totalPrice => apartment.pricePerNight * nights;
}
