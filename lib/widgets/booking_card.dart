import 'package:flutter/material.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/screens/booking_details_screen.dart';

class BookedCard extends StatefulWidget {
  final Apartment apartment;
  final VoidCallback onDelete;

  const BookedCard({
    super.key,
    required this.apartment,
    required this.onDelete,
  });

  @override
  State<BookedCard> createState() => _BookedCardState();
}

class _BookedCardState extends State<BookedCard> {
  /// ===== Widget for rating stars =====
  Widget _ratingStars() {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            starIndex <= widget.apartment.rating.round()
                ? Icons.star
                : Icons.star_border,
            color: Colors.amber,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              // تحديث متوسط التقييم  
              final totalRating =
                  widget.apartment.rating * widget.apartment.reviewsCount;

              widget.apartment.reviewsCount += 1;
              widget.apartment.rating =
                  (totalRating + starIndex) /
                  widget.apartment.reviewsCount;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                BookingDetailsScreen(apartment: widget.apartment),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    widget.apartment.imagePath,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 160, color: Colors.grey[300]),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.apartment.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.apartment.location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.apartment.pricePerNight.toStringAsFixed(0)} / night',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _ratingStars(),
                  Text(
                    '${widget.apartment.rating.toStringAsFixed(1)} (${widget.apartment.reviewsCount} reviews)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
