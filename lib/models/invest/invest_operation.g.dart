// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invest_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestOperation _$InvestOperationFromJson(Map<String, dynamic> json) =>
    InvestOperation(
      json['id'] as int,
      MyDateUtils.dateFromJson(json['date'] as int),
      json['ticker'] as String,
      (json['price'] as num).toDouble(),
      json['amount'] as int,
    );

Map<String, dynamic> _$InvestOperationToJson(InvestOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': MyDateUtils.dateToJson(instance.date),
      'ticker': instance.ticker,
      'price': instance.price,
      'amount': instance.amount,
    };
