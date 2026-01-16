import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staybay/constants.dart';
import 'package:staybay/core/dio_client.dart';
import 'package:staybay/models/notification_model.dart';

class ApiNotificationService {
  // ApiNotificationService();
  static Dio dio = DioClient.dio;

  static Future<List<NotificationModel>> fetchUnread() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(kToken);

      if (token == null || token.isEmpty) {
        log('fetchUnread: token is null, skipping');
        return [];
      }
      final dio = Dio(
        BaseOptions(
          baseUrl: kBaseUrl,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final response = await dio.get('/user/notifications');

      if (response.data == null ||
          response.data['unread'] == null ||
          response.data['unread'] is! List) {
        return [];
      }

      final List list = response.data['unread'];

      return list
          .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e, s) {
      log('fetchUnread ERROR: $e');
      log(s.toString());
      return [];
    }
  }

  static Future<List<NotificationModel>> fetchRead() async {
    try {
      final response = await dio.get('/user/notifications');
      if (response.data == null || response.data['read'] == null) return [];
      final List data = response.data['read'];
      // log(data.toString());
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // Log error instead of throwing
      log('DioException fetchRead: ${e.response?.data ?? e.message}');
      return [];
    } catch (e) {
      log('Unexpected error fetchRead: $e');
      return [];
    }
  }

  static Future<List<dynamic>> fetchAll() async {
    try {
      final response = await dio.get('/user/notifications');
      final List data = response.data['unread'];
      data.addAll(response.data['read']);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      log('${DioClient.token}');
      log('DioException fetchAll: ${e.response?.data ?? e.message}');
      return [];
    } catch (e) {
      log('Unexpected error fetchAll: $e');
      return [];
    }
  }

  static Future<void> markAllAsRead() async {
    try {
      await dio.post('/user/notifications');
    } on DioException catch (e) {
      log('DioException markAllAsRead: ${e.response?.data ?? e.message}');
    } catch (e) {
      log('Unexpected error markAllAsRead: $e');
    }
  }

  static Future<void> markAsRead(id) async {
    try {
      await dio.post('/user/notifications/$id/read');
    } on DioException catch (e) {
      log('DioException mark as read: ${e.response?.data ?? e.message}');
    } catch (e) {
      log('Unexpected error mark as read: $e');
    }
  }
}
