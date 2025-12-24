import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:staybay/consetans.dart';

class LoginService {
  static Future<Response?> logIn(context, String phone, String password) async {
    final Dio dio = Dio();

    final String login = '/user/login';

    dio.options.baseUrl = kBaseUrl;
    try {
      final response = await dio.post(
        login,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {"phone": phone, "password": password},
      );

      log('Response data: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.data['message'] ?? 'Login successful'),
          backgroundColor: Colors.green,
        ),
      );
      return response;
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.response!.data['message'] ?? 'Invalid credentials'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}
