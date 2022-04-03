import 'package:json_annotation/json_annotation.dart';
import '../../utils/date.dart';

part 'history_item.g.dart';

@JsonSerializable()
class HistoryItem {
  @JsonKey(fromJson: MyDateUtils.dateFromJson, toJson: MyDateUtils.dateToJson)
  DateTime date;
  double price;

  HistoryItem(this.date, this.price);

  factory HistoryItem.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryItemToJson(this);
}