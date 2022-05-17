import 'dart:convert';
import 'package:fin_clever/data/models/account.dart';
import 'package:fin_clever/data/services/api_service.dart';
import 'package:flutter/foundation.dart';

class AccountService extends ApiService {
  Future<List<Account>> loadAccounts() async {
    var dio = await getDio();
    var response = await dio.get('/accounts');
    return List<Account>.from(response.data.map((i) => Account.fromJson(i)));
  }

  Future<bool> createAccount(Account account) async {
    debugPrint(jsonEncode(account));
    try {
      var dio = await getDio();
      var response = await dio.post(
        '/accounts',
        data: jsonEncode(account),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

}