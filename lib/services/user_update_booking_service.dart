import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:staybay/core/dio_client.dart';

class UserUpdateBookingService {
  static Future<bool> updateBooking({
    required BuildContext context,
    required String bookingId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    Dio dio = DioClient.dio;

    Map<String, dynamic> dataMap = {};

    if (status != null) {
      dataMap['status'] = status;
    } else if (startDate != null && endDate != null) {
      dataMap['start_date'] = DateFormat('yyyy-MM-dd').format(startDate);
      dataMap['end_date'] = DateFormat('yyyy-MM-dd').format(endDate);
    }

    try {
      FormData formData = FormData.fromMap(dataMap);

      var response = await dio.put(
        '/bookings/update/user/$bookingId',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data['message'] ?? 'Booking updated successfully.',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      log("Dio Error: ${e.type}");
      log("Response Data: ${e.response?.data}");

      String errorMessage = 'An unexpected error occurred';

      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
      return false;
    } catch (e) {
      log("General Error: $e");
      return false;
    }
  }
}
