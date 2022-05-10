import 'dart:math';

import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/models/operation.dart';
import 'package:fin_clever/models/potential_profit_request.dart';
import 'package:fin_clever/models/provider/current_user.dart';
import 'package:fin_clever/utils/date.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/provider/operations.dart';
import '../services/portfolio_service.dart';
import '../utils/constants.dart';
import 'options_dialog.dart';

class DayEntry {
  DateTime date;
  final List<Operation> operations;
  bool isFirstDayOfMonth = false;

  DayEntry(this.date, this.operations);
}

class DayOfOperationsItem extends StatefulWidget {
  const DayOfOperationsItem(
      {Key? key, required this.dayEntry, required this.onDelete})
      : super(key: key);

  static final PortfolioService portfolioService = PortfolioService();

  static final recommendations = [
    'Не потратив так много на {cat}, вы могли бы заработать {investSum}, инвестируя в растущие компании',
    'Вы упустили доход {investSum}, потратя деньги на {cat}',
    'Могли вложить {sum} в акции и заработать {investSum}',
    'Фондовый рынок мог бы превратить Ваши {sum} в {investSum}'
  ];

  final Function onDelete;
  final DayEntry dayEntry;

  @override
  State<DayOfOperationsItem> createState() => _DayOfOperationsItemState();
}

class _DayOfOperationsItemState extends State<DayOfOperationsItem> {
  String? recommendation;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, getRecs);
  }

  void getRecs() {
    buildRecommendation(context, widget.dayEntry).then((p) => {
          setState(() {
            recommendation = p;
          })
        });
  }

  Future<String?> buildRecommendation(
      BuildContext context, DayEntry day) async {
    if (!day.isFirstDayOfMonth) return null;

    var user = context.read<CurrentUser>().user;
    final operations = context.read<Operations>().operations;
    var junkCats = user?.junkCategories?.split(',');
    var junkLimit = user?.junkLimit;

    if (junkCats == null ||
        junkCats.isEmpty ||
        junkLimit == null ||
        junkLimit == 0) {
      return null;
    }

    var junkExpenses = operations.where((e) =>
        e.type == OperationType.expense &&
        e.date.formatMY() == day.date.formatMY() &&
        junkCats.contains(e.category));

    if (junkExpenses.isEmpty) return null;

    var sum = junkExpenses.map((e) => e.value).reduce((a, b) => a + b);
    if (sum < junkLimit) return null;

    var investSum = await DayOfOperationsItem.portfolioService
        .getPotentialProfit(PotentialProfitRequest(day.date, sum));

    var cats = junkCats
        .map((e) => expenseCategories
            .firstWhere((c) => c.key == e,
                orElse: () => OperationCategory("", "", FinCleverIcons.ic_name))
            .name)
        .where((e) => e.isNotEmpty);

    return DayOfOperationsItem.recommendations[
            Random(day.operations.length).nextInt(DayOfOperationsItem.recommendations.length)]
        .replaceFirst('{sum}', sum.formatMoney())
        .replaceFirst('{investSum}', investSum.formatMoney())
        .replaceFirst('{cat}', cats.join(', ').toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (recommendation != null) ...[
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
                        widget.dayEntry.date.formatMY(),
                        style: FinFont.bold
                            .copyWith(fontSize: 12, color: FinColor.mainColor),
                      ),
                    ],
                  ),
                  Text(
                    recommendation!,
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
                  widget.dayEntry.date.formatDate(),
                  style: FinFont.bold.copyWith(fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.dayEntry.operations.length,
                    itemBuilder: (c, i) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final options = ['Удалить'];
                        final selected =
                            await showOptionsDialog(context, options);
                        switch (selected) {
                          case 0:
                            widget.onDelete(widget.dayEntry.operations[i].id);
                        }
                      },
                      child: operation(widget.dayEntry.operations[i]),
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
