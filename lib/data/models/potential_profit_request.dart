import 'package:fin_clever/utils/date.dart';
import 'package:json_annotation/json_annotation.dart';

part 'potential_profit_request.g.dart';

@JsonSerializable()
class PotentialProfitRequest {
  @JsonKey(fromJson: MyDateUtils.dateFromJson, toJson: MyDateUtils.dateToJson)
  DateTime date = DateTime.now();
  double sum = 0;

  PotentialProfitRequest(this.date, this.sum);

  factory PotentialProfitRequest.fromJson(Map<String, dynamic> json) =>
      _$PotentialProfitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PotentialProfitRequestToJson(this);
}