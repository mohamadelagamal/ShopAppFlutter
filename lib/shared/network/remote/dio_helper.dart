

import 'package:dio/dio.dart';

class DioHelper {
  // static Dio dio = Dio();
  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? '',
    };
    return await dio!.get(
      path,
      queryParameters: query,
    );
  }
  static void printResponse(Response response) {
    print('Response data: ${response.data}');
    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response request: ${response.requestOptions}');
  }
  static Future<Response> postData({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,

  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? '',
    };
    return await dio!.post(
      path,
      queryParameters: query,
      data: data,
    );
  }
}
