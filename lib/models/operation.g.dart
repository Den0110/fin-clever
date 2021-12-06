// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operation _$OperationFromJson(Map<String, dynamic> json) => Operation(
      $enumDecode(_$OperationTypeEnumMap, json['type']),
      json['id'] as int,
      (json['value'] as num).toDouble(),
      json['category'] as String,
      json['accountId'] as int,
      Operation._dateFromJson(json['date'] as int),
      json['place'] as String,
      json['note'] as String,
    )..account = json['account'] == null
        ? null
        : Account.fromJson(json['account'] as Map<String, dynamic>);

Map<String, dynamic> _$OperationToJson(Operation instance) {
  final val = <String, dynamic>{
    'type': _$OperationTypeEnumMap[instance.type],
    'id': instance.id,
    'value': instance.value,
    'category': instance.category,
    'accountId': instance.accountId,
    'date': Operation._dateToJson(instance.date),
    'place': instance.place,
    'note': instance.note,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('account', instance.account);
  return val;
}

const _$OperationTypeEnumMap = {
  OperationType.expense: 'expense',
  OperationType.income: 'income',
};
