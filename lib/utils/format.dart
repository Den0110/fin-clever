import 'dart:ui';

import 'package:intl/intl.dart';

import 'constants.dart';

extension DoubleMoneyFormatter on double {
  String formatMoney({String currency = "₽"}) {
    final moneyFormat = NumberFormat("#,##0$currency", "en_US");
    return moneyFormat.format(this);
  }

  String formatPercentDifference() {
    var s = '';
    if (this > .0) {
      s += '+';
    }
    final format = NumberFormat("#.##", "en_US");
    s += format.format(this) + '%';
    return s;
  }

  Color priceColor() {
    if(this > 0) {
      return FinColor.green;
    } else if(this == 0) {
      return FinColor.darkBlue;
    } else {
      return FinColor.red;
    }
  }
}

extension IntMoneyFormatter on int {
  String formatMoney() {
    final moneyFormat = NumberFormat("#,##0₽", "en_US");
    return moneyFormat.format(this);
  }
}