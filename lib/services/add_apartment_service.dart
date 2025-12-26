import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:staybay/consetans.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddApartmentService {
  // Keep a mock list for local testing if needed
  static List<Apartment> mockApartments = [];

  static Future<Response?> addApartment({
    required BuildContext context,
    required Apartment apartment,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(kToken);

    if (token == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }

    if (apartment.imagesPaths.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one image'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }

    final Dio dio = Dio();
    dio.options.baseUrl = kBaseUrl;

    try {
      // Build multipart form data from Apartment object
      final formData = FormData.fromMap({
        'city_id': 1, // TODO: replace with apartment.cityId if available
        'title': apartment.title,
        'description': apartment.description,
        'price': apartment.pricePerNight,
        'bathrooms': apartment.baths,
        'bedrooms': apartment.beds,
        'size': apartment.areaSqft.toInt(),
        'has_pool': apartment.amenities.contains('pool') ? 1 : 0,
        'has_wifi': apartment.amenities.contains('wifi') ? 1 : 0,
        'cover_image': await MultipartFile.fromFile(
          apartment.imagesPaths.first,
          filename: apartment.imagesPaths.first.split('/').last,
        ),
        'images[]': [
          if (apartment.imagesPaths.length > 1)
            for (var i = 1; i < apartment.imagesPaths.length; i++)
              await MultipartFile.fromFile(
                apartment.imagesPaths[i],
                filename: apartment.imagesPaths[i].split('/').last,
              ),
        ],
      });

      final response = await dio.post(
        '/apartments',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      log('Apartment created: ${response.data}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message'] ?? 'Apartment created'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Add to mock list safely
      mockApartments.add(apartment);

      return response;
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.response?.data['message'] ?? 'Failed to create apartment',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } catch (e) {
      log('Unexpected error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }
}
