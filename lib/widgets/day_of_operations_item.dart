import 'package:fin_clever/bloc/day_entry.dart';
import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/data/models/operation.dart';
import 'package:fin_clever/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import 'options_dialog.dart';

class DayOfOperationsItem extends StatelessWidget {
  const DayOfOperationsItem(
      {Key? key, required this.dayEntry, required this.onDelete})
      : super(key: key);

  final Function onDelete;
  final DayEntry dayEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dayEntry.recommendation != null) ...[
          Card(
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          FinCleverIcons.ic_investment,
                          size: 12,
                          color: FinColor.mainColor,
                        ),
                      ),
                      Text(
                        dayEntry.date.formatMY(),
                        style: FinFont.bold
                            .copyWith(fontSize: 12, color: FinColor.mainColor),
                      ),
                    ],
                  ),
                  Text(
                    dayEntry.recommendation!,
                    style: FinFont.regular.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        ],
        Card(
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
                  dayEntry.date.formatDate(),
                  style: FinFont.bold.copyWith(fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: dayEntry.operations.length,
                    itemBuilder: (c, i) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final options = ['??????????????'];
                        final selected =
                            await showOptionsDialog(context, options);
                        switch (selected) {
                          case 0:
                            onDelete(dayEntry.operations[i].id);
                        }
                      },
                      child: operation(dayEntry.operations[i]),
                    ),
                    separatorBuilder: (c, i) => divider,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget operation(Operation operation) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                    Text(subtitle,
                        style: FinFont.regular.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$value???',
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
        ),
        if (operation.note.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              operation.note,
              style: FinFont.regular
                  .copyWith(fontSize: 12, color: FinColor.secondaryText),
            ),
          ),
        ]
      ],
    );
  }

  static const Divider divider = Divider(
    height: 24,
    thickness: .5,
    color: Color(0xFFEFEFEF),
  );
}
