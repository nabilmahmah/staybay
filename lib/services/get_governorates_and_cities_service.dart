import 'package:dio/dio.dart';
import 'package:staybay/core/dio_client.dart';
import 'package:staybay/models/city_model.dart';
import 'package:staybay/models/governorate_model.dart';

class GetGovernatesAndCities {
  final Dio _dio = DioClient.dio;

  Future<List<Governorate>> getGovernorates() async {
    try {
      final response = await _dio.get('/governorates');
      if (response.statusCode == 200) {
        List data = response.data['data'];
        return data.map((json) => Governorate.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('there was a problem fetching governorates');
    }
  }

  Future<List<City>> getCities(int governorateId) async {
    try {
      final response = await _dio.get(
        '/governorates/$governorateId',
        options: Options(headers: {'Accept': 'application/json'}),
      );
      if (response.statusCode == 200) {
        List data = response.data['data']['cities'];
        return data.map((json) => City.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('there was a problem fetching cities');
    }
  }
}
