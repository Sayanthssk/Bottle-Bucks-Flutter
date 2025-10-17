import 'package:dio/dio.dart';
import 'loginapi.dart'; // for baseUrl and loginId

Future<Map<String, dynamic>> fetchGifts() async {
  final dio = Dio();

  try {
    final response = await dio.get('$baseUrl/api/gifts/');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Fetch Success: ${response.data}');
      return Map<String, dynamic>.from(response.data);
    } else {
      print('Fetch Failed: ${response.data}');
      return {};
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print('Error Response: ${e.response?.data}');
    } else {
      print('Error: $e');
    }
    return {};
  } catch (e) {
    print('Unexpected Error: $e');
    return {};
  }
}
