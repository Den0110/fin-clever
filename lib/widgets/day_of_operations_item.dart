import 'package:fin_clever/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class DayEntry {
  final String date;
  final List<Operation> operations;

  DayEntry(this.date, this.operations);
}

class DayOfOperationsItem extends StatelessWidget {
  const DayOfOperationsItem({Key? key, required this.dayEntry})
      : super(key: key);

  final DayEntry dayEntry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      shadowColor: const Color(0x33000000),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayEntry.date,
              style: FinFont.bold.copyWith(fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dayEntry.operations.length,
                itemBuilder: (c, i) => operation(dayEntry.operations[i]),
                separatorBuilder: (c, i) => divider,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row operation(Operation operation) {
    Color color;
    double value = .0;
    final DateFormat formatter = DateFormat('HH:mm');
    String time = formatter.format(operation.date);
    if (operation.type == OperationType.expense) {
      value = -operation.value;
      color = FinColor.red;
    } else {
      value = operation.value;
      color = FinColor.green;
    }
    String subtitle = "";
    if (operation.account?.name != null) {
      subtitle = operation.account!.name;
    } else {
      subtitle = operation.place;
    }
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: FinColor.iconBg,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Icon(
            operation.categoryProps.icon,
            size: 20,
            color: FinColor.darkBlue,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  operation.categoryProps.name,
                  style: FinFont.medium.copyWith(fontSize: 14),
                ),
                Text(subtitle, style: FinFont.regular.copyWith(fontSize: 12)),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$value₽',
              style: FinFont.semibold.copyWith(
                fontSize: 14,
                color: color,
              ),
            ),
            Text(
              time,
              style: FinFont.regular.copyWith(fontSize: 12),
            ),
          ],
        )
      ],
    );
  }

  static const Divider divider = Divider(
    height: 24,
    thickness: .5,
    color: Color(0xFFEFEFEF),
  );
}
