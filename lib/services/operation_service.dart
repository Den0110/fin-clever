import 'package:fin_clever/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:fin_clever/models/operation.dart';
import 'dart:convert';

class OperationService extends ApiService {
  Future<bool> createOperation(Operation operation) async {
    debugPrint(jsonEncode(operation));
    try {
      var response = await dio.post(
        '/operations',
        data: jsonEncode(operation),
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      return response.statusCode == 201;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<Operation>> loadOperations() async {
    var response = await dio.get('/operations');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.data}');
    return List<Operation>.from(response.data.map((i) => Operation.fromJson(i)));
  }
}
