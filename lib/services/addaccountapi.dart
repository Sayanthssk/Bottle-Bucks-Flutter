import 'package:bottlebucks/home.dart';
import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/services/loginapi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


Future<void> addAccount(context, data) async {
  final dio = Dio();

  try {
    final response = await dio.post(
      '$baseUrl/api/account/$loginId',
      data: data
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Added Success: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added Successfully"))
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
    } else {
      print('Login Failed: ${response.data}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print('Error Response: ${e.response?.data}');
    } else {
      print('Error: $e');
    }
  } catch (e) {
    print('Unexpected Error: $e');
  }
}
