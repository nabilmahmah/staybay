import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:staybay/consetans.dart';

class RegisterService {
  static Future<Response?> register(
    context,
    File avatarfile,
    String firstName,
    String lastName,
    String phone,
    String password,
    String passwordCon,
    String birthDate,
    File idCardfile,
  ) async {
    final Dio dio = Dio();

    final String register = '/user/register';
    dio.options.baseUrl = kBaseUrl;
    var formData = FormData.fromMap({
      "phone": phone,
      "first_name": firstName,
      "last_name": lastName,
      "birth_date": birthDate,
      "password": password,
      "password_confirmation": passwordCon,
      "avatar": await MultipartFile.fromFile(avatarfile.path),
      "id_card": await MultipartFile.fromFile(idCardfile.path),
    });
    try {
      final response = await dio.post(
        register,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
        data: formData,
      );

      log('Response data: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.data['message'] ?? 'Registration successful'),
          backgroundColor: Colors.green,
        ),
      );
      return response;
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.response?.data['message'] ?? 'Registration failed'),
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
