import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/models/book_model.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';
import 'package:staybay/screens/bookings_screen.dart';
import 'package:staybay/services/create_booking_service.dart';
import 'package:staybay/services/get_apartment_not_available_dates_service.dart';
import 'package:staybay/services/user_update_booking_service.dart';

class BookingDetailsScreen extends StatefulWidget {
  static const routeName = 'bookingDetails';
  final Apartment? apartment;
  final BookModel? booking;

  const BookingDetailsScreen({super.key, this.apartment, this.booking});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Map<String, dynamic> get locale =>
      context.watch<LocaleCubit>().state.localizedStrings['BookingDetails'];
  DateTimeRange? _selectedRange;
  // String? _paymentMethod;
  List<DateTime> _blockedDates = [];
  bool _isLoadingDates = true;

  bool get isEditing => widget.booking != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _selectedRange = DateTimeRange(
        start: DateTime.parse(widget.booking!.startDate),
        end: DateTime.parse(widget.booking!.endDate),
      );
    }
    _fetchBlockedDates();
  }

  Future<void> _fetchBlockedDates() async {
    final targetId = widget.apartment?.id ?? widget.booking?.apartment.id;
    if (targetId == null) return;

    final dates = await GetApartmentNotAvailableDatesService.getDisabledDates(
      targetId,
    );
    setState(() {
      _blockedDates = dates;
      _isLoadingDates = false;
    });
  }

  bool _isDayAvailable(DateTime date) {
    bool isBlocked = _blockedDates.any(
      (blocked) => DateUtils.isSameDay(blocked, date),
    );

    if (isEditing && widget.booking != null) {
      DateTime currentStart = DateTime.parse(widget.booking!.startDate);
      DateTime currentEnd = DateTime.parse(widget.booking!.endDate);

      bool isPartCurrentBooking =
          (date.isAfter(currentStart.subtract(const Duration(days: 1))) &&
          date.isBefore(currentEnd.add(const Duration(days: 1))));

      if (isPartCurrentBooking) return true;
    }

    return !isBlocked;
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().add(
        const Duration(days: 1),
      ), //? from tomorrow not today
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedRange,
      selectableDayPredicate: (DateTime date, DateTime? _, DateTime? _) =>
          _isDayAvailable(date),
    );

    if (picked == null) return;

    bool hasBlockedDateInRange = false;
    for (int i = 0; i <= picked.end.difference(picked.start).inDays; i++) {
      DateTime current = picked.start.add(Duration(days: i));
      if (!_isDayAvailable(current)) {
        hasBlockedDateInRange = true;
        break;
      }
    }

    if (hasBlockedDateInRange) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected Dates Contains Unavailable Dates.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _selectedRange = picked);
  }

  int get nights => (_selectedRange?.duration.inDays ?? 0) + 1;
  double get total {
    final price =
        widget.apartment?.pricePerNight ??
        widget.booking?.apartment.pricePerNight ??
        0;
    return price * (nights == 0 ? 0 : nights.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.apartment ?? widget.booking?.apartment;
    if (apt == null) return const Scaffold(body: Center(child: Text("Error")));

    return Scaffold(
      appBar: AppBar(
        title: Text(locale['appBarTitle'] ?? 'Booking Details'),
        centerTitle: true,
      ),
      body: _isLoadingDates
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildApartmentHeader(apt),
                const SizedBox(height: 24),
                _buildDateRangePickerTile(),
                const SizedBox(height: 20),
                // _buildPaymentDropdown(),
                const SizedBox(height: 32),
                _buildPriceSummary(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).cardColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _selectedRange == null
                        ? null
                        : () async {
                            bool success;
                            if (isEditing) {
                              success =
                                  await UserUpdateBookingService.updateBooking(
                                    context: context,
                                    bookingId: widget.booking!.id.toString(),
                                    startDate: _selectedRange!.start,
                                    endDate: _selectedRange!.end,
                                  );
                            } else {
                              success =
                                  await CreateBookingService.createBooking(
                                    context: context,
                                    apartmentId: apt.id.toString(),
                                    startDate: _selectedRange!.start,
                                    endDate: _selectedRange!.end,
                                  );
                            }

                            if (success && mounted) {
                              Navigator.pop(context);
                            }
                          },
                    child: Text(
                      isEditing
                          ? locale['Update'] ?? 'Update Booking'
                          : locale['Confirm'] ?? 'Confirm Booking',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isEditing) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        bool success =
                            await UserUpdateBookingService.updateBooking(
                              context: context,
                              bookingId: widget.booking!.id.toString(),
                              status: 'cancelled',
                            );

                        if (success && mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            BookingsScreen.routeName,
                            (route) => route.isFirst,
                          );
                        }
                      },
                      child: Text(
                        locale['Cancel'] ?? 'Cancel Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildApartmentHeader(Apartment apt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            apt.imagePath,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 220,
              color: Colors.grey[200],
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          apt.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          '${apt.governorate?.localized(context)},${apt.city?.localized(context)}',
          // ??"Unknown location",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDateRangePickerTile() {
    final bool hasDate = _selectedRange != null;
    var theme = Theme.of(context);
    return InkWell(
      onTap: _pickDateRange,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasDate ? theme.primaryColor : theme.cardColor,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: theme.primaryColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasDate
                      ? "${DateFormat('MMM d').format(_selectedRange!.start)} - ${DateFormat('MMM d, yyyy').format(_selectedRange!.end)}"
                      : locale['Select'] ?? "Select Dates",
                  style: TextStyle(
                    fontWeight: hasDate ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  hasDate
                      ? "$nights ${locale['nights'] ?? 'nights'}"
                      : locale['CheckInOut'] ?? "Check-in to Check-out",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.edit, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locale['Total'] ?? "Total Price",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            "\$${total.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
