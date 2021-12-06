import 'dart:convert';

import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/services/api_service.dart';
import 'package:flutter/foundation.dart';

class AccountService extends ApiService {
  Future<List<Account>> loadAccounts() async {
    var response = await dio.get('/accounts');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.data}');
    return List<Account>.from(response.data.map((i) => Account.fromJson(i)));
  }

  Future<bool> createAccount(Account account) async {
    debugPrint(jsonEncode(account));
    try {
      var response = await dio.post(
        '/accounts',
        data: jsonEncode(account),
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      return response.statusCode == 201;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

}