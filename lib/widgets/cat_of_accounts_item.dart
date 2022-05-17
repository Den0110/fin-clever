import 'package:fin_clever/data/models/account.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class CatEntry {
  final String date;
  final List<Account> accounts;

  CatEntry(this.date, this.accounts);
}

class CatOfAccountsItem extends StatelessWidget {
  const CatOfAccountsItem({Key? key, required this.dayEntry}) : super(key: key);

  final CatEntry dayEntry;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayEntry.date,
              style: FinFont.bold.copyWith(fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dayEntry.accounts.length,
                  itemBuilder: (c, i) => account(dayEntry.accounts[i]),
                  separatorBuilder: (c, i) => divider,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row account(Account account) {
    final moneyFormat = NumberFormat("#,##0.00₽", "en_US");
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
            account.type.icon,
            size: 16,
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
                  account.name,
                  style: FinFont.medium.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              moneyFormat.format(account.balance),
              style: FinFont.semibold.copyWith(
                fontSize: 14,
                color: FinColor.darkBlue,
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
