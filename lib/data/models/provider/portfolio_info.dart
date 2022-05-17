import 'package:flutter/material.dart';
import '../invest/portfolio.dart';

class PortfolioInfo extends ChangeNotifier {
  Portfolio? portfolio;
  String range = "M";
  bool showHistoricalProfit = false;

  void updatePortfolio(Portfolio portfolio) {
    this.portfolio = portfolio;
    notifyListeners();
  }

  void updateRange(String range) {
    this.range = range;
    notifyListeners();
  }

  void updateShowHistoricalProfit(bool showHistoricalProfit) {
    this.showHistoricalProfit = showHistoricalProfit;
    notifyListeners();
  }

  void clear() {
    portfolio = null;
    notifyListeners();
  }
}
