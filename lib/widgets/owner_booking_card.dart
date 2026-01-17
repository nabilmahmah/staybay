import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/constants.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import 'package:staybay/models/book_model.dart';
import 'package:staybay/services/owner_update_booking_servcie.dart';
import 'package:staybay/widgets/chat_button.dart';

class OwnerBookedCard extends StatefulWidget {
  final BookModel book;
  final VoidCallback? onUpdate;

  const OwnerBookedCard({super.key, required this.book, this.onUpdate});

  @override
  State<OwnerBookedCard> createState() => _OwnerBookedCardState();
}

class _OwnerBookedCardState extends State<OwnerBookedCard> {
  bool _isLoading = false;

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
      case 'completed':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

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

  Future<void> _confirmAction(
    String newStatus,
    Map<String, dynamic> locale,
  ) async {
    final bool isApprove = newStatus == 'approved';
    String localeStatus = locale['status_question'][newStatus];

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        // title: Text('$localeStatus Booking?'),
        title: Text(
          '$localeStatus ${locale['status']['booking'] ?? 'Booking'}',
        ),
        content: Text(
          // '${locale['beginningOfQuestion'] ?? 'Are you sure you want to '}$newStatus${locale['endOfQuestion'] ?? ' this request?'}',
          '${locale['beginningOfQuestion'] ?? 'Are you sure you want to '}$localeStatus${locale['endOfQuestion'] ?? ' this request?'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(locale['cancel'] ?? 'CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('${locale['yes'] ?? 'YES, '}$localeStatus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _handleUpdate(newStatus);
    }
  }

  Future<void> _handleUpdate(String newStatus) async {
    setState(() => _isLoading = true);

    bool success = await OwnerUpdateBookingService.updateBooking(
      context: context,
      bookingId: widget.book.id.toString(),
      status: newStatus,
    );

    if (success && mounted) {
      widget.onUpdate?.call();
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canOwnerEdit = widget.book.canOwnerEdit;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        Map<String, dynamic> locale = state.localizedStrings['OwnerBookedCard'];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            widget.book.apartment.imagePath.startsWith('http')
                                ? widget.book.apartment.imagePath
                                : '$kBaseUrlImage/${widget.book.apartment.imagePath}',
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(color: Colors.grey.shade200);
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _StatusChip(
                          label: _getStatuslabel(
                            widget.book.status,
                            locale['status'],
                          ),
                          color: _getStatusColor(widget.book.status),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.book.apartment.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "#${widget.book.id}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _DateInfo(
                            label: locale['Check-in'] ?? 'Check-in',
                            date: widget.book.startDate,
                          ),
                          const SizedBox(width: 24),
                          _DateInfo(
                            label: locale['Check-out'] ?? 'Check-out',
                            date: widget.book.endDate,
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (canOwnerEdit)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    _confirmAction('rejected', locale),
                                child: Text(locale['reject'] ?? 'REJECT'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _confirmAction('approved', locale),
                                child: Text(locale['approve'] ?? 'APPROVE'),
                              ),
                            ),
                          ],
                        )
                      else
                        Center(
                          child: Text(
                            locale['noFurther'] ??
                                'No further actions available',
                          ),
                        ),

                      const SizedBox(height: 12),

                      ChatButton(
                        receiverId: widget.book.userId,
                        buttonText: locale['chat'] ?? 'Chat',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DateInfo extends StatelessWidget {
  final String label;
  final String date;

  const _DateInfo({required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 2),
        Text(date, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
