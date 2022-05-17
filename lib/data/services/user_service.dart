import 'dart:convert';

import 'package:fin_clever/data/models/app_user.dart';

import 'api_service.dart';

class UserService extends ApiService {
  Future<AppUser> loadUser() async {
    var dio = await getDio();
    var response = await dio.get('/users/me');
    return AppUser.fromJson(response.data);
  }

  Future updateUser(AppUser user) async {
    var dio = await getDio();
    var response = await dio.put('/users/me', data: jsonEncode(user));
    return response.statusCode == 204;
  }

  Future<bool> login() async {
    var dio = await getDio();
    var response = await dio.post('/users/login');
    return response.statusCode == 204;
  }

  Future<AppUser> signUp(AppUser user) async {
    var dio = await getDio();
    var response = await dio.post('/users/signup', data: jsonEncode(user));
    return AppUser.fromJson(response.data);
  }
}
