import 'package:cached_network_image/cached_network_image.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../fin_clever_icons_icons.dart';
import '../data/models/invest/invest_operation.dart';
import 'options_dialog.dart';

class InvestDayEntry {
  final String date;
  final List<InvestOperation> operations;

  InvestDayEntry(this.date, this.operations);
}

class InvestOperationItem extends StatelessWidget {
  const InvestOperationItem(
      {Key? key, required this.dayEntry, required this.onDelete})
      : super(key: key);

  final Function onDelete;
  final InvestDayEntry dayEntry;

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
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dayEntry.operations.length,
                itemBuilder: (c, i) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final options = ['Удалить'];
                    final selected = await showOptionsDialog(context, options);
                    switch (selected) {
                      case 0:
                        onDelete(dayEntry.operations[i].id);
                    }
                  },
                  child: _operation(dayEntry.operations[i]),
                ),
                separatorBuilder: (c, i) => divider,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _operation(InvestOperation investOperation) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: FinColor.iconBg,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: CachedNetworkImage(
              imageUrl:
              "https://ui-avatars.com/api?name=${investOperation.ticker}+&color=03314B",
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      investOperation.ticker,
                      style: FinFont.medium.copyWith(fontSize: 14),
                    ),
                    Text(
                      " • ${investOperation.amount}",
                      style: FinFont.medium.copyWith(
                          fontSize: 12, color: FinColor.secondaryText),
                    ),
                  ],
                ),
                Text(
                  investOperation.price.formatMoney(currency: "\$"),
                  style: FinFont.regular.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              investOperation.totalPrice().formatMoney(currency: "\$"),
              style: FinFont.semibold.copyWith(
                fontSize: 14,
                color: investOperation.totalPrice().priceColor(),
              ),
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
