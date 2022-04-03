import 'package:json_annotation/json_annotation.dart';

part 'stock.g.dart';

@JsonSerializable()
class Stock {
  String ticker;
  String companyName;
  double usdPurchasePrice;
  double purchasePrice;
  double currentPrice;
  int amount;

  Stock(this.ticker, this.companyName, this.usdPurchasePrice, this.purchasePrice,
      this.currentPrice, this.amount);

  double totalPurchasePrice() {
    return purchasePrice * amount;
  }

  double totalCurrentPrice() {
    return currentPrice * amount;
  }

  double difference() {
    return (currentPrice / purchasePrice - 1) * 100.0;
  }

  factory Stock.fromJson(Map<String, dynamic> json) =>
      _$StockFromJson(json);

  Map<String, dynamic> toJson() => _$StockToJson(this);
}