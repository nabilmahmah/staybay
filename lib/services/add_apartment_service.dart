import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staybay/consetans.dart';

class AddApartmentService {
  static Future<Response?> addApartment({
    required context,
    required String title,
    required String description,
    required String cityId,
    required String price,
    required String bedrooms,
    required String bathrooms,
    required String size,
    required String hasPool,
    required String hasWifi,
    required List<XFile> imageFiles,
  }) async {
    final Dio dio = Dio();
    final String addApartment = '/apartments';
    final prefs = await SharedPreferences.getInstance();
    dio.options.baseUrl = kBaseUrl;
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString(kToken)}';

    List<MultipartFile> multipartImages = [];
    for (var file in imageFiles) {
      final bytes = await file.readAsBytes();

      multipartImages.add(MultipartFile.fromBytes(bytes, filename: file.name));
    }
    var formData = FormData.fromMap({
      'title': title,
      'description': description,
      'city_id': cityId,
      'price': price,
      'bathrooms': bathrooms,
      'bedrooms': bedrooms,
      'size': size,
      'has_pool': hasPool,
      'has_wifi': hasWifi,
      'cover_image': multipartImages.first,
      'images[]': multipartImages,
    });
    try {
      final response = await dio.post(
        addApartment,
        options: Options(headers: {'Accept': 'application/json'}),
        data: formData,
      );
      log('Response data: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.data['message'] ?? 'creation apartment successful',
          ),
          backgroundColor: Colors.green,
        ),
      );
      return response;
    } on DioException catch (e) {
      // log('Dio error: ${e.response?.data ?? e.message}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       e.response?.data['message'] ?? 'creation apartment failed',
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      log('Dio error type: ${e.type}');
      log('Dio error message: ${e.message}');
      log('Dio response: ${e.response}');
      log('Dio response data: ${e.response?.data}');
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}
