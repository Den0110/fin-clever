import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonEnum(fieldRename: FieldRename.kebab)
enum AccountType { debitCard, cash, credit, brokerageAccount }

extension AccountTypeExt on AccountType {
  String get nameSingle {
    switch (this) {
      case AccountType.debitCard:
        return 'Банковская карта';
      case AccountType.cash:
        return 'Наличные';
      case AccountType.credit:
        return 'Кредит';
      case AccountType.brokerageAccount:
        return 'Брокерский счет';
    }
  }

  String get namePlural {
    switch (this) {
      case AccountType.debitCard:
        return 'Банковские карты';
      case AccountType.cash:
        return 'Наличные';
      case AccountType.credit:
        return 'Кредиты';
      case AccountType.brokerageAccount:
        return 'Брокерские счета';
    }
  }

  IconData get icon {
    switch (this) {
      case AccountType.debitCard:
        return FinCleverIcons.ic_bank_card;
      case AccountType.cash:
        return FinCleverIcons.ic_cash;
      case AccountType.credit:
        return FinCleverIcons.ic_credit;
      case AccountType.brokerageAccount:
        return FinCleverIcons.ic_brokerage_account;
    }
  }
}

@JsonSerializable()
class Account extends ChangeNotifier {
  int id = 0;
  double balance = 0;
  AccountType type = AccountType.debitCard;
  String name = "";

  Account.create();

  Account(this.id, this.balance, this.type, this.name);

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  void selectAccountType(AccountType t) {
    type = t;
    notifyListeners();
  }
}
