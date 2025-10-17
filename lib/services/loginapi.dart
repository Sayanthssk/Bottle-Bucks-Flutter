import 'package:bottlebucks/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const String baseUrl = "http://192.168.1.36:5000"; 
int? loginId; 
String? userType; 

Future<void> login(String username, String password, context) async {
  final dio = Dio();



  try {
    final response = await dio.post(
      '$baseUrl/api/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Login Success: ${response.data}');

      loginId = response.data['login_id'];
      userType = response.data['UserType'];

      if (userType == "USER"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
      }
      else {
        print("invalid user type make sure verified");
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification Pending")),
      );
      }
      
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
