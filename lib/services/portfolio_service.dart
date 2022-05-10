import 'dart:convert';
import 'package:fin_clever/models/invest/portfolio.dart';
import 'package:fin_clever/models/potential_profit_request.dart';
import 'package:fin_clever/services/api_service.dart';

import '../models/invest/invest_operation.dart';

class PortfolioService extends ApiService {
  Future<Portfolio> loadPortfolio(
      String range, bool showHistoricalProfit) async {
    var dio = await getDio();
    var response = await dio.get(
        '/invest/portfolio?range=$range&showHistoricalProfit=$showHistoricalProfit');
    return Portfolio.fromJson(response.data);
  }

  Future<List<InvestOperation>> loadInvestOperations() async {
    var dio = await getDio();
    var response = await dio.get('/invest/operations');
    return List<InvestOperation>.from(
        response.data.map((o) => InvestOperation.fromJson(o)));
  }

  Future<bool> addOperation(InvestOperation operation) async {
    var dio = await getDio();
    try {
      var response = await dio.post(
        '/invest/operations',
        data: jsonEncode(operation),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteOperation(int operationId) async {
    var dio = await getDio();
    var response = await dio.delete('/invest/operations/$operationId');
    return response.statusCode == 204;
  }

  Future<double> getPotentialProfit(PotentialProfitRequest request) async {
    var dio = await getDio();
    var response =
        await dio.post('/invest/portfolio/potentialProfit', data: jsonEncode(request));
    return double.parse(response.data.toString());
  }
}
