import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staybay/consetans.dart';

class ApartmentService {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: kBaseUrl, headers: {'Accept': 'application/json'}),
  );

  static Future<Map<String, dynamic>> getApartments({
    int page = 1,
    int perPage = 10,
    int? governorateId,
    int? cityId,
    String? bedrooms,
    String? bathrooms,
    double? priceMin,
    double? priceMax,
    double? sizeMin,
    double? sizeMax,
    double? ratingMin,
    double? ratingMax,
    bool? hasPool,
    bool? hasWifi,
    String? search,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(kToken);

    final response = await _dio.get(
      '/apartments',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'governorate_id': governorateId,
        'city_id': cityId,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'price_min': priceMin,
        'price_max': priceMax,
        'size_min': sizeMin,
        'size_max': sizeMax,
        'rating_min': ratingMin,
        'rating_max': ratingMax,
        'has_pool': hasPool == true ? 1 : null,
        'has_wifi': hasWifi == true ? 1 : null,
        'search': search,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      }..removeWhere((key, value) => value == null),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
