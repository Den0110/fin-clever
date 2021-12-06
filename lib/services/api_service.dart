import 'package:dio/dio.dart';

class ApiService {
  static const String _baseUrl = 'https://finclever.azurewebsites.net/api';

  Dio dio = Dio(BaseOptions(
    headers: {
      "content-type": "application/json",
      "accept": "application/json",
    },
    baseUrl: _baseUrl,
  ));
}
