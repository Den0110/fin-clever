// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryItem _$HistoryItemFromJson(Map<String, dynamic> json) => HistoryItem(
      MyDateUtils.dateFromJson(json['date'] as int),
      (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$HistoryItemToJson(HistoryItem instance) =>
    <String, dynamic>{
      'date': MyDateUtils.dateToJson(instance.date),
      'price': instance.price,
    };
