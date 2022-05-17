import 'package:fin_clever/data/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:fin_clever/data/models/operation.dart';
import 'dart:convert';

class OperationService extends ApiService {
  Future<bool> createOperation(Operation operation) async {
    debugPrint(jsonEncode(operation));
    try {
      var dio = await getDio();
      var response = await dio.post(
        '/operations',
        data: jsonEncode(operation),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<Operation>> loadOperations() async {
    var dio = await getDio();
    var response = await dio.get('/operations');
    return List<Operation>.from(response.data.map((i) => Operation.fromJson(i)));
  }

  Future<bool> deleteOperation(int operationId) async {
    var dio = await getDio();
    var response = await dio.delete('/operations/$operationId');
    return response.statusCode == 204;
  }
}
