import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:staybay/core/dio_client.dart';
import 'package:staybay/models/apartment_model.dart';

class GetApartmentService {
  static Dio dio = DioClient.dio;

  static Future<List<Apartment>> getFavorites() async {
    List<Apartment> favoriteApartments = [];

    try {
      var response = await dio.get(
        '/apartments/favorite',
        options: Options(headers: {'Accept': 'application/json'}),
      );
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
    try {
      var response = await dio.get('/apartments/my');
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
