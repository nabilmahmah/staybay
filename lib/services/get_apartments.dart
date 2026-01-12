import 'package:dio/dio.dart';
import 'package:staybay/core/dio_client.dart';

class GetApartmentService {
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
    int? rooms,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    Dio dio = DioClient.dio;
    dio.options.headers['Accept'] = 'application/json';
    final response = await dio.get(
      '/apartments',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'governorate_id': governorateId,
        'city_id': cityId,
        'rooms': rooms,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'price_min': priceMin,
        'price_max': priceMax,
        'size_min': sizeMin,
        'size_max': sizeMax,
        'rating_min': ratingMin,
        'rating_max': ratingMax,
        'has_pool': hasPool == null ? null : (hasPool ? 1 : 0),
        'has_wifi': hasWifi == null ? null : (hasWifi ? 1 : 0),
        'search': search,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      }..removeWhere((k, v) => v == null),
    );

    return response.data;
  }
}
