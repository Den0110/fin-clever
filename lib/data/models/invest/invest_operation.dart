import 'package:fin_clever/utils/date.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invest_operation.g.dart';

@JsonSerializable()
class InvestOperation {
  int id = 0;
  @JsonKey(fromJson: MyDateUtils.dateFromJson, toJson: MyDateUtils.dateToJson)
  DateTime date = DateTime.now();
  String ticker = "";
  double price = .0;
  int amount = 0;

  double totalPrice() {
    return price * amount;
  }

  InvestOperation(this.id, this.date, this.ticker, this.price, this.amount);

  factory InvestOperation.fromJson(Map<String, dynamic> json) =>
      _$InvestOperationFromJson(json);

  Map<String, dynamic> toJson() => _$InvestOperationToJson(this);
}
