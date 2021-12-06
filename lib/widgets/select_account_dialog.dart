import 'package:ej_selector/ej_selector.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';

Future<void> showSelectAccountDialog(
  BuildContext context,
  List<Account> accounts,
) async {
  final selectedItem = await showEJDialog<int>(
    context: context,
    selected: context.read<Operation>().accountId,
    selectedWidgetBuilder: (selectedId) => Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(
        accounts.firstWhere((element) => element.id == selectedId).name,
        style: FinFont.medium.copyWith(fontSize: 20, color: FinColor.mainColor),
      ),
    ),
    items: accounts
        .map(
          (item) => EJSelectorItem(
            value: item.id,
            widget: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Text(
                accounts.firstWhere((element) => element.id == item.id).name,
                style: FinFont.medium
                    .copyWith(fontSize: 16, color: FinColor.secondaryText),
              ),
            ),
          ),
        )
        .toList(),
  );
  if (selectedItem != null) {
    context.read<Operation>().selectAccount(selectedItem.value);
  }
}
