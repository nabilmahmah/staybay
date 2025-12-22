import 'package:flutter/material.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/services/booking_service.dart';

class BookingDetailsScreen extends StatefulWidget {
  static const routeName = '/bookingDetails';
  final Apartment apartment;

  const BookingDetailsScreen({Key? key, required this.apartment})
    : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late DateTime _checkIn;
  late DateTime _checkOut;
  String? _paymentMethod;

  @override
  void initState() {
    super.initState();
    _checkIn = DateTime.now();
    _checkOut = DateTime.now().add(const Duration(days: 1));
  }

  int get nights {
    final diff = _checkOut.difference(_checkIn).inDays;
    return diff <= 0 ? 1 : diff;
  }

  double get total => widget.apartment.pricePerNight * nights;

  Future<void> _pickDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : _checkOut,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      isCheckIn ? _checkIn = picked : _checkOut = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.apartment;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              apt.imagePath,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(height: 200, color: Colors.grey[300]),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            apt.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(apt.location, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _dateTile('Check-in', _checkIn, () => _pickDate(true)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dateTile(
                  'Check-out',
                  _checkOut,
                  () => _pickDate(false),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Payment Method'),
            value: _paymentMethod,
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'Card', child: Text('Card')),
              DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
            ],
            onChanged: (v) => setState(() => _paymentMethod = v),
          ),

          const SizedBox(height: 16),
          Text(
            'Total: \$${total.toStringAsFixed(2)} ($nights nights)',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              BookingService.add(widget.apartment);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking confirmed')),
              );
            },

            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  Widget _dateTile(String label, DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              '${date.year}-${date.month}-${date.day}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
