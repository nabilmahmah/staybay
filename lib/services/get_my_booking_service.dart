import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:staybay/core/dio_client.dart';
import 'package:staybay/models/book_model.dart';

class GetMyBookingService {
  static Future<List<BookModel>> getMyBooking() async {
    try {
      Dio dio = DioClient.dio;

      var response = await dio.get(
        '/bookings',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<BookModel> myBooking = [];
        final Map<String, dynamic> jsonData = response.data;
        final List<dynamic> booksJson = jsonData['data'];

        for (var bookJson in booksJson) {
          try {
            myBooking.add(BookModel.fromJson(bookJson));
          } catch (itemError) {
            log('Error parsing a specific booking item: $itemError');
            log('Failing JSON: $bookJson');
          }
        }
        return myBooking;
      } else {
        log('Server returned status: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      log('General error in GetMyBookingService: $e');
      rethrow;
    }
  }
}
