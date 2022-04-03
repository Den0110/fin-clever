import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static const String _baseUrl = 'https://finclever.azurewebsites.net/api';
  static const String _debugBaseUrl = 'https://192.168.0.248:5001/api';

  String? token;
  Dio? dio;

  Future<Dio> getDio() async {
    if (dio != null && token == await FirebaseAuth.instance.currentUser?.getIdToken()) {
      return dio!;
    }
    token = await FirebaseAuth.instance.currentUser?.getIdToken();
    dio = Dio(BaseOptions(
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer $token",
      },
      baseUrl: kReleaseMode ? _baseUrl : _debugBaseUrl,
    ));
    dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
    return dio!;
  }
}
