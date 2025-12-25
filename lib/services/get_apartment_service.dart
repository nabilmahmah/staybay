import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staybay/consetans.dart';
import 'package:staybay/models/apartment_model.dart';

class GetApartmentService {
  static Future<List<Apartment>> getFavorites() async {
    List<Apartment> favoriteApartments = [];
    final prefs = await SharedPreferences.getInstance();

    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] =
          'Bearer ${prefs.getString(kToken)}';

      var response = await dio.get('${kBaseUrl}/apartments/favorite');
      dynamic jsonData = response.data;
      List<dynamic> apartmentsJson = jsonData['data'];
      for (var apartmentJson in apartmentsJson) {
        Apartment apartment = Apartment.fromJson(apartmentJson);
        favoriteApartments.add(apartment);
      }
      return favoriteApartments;
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      return favoriteApartments;
    } catch (e) {
      return favoriteApartments;
    }
  }

  static Future<List<Apartment>> getMy() async {
    List<Apartment> favoriteApartments = [];
    final prefs = await SharedPreferences.getInstance();

    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] =
          'Bearer ${prefs.getString(kToken)}';

      var response = await dio.get('${kBaseUrl}/apartments/my');
      dynamic jsonData = response.data;
      List<dynamic> apartmentsJson = jsonData['data'];
      for (var apartmentJson in apartmentsJson) {
        Apartment apartment = Apartment.fromJson(apartmentJson);
        favoriteApartments.add(apartment);
      }
      return favoriteApartments;
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      return favoriteApartments;
    } catch (e) {
      return favoriteApartments;
    }
  }
}
