import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:staybay/core/dio_client.dart';
import 'package:staybay/constants.dart';
import 'package:staybay/models/apartment_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class UpdateApartmentService {
  static Future<Response?> updateApartment({
    required BuildContext context,
    required Apartment apartment,
    required int cityId,
    required List<int> deletedImageIds,
    String? newCoverPath,
    List<String>? newGalleryPaths,
  }) async {
    final Dio dio = DioClient.dio;
    final token = DioClient.token;
    if (token == null) {
      // _showError(context, 'Not authenticated'); //! will solve it later
      return null;
    }

    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString(kToken);

    if (token == null) return null;

    // final Dio dio = Dio();
    dio.options.baseUrl = kBaseUrl;
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    try {
      final Map<String, dynamic> data = {
        '_method': 'PUT',
        'city_id': cityId,
        'title': apartment.title,
        'description': apartment.description,
        'price': apartment.pricePerNight,
        'bathrooms': apartment.baths,
        'bedrooms': apartment.beds,
        'size': apartment.areaSqft.toInt(),
        'has_pool': apartment.amenities.contains('pool') ? 1 : 0,
        'has_wifi': apartment.amenities.contains('wifi') ? 1 : 0,
      };

      if (newCoverPath != null &&
          newCoverPath.isNotEmpty &&
          !newCoverPath.startsWith('http')) {
        log(newCoverPath);
        data['cover_image'] = await MultipartFile.fromFile(newCoverPath);
      }

      if (newGalleryPaths != null && newGalleryPaths.isNotEmpty) {
        List<MultipartFile> galleryFiles = [];
        for (String path in newGalleryPaths) {
          galleryFiles.add(await MultipartFile.fromFile(path));
        }
        data['new_images[]'] = galleryFiles;
      }

      if (deletedImageIds.isNotEmpty) {
        data['delete_images[]'] = deletedImageIds; //! its delete not deletd :)
      }
      log('Update Apartment Data: $data');
      final formData = FormData.fromMap(data);

      final response = await dio.post(
        '/apartments/${apartment.id}',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      log(response.data.toString());
      return response;
    } on DioException catch (e) {
      log('Update Error Response: ${e.response?.data}');
      return e.response;
    } catch (e) {
      log('Unexpected Service Error: $e');
      return null;
    }
  }
}
