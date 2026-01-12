import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:staybay/core/dio_client.dart';

class CreateBookingService {
  static Future<bool> createBooking({
    required BuildContext context,
    required String apartmentId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    Dio dio = DioClient.dio;
    String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);

    try {
      FormData formData = FormData.fromMap({
        'apartment_id': apartmentId,
        'start_date': formattedStart,
        'end_date': formattedEnd,
      });

      var response = await dio.post(
        '/bookings',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data['message'] ?? 'Booking created successfully.',
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
      } else if (e.response?.data is String) {
        errorMessage = e.response?.data;
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
