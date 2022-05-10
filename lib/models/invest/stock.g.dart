// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) => Stock(
      json['ticker'] as String,
      json['companyName'] as String,
      (json['usdPurchasePrice'] as num).toDouble(),
      (json['purchasePrice'] as num).toDouble(),
      (json['currentPrice'] as num).toDouble(),
      json['amount'] as int,
    );

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'ticker': instance.ticker,
      'companyName': instance.companyName,
      'usdPurchasePrice': instance.usdPurchasePrice,
      'purchasePrice': instance.purchasePrice,
      'currentPrice': instance.currentPrice,
      'amount': instance.amount,
    };
