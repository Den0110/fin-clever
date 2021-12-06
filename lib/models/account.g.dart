// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['id'] as int,
      (json['balance'] as num).toDouble(),
      $enumDecode(_$AccountTypeEnumMap, json['type']),
      json['name'] as String,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'balance': instance.balance,
      'type': _$AccountTypeEnumMap[instance.type],
      'name': instance.name,
    };

const _$AccountTypeEnumMap = {
  AccountType.debitCard: 'debit-card',
  AccountType.cash: 'cash',
  AccountType.credit: 'credit',
  AccountType.brokerageAccount: 'brokerage-account',
};
