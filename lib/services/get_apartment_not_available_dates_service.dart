import 'dart:developer';

import 'package:dio/dio.dart';
// import 'package:staybay/constants.dart';
import 'package:staybay/core/dio_client.dart';

class GetApartmentNotAvailableDatesService {
  static Future<List<DateTime>> getDisabledDates(String? apartmentId) async {
    final List<DateTime> disabledDates = [];
    try {
      Dio dio = DioClient.dio;

      var response = await dio.get(
        '/apartments/$apartmentId/not-avaliable-dates',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      List<dynamic> data = response.data['data'];

      for (var range in data) {
        DateTime start = DateTime.parse(range['start_date']);
        DateTime end = DateTime.parse(range['end_date']);

        for (int i = 0; i <= end.difference(start).inDays; i++) {
          disabledDates.add(start.add(Duration(days: i)));
        }
      }
      return disabledDates;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
