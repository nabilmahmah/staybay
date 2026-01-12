import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:staybay/core/dio_client.dart';

class PayBookingService {
  static Future<bool> payBooking({
    required BuildContext context,
    required String bookingId,
  }) async {
    Dio dio = DioClient.dio;

    try {
      var response = await dio.post(
        '/bookings/pay/$bookingId',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data['message'] ?? 'Payment successful.'),
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
