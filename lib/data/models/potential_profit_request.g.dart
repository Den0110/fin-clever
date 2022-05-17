// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'potential_profit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PotentialProfitRequest _$PotentialProfitRequestFromJson(
        Map<String, dynamic> json) =>
    PotentialProfitRequest(
      MyDateUtils.dateFromJson(json['date'] as int),
      (json['sum'] as num).toDouble(),
    );

Map<String, dynamic> _$PotentialProfitRequestToJson(
        PotentialProfitRequest instance) =>
    <String, dynamic>{
      'date': MyDateUtils.dateToJson(instance.date),
      'sum': instance.sum,
    };
