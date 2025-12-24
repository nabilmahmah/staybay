import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staybay/consetans.dart';

class LogoutService {
  static void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kIsLoggedIn, false);
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString(kToken)}';
    try {
      await dio.post('${kBaseUrl}/user/logout');
    } catch (e) {
      log('Logout error: $e');
    }
  }
}
