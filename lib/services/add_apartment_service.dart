import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:staybay/core/dio_client.dart';
import 'package:staybay/models/apartment_model.dart';

class AddApartmentService {
  static Future<Response?> addApartment({
    required BuildContext context,
    required Apartment apartment,
    required int cityId,
  }) async {
    final dio = DioClient.dio;
    final token = DioClient.token;
    dio.options.headers['Accept'] = 'application/json';
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
    try {
      final formData = FormData.fromMap({
        'city_id': cityId,
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
