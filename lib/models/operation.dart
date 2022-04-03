import 'package:fin_clever/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../fin_clever_icons_icons.dart';
import 'account.dart';

part 'operation.g.dart';

@JsonEnum()
enum OperationType {
  @JsonValue('expense')
  expense,
  @JsonValue('income')
  income,
}

class OperationCategory {
  final String key;
  final String name;
  final IconData icon;

  OperationCategory(this.key, this.name, this.icon);
}

final List<OperationCategory> expenseCategories = [
  OperationCategory('car', 'Машина', FinCleverIcons.ic_car),
  OperationCategory(
      'restaurants', 'Кафе и рестораны', FinCleverIcons.ic_restaurants),
  OperationCategory('fare', 'Проезд', FinCleverIcons.ic_travel),
  OperationCategory('products', 'Продукты', FinCleverIcons.ic_foodstuff),
  OperationCategory(
      'entertainments', 'Развлечения', FinCleverIcons.ic_entertainments),
  OperationCategory('clothes', 'Одежда', FinCleverIcons.ic_clothes),
];

final List<OperationCategory> incomeCategories = [
  OperationCategory('work', 'Работа', Icons.work),
  OperationCategory('scholarship', 'Стипендия', Icons.school),
];

@JsonSerializable()
class Operation extends ChangeNotifier {
  final OperationType type;

  Operation.create(this.type);

  Operation(this.type, this.id, this.value, this.category, this.accountId,
      this.date, this.place, this.note);

  int id = 0;
  double value = 0.0;
  String category = "";
  int accountId = -1;
  @JsonKey(fromJson: MyDateUtils.dateFromJson, toJson: MyDateUtils.dateToJson)
  DateTime date = DateTime.now();
  String place = "";
  String note = "";
  @JsonKey(includeIfNull: false)
  Account? account;

  @JsonKey(ignore: true)
  int get selectedCategoryIndex {
    switch (type) {
      case OperationType.expense:
        return expenseCategories.indexWhere((e) => e.key == category);
      case OperationType.income:
        return incomeCategories.indexWhere((e) => e.key == category);
    }
  }

  @JsonKey(ignore: true)
  OperationCategory get categoryProps {
    switch (type) {
      case OperationType.expense:
        return expenseCategories.firstWhere((e) => e.key == category);
      case OperationType.income:
        return incomeCategories.firstWhere((e) => e.key == category);
    }
  }

  void selectCategory(int index) {
    switch (type) {
      case OperationType.expense:
        category = expenseCategories[index].key;
        break;
      case OperationType.income:
        category = incomeCategories[index].key;
        break;
    }
    notifyListeners();
  }

  void selectAccount(int id) {
    accountId = id;
    account = null;
    notifyListeners();
  }

  void selectDate(DateTime d) {
    date = date.copyWith(year: d.year, month: d.month, day: d.day);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Operation{type: $type, value: $value, category: $category, '
        'accountId: $accountId, date: $date, place: $place, note: $note}';
  }

  factory Operation.fromJson(Map<String, dynamic> json) =>
      _$OperationFromJson(json);

  Map<String, dynamic> toJson() => _$OperationToJson(this);
}
