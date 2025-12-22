import 'package:flutter/material.dart';
import 'package:staybay/services/booking_service.dart';
import 'package:staybay/widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  static const routeName = '/bookingsRout';
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  void _deleteBooking(String apartmentId) {
    setState(() {
      BookingService.remove(apartmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookings = BookingService.bookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: bookings.isEmpty
          ? const _EmptyBookings()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final apartment = bookings[index];
                return BookedCard(
                  apartment: apartment,
                  onDelete: () => _deleteBooking(apartment.id),
                );
              },
            ),
    );
  }
}
class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No bookings yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
