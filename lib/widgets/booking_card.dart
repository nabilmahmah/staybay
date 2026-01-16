import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/constants.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/models/book_model.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';
import 'package:staybay/screens/booking_details_screen.dart';
// import 'package:staybay/screens/booking_details_screen.dart';
import 'package:staybay/services/pay_booking_service.dart';
import 'package:staybay/services/rate_booking_service.dart';
import 'package:staybay/widgets/chat_button.dart';
import 'package:staybay/widgets/rating_dialog.dart';

class BookedCard extends StatefulWidget {
  final BookModel book;
  final VoidCallback? onUpdate;

  const BookedCard({super.key, required this.book, this.onUpdate});

  @override
  State<BookedCard> createState() => _BookedCardState();
}

class _BookedCardState extends State<BookedCard> {
  Map<String, dynamic> get locale =>
      context.watch<LocaleCubit>().state.localizedStrings['bookedCard'];

  bool _isActionLoading = false;
  String _getStatuslabel(String status, Map<String, dynamic> locale) {
    switch (status.toLowerCase()) {
      case 'pending':
        return locale['pending'] ?? 'pending';
      case 'approved':
        return locale['approved'] ?? 'approved';
      case 'rejected':
        return locale['rejected'] ?? 'rejected';
      case 'cancelled':
        return locale['cancelled'] ?? 'cancelled';
      case 'completed':
        return locale['completed'] ?? 'completed';
      case 'started':
        return locale['started'] ?? 'started';
      case 'finished':
        return locale['finished'] ?? 'finished';
      case 'failed':
        return locale['failed'] ?? 'failed';
      default:
        return locale['error'] ?? 'Error';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      case 'started':
        return Colors.blue;
      case 'completed':
      case 'finished':
        return Colors.teal;
      case 'failed':
        return Colors.deepOrange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.book.status;
    final bool canEdit = widget.book.canUserEdit;
    final bool canRate = widget.book.userCanRate;
    final bool canPay = widget.book.canUserPay;
    final double ratingVal =
        (double.tryParse(widget.book.apartment.rating) ?? 0.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                widget.book.apartment.imagePath.startsWith('http')
                    ? widget.book.apartment.imagePath
                    : '$kBaseUrlImage/${widget.book.apartment.imagePath}',
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 170,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.book.apartment.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _StatusChip(
                        label: _getStatuslabel(
                          widget.book.status,
                          locale['status_all'],
                        ),
                        color: _getStatusColor(status),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.book.apartment.governorate?.localized(context)},${widget.book.apartment.city?.localized(context)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "${locale['total'] ?? 'Total:'} \$${widget.book.totalPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < ratingVal.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 18,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _DateItem(icon: Icons.login, text: widget.book.startDate),
                      const Spacer(),
                      _DateItem(icon: Icons.logout, text: widget.book.endDate),
                    ],
                  ),
                  const Divider(height: 28),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isActionLoading)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        ChatButton(
                          receiverId: widget.book.apartment.ownerId,
                          buttonText: locale['chat'] ?? 'Chat',
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: canEdit ? _handleEdit : null,
                          icon: const Icon(Icons.edit, size: 18),
                          label: Text(locale['edit'] ?? 'edit'),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: canRate ? _handleRate : null,
                          icon: const Icon(Icons.star_outline, size: 18),
                          label: Text(locale['rate'] ?? 'Rate'),
                        ),
                        const SizedBox(height: 8),

                        ElevatedButton(
                          onPressed: canPay ? _handlePay : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canPay
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(locale['pay'] ?? 'Pay Now'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingDetailsScreen(booking: widget.book),
      ),
    ).then((_) => widget.onUpdate?.call());
  }

  void _handleRate() async {
    final selectedRating = await showDialog<int>(
      context: context,
      builder: (_) => const RatingDialog(),
    );

    if (selectedRating != null && selectedRating > 0) {
      setState(() => _isActionLoading = true);
      bool success = await RateBookingService.rateBooking(
        context: context,
        bookingId: widget.book.id.toString(),
        rating: selectedRating.toDouble(),
      );

      if (success && mounted) {
        if (widget.onUpdate != null) {
          widget.onUpdate!();
        }
      }
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  void _handlePay() async {
    setState(() => _isActionLoading = true);

    bool success = await PayBookingService.payBooking(
      context: context,
      bookingId: widget.book.id.toString(),
    );

    if (success && mounted) {
      if (widget.onUpdate != null) {
        widget.onUpdate!();
      }
    } else {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DateItem({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
