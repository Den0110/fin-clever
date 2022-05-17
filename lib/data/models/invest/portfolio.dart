import 'package:fin_clever/data/models/invest/stock.dart';
import 'package:json_annotation/json_annotation.dart';

import 'history_item.dart';

part 'portfolio.g.dart';

@JsonSerializable()
class Portfolio {
  double totalPrice;
  List<HistoryItem> priceHistory;
  List<Stock> stocks;

  Portfolio(this.totalPrice, this.priceHistory, this.stocks);

  factory Portfolio.fromJson(Map<String, dynamic> json) =>
      _$PortfolioFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioToJson(this);
}